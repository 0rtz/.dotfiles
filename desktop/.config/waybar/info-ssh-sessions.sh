#!/bin/sh

sessions="$(lsof -Pi | grep ":22")"

if [ -n "$sessions" ]; then
	count=$(echo "$sessions" | wc -l)
	echo "󰒍($count)"
else
	echo ""
fi
