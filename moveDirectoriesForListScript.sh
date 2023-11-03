#!/bin/bash

echo "provide file name for list of scan IDs"
read ids
echo "provide path to source directory of files"
read source_dir

lst_to_move=$path/subject_lists/$ids
#to change:
src_dir=$source_dir

dest_dir=$path/subjects
dir=$path
cd $src_dir

for i in $( cat $lst_to_move); do
    cp -R $src_dir/$i $dest_dir
done
