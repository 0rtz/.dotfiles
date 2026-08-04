#!/bin/bash

set -euo pipefail

DISPLAY_SERVER_TYPE=""

if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
	if [[ "$(hyprctl activewindow -j | jq -r '.xwayland')" == "true" ]]; then
		DISPLAY_SERVER_TYPE="xwayland"
	fi
elif [ -n "${SWAYSOCK:-}" ]; then
	DISPLAY_SERVER_TYPE=$(swaymsg -t get_tree | jq -r '[.. | select(.type?) | select(.focused==true) | .shell] | first // empty')
fi

if [[ "$DISPLAY_SERVER_TYPE" == "xwayland" ]]; then
	printf '{"text": "", "class": "warning"}\n'
else
	printf '{"text": ""}\n'
fi
