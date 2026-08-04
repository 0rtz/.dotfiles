#!/bin/bash
# UI helpers: colored output, headings

print_heading_blue() {
	printf '\033[1;34m%s\033[0m\n' "$1"
}
