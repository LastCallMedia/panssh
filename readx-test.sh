#!/usr/bin/env bash

# readx-test.sh - Test script for readx

source ./readx.source.sh || exit 1

readonly READX="readx"
#readonly READX="read -e -r"

while true; do
    if $READX -p "input: " input; then
        if [[ "$input" == "exit" ]]; then
            exit 0
        elif [[ -n "$input" ]]; then
            history -s "$input"
            echo "You entered: $input"
        fi 
    else
        status=$?
        echo "readx exited with status $status"
        exit $status
    fi
done
