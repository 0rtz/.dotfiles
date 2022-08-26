#!/bin/bash

DISPLAY_SERVER_TYPE=$(swaymsg -t get_tree | jq -r '.. | select(.type?) | select(.focused==true) | .shell')

if [[ "$DISPLAY_SERVER_TYPE" == "xwayland" ]]; then
	echo "X11"
else
	echo ""
fi
