#!/bin/bash
# Core utilities: error handling, dependency checks

die() {
	printf '\033[1;31mERROR:\033[0m %s\n' "$1" >&2
	exit "${2:-1}"
}

require_cmd() {
	local cmd
	for cmd in "$@"; do
		command -v "$cmd" &>/dev/null || die "'$cmd' is required but not found"
	done
}