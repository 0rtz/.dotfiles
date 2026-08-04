#!/usr/bin/bash
set -euo pipefail

# Colors
COLOR_OK="#89b4fa"
COLOR_WARN="#f38ba8"
COLOR_RESET="#[fg=default]"

# Thresholds
CPU_WARN=80        # %
TEMP_WARN=80       # °C
RAM_WARN=80        # %
DISK_WARN=85       # %

# RAM
# shellcheck disable=SC2034
read -r RAM_USED RAM_TOTAL RAM_PCT <<<"$(
free --total |
awk '/^Total:/ {
  used=$3; total=$2;
  printf "%d %d %d\n", used, total, int(used*100/total)
}'
)"
RAM_HUMAN=$(free --total --human | awk '$1=="Total:" { printf "%s/%s", $3, $2 }')
RAM_COLOR=$COLOR_OK
(( RAM_PCT >= RAM_WARN )) && RAM_COLOR=$COLOR_WARN

# DISK
# shellcheck disable=SC2034
read -r DISK_USED DISK_TOTAL DISK_PCT <<<"$(
df -P "$PWD" |
awk 'NR==2 {
  gsub("%","",$5);
  printf "%d %d %d\n", $3, $2, $5
}'
)"
DISK_HUMAN=$(df -h "$PWD" | awk 'NR==2 { print $3"/"$2 }')
DISK_COLOR=$COLOR_OK
(( DISK_PCT >= DISK_WARN )) && DISK_COLOR=$COLOR_WARN

# CPU temperature
ZONE_TYPE="x86_pkg_temp"
ZONE=$(grep -l "$ZONE_TYPE" /sys/class/thermal/thermal_zone*/type | head -n1)
if [[ -n "$ZONE" ]]; then
    TEMP_RAW=$(<"${ZONE%/type}/temp")
    TEMP=$((TEMP_RAW / 1000))
else
    TEMP=0
fi
TEMP_COLOR=$COLOR_OK
(( TEMP >= TEMP_WARN )) && TEMP_COLOR=$COLOR_WARN

# CPU usage
CPU_RAW=$(awk '
{u=$2+$3+$4+$6+$7+$8; t=u+$5}
NR==1{u0=u; t0=t}
NR==2{print int(100*(u-u0)/(t-t0))}
' <(grep '^cpu ' /proc/stat) <(sleep 0.5; grep '^cpu ' /proc/stat))

CPU_COLOR=$COLOR_OK
(( CPU_RAW >= CPU_WARN )) && CPU_COLOR=$COLOR_WARN

# Final statusbar
echo "\
#[fg=$CPU_COLOR,bold]󰍛$COLOR_RESET ${CPU_RAW}%  \
#[fg=$TEMP_COLOR,bold]$COLOR_RESET ${TEMP}°C  \
#[fg=$RAM_COLOR,bold]$COLOR_RESET $RAM_HUMAN  \
#[fg=$DISK_COLOR,bold]󰋊$COLOR_RESET $DISK_HUMAN\
"
