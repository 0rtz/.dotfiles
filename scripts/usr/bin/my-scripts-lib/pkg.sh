#!/bin/bash
# Package manager detection and helpers
# shellcheck disable=SC2034

_my_pkg_manager=""

detect_pkg_manager() {
	[[ -n "$_my_pkg_manager" ]] && return 0

	if command -v pacman &>/dev/null; then
		_my_pkg_manager="pacman"
	elif command -v apt &>/dev/null; then
		_my_pkg_manager="apt"
	elif command -v dnf &>/dev/null; then
		_my_pkg_manager="dnf"
	elif command -v zypper &>/dev/null; then
		_my_pkg_manager="zypper"
	else
		echo "ERROR: No supported package manager found" >&2
		return 1
	fi
}

packages_list_names() {
	detect_pkg_manager || return 1
	case "$_my_pkg_manager" in
		pacman) pacman -Qq ;;
		apt)    dpkg-query -W -f='${Package}\n' ;;
		dnf)    rpm -qa --qf '%{NAME}\n' ;;
		zypper) zypper se -i | tail -n +5 | awk '{print $3}' ;;
	esac
}
