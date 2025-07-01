#!/usr/bin/env bash

# readx-test.sh - Test script for readx

source ./readx

while true; do
    #read -e -p "input: " input
    readx -p "input: " input
    if [[ -z "$input" ]]; then
        echo "Exit."
        break
    fi
    history -s "$input"
    echo "You entered: $input"
done
