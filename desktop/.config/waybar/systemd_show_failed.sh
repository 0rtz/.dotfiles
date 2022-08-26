#!/bin/bash

FAILED=$(systemctl --quiet --failed | wc -l)
USER_FAILED=$(systemctl --quiet --user --failed | wc -l)
TOTAL=$((FAILED + USER_FAILED))

if [[ $TOTAL -gt 0 ]]; then
	echo -e "($TOTAL)\nUser: $USER_FAILED; System: $FAILED"
fi
