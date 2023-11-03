#!/bin/bash

USER=$1

processes=$(ps aux | grep -i "$USER" | cut -d' ' -f 2)

for process in $processes;
do
    kill -9 $process
    echo "Killed $process"
done
