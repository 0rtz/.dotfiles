#!/bin/bash
# Entry point — sources all library modules
# Usage: source $HOME/usr/bin/my-scripts-lib/init.sh

_MY_SCRIPTS_LIB=$HOME/usr/bin/my-scripts-lib

# shellcheck source=core.sh
source "${_MY_SCRIPTS_LIB}/core.sh"
# shellcheck source=ui.sh
source "${_MY_SCRIPTS_LIB}/ui.sh"
# shellcheck source=pkg.sh
source "${_MY_SCRIPTS_LIB}/pkg.sh"
