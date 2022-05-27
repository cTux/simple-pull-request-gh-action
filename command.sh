#!/bin/bash

set -e
command=$1
path=$2

if [ -z "$command" ]; then
    echo "Command is not defined."
    exit 1
fi

path_value=${path%?}
if [ -n "$path_value" ]; then
    echo "Change directory to $path_value."
    cd "$path_value"
fi

echo "Running command $command."
eval $command
