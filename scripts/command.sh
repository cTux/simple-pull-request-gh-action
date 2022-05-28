#!/bin/bash

set -e
command=$1

if [ -z "$command" ]; then
    echo "[ACTION]: Command is not defined."
    exit 1
fi

echo "[ACTION]: Running command $command."
eval $command
