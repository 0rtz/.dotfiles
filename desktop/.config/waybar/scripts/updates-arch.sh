#!/bin/bash

set -euo pipefail

if ! updates_arch=$(checkupdates 2> /dev/null | wc -l); then
	updates_arch=0
fi

all_count=$(pacman -Q | wc -l)
# 10% of packages outdated
threshold=$((10 * all_count / 100))

if [ "$updates_arch" -gt "$threshold" ]; then
	printf '{"text": "(%s)", "tooltip": "%s updates available (threshold: %s)", "class": "updates"}\n' "$updates_arch" "$updates_arch" "$threshold"
else
	printf '{"text": ""}\n'
fi