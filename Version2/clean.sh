#!/bin/bash
echo "Name of network? "
read m
sed 's/ //' $1 | sed 's/[^0-9 ]*//g' | sed 's/[[:space:]]*$//'  | sed 's/ /,/g' >> $path/data/$m.csv
