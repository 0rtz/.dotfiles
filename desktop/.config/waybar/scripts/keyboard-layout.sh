#!/bin/bash

set -euo pipefail

get_layout() {
    hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap'
}

case "$(get_layout)" in
    "English (US)") echo "🇺🇸" ;;
    "Russian") echo "🇷🇺" ;;
    *) echo "?" ;;
esac