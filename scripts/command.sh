#!/bin/bash

set -e
command=$1
path=$2

if [ -z "$command" ]; then
    echo "[ACTION]: Command is not defined."
    exit 1
fi

path_value=${path%?}
if [ -n "$path_value" ]; then
    echo "[ACTION]: Changing directory to $path_value."
    cd "$path_value"
fi

echo "[ACTION]: Running command $command."
eval $command
