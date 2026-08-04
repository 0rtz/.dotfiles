#!/bin/bash

set -euo pipefail

# Toggle a hyprland special workspace, launching the app if workspace is empty.
# Usage: toggle-special-workspace.sh <workspace_name> <launch_command>

WORKSPACE_NAME="${1:?Usage: toggle-special-workspace.sh <workspace_name> <launch_command>}"
LAUNCH_CMD="${2:?Usage: toggle-special-workspace.sh <workspace_name> <launch_command>}"

if hyprctl clients -j | jq -e ".[] | select(.workspace.name == \"special:${WORKSPACE_NAME}\")" >/dev/null; then
    hyprctl eval "hl.dispatch(hl.dsp.workspace.toggle_special(\"${WORKSPACE_NAME}\"))"
else
    $LAUNCH_CMD
fi
