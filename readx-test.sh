#!/usr/bin/env bash

source ./readx

while true; do
    #read -e -p "input: " input
    readx -p "input: " input
    if [[ "$input" == "exit" ]]; then
        echo "Exiting loop."
        break
    fi
    history -s "$input"
    echo "You entered: $input"
done
