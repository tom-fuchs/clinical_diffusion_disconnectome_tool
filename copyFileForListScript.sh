#!/bin/bash

echo "provide file name for list of scan IDs"
read ids
echo "provide path to source directory of files"
read source_dir
echo "provide file name that you want to move"
read file_name

lst_to_move=$path/subject_lists/$ids
#to change:
src_dir=$source_dir

dest_dir=$path/subjects
dir=$path

cd $src_dir

for i in $( cat $lst_to_move); do

    if [ ! -d $src_dir/$i ]; then
		continue
	fi
    cd $src_dir/$i
    echo $i
    if [ ! -f $dest_dir/$i/$file_name1 ]; then
		cp $file_name $dest_dir/$i
	fi
    cd $src_dir
    
done

