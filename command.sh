#!/bin/bash

set -e
command=$1
path=$2

path_value=${path%?}
if [ -n "$path_value" ]; then
    echo "Change directory to $path_value."
    cd "$path_value"
fi

echo "Running command $command."
eval $command
