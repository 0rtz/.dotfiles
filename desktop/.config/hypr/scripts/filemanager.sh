#!/bin/bash

set -euo pipefail

"$(dirname "$0")/toggle-special-workspace.sh" filemanager "nautilus --new-window"
