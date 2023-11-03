#!/bin/bash

echo "provide file name for list of scan IDs"
read ids
echo "provide path to source directory of files"
read source_dir
echo "provide file name that you want to move 1"
read file_name1
echo "provide file name that you want to move 2 "
read file_name2
echo "provide file name that you want to move 3"
read file_name3
echo "provide file name that you want to move 4"
read file_name4
echo "provide file name that you want to move 5"
read file_name5
lst_to_move=$path/subject_lists/$ids
#to change:
src_dir=$source_dir

dest_dir=$path/subjects
dir=$path

cd $src_dir

for i in $( cat $lst_to_move); do
    echo $i
    mkdir $dest_dir/$i
    cd $src_dir/$i
    if [ -f $file_name1 ]; then
		cp $file_name1 $dest_dir/$i
	fi
    if [ -f $file_name2 ]; then
		cp $file_name2 $dest_dir/$i
	fi
    if [ -f $file_name3 ]; then
		cp $file_name3 $dest_dir/$i
	fi
    if [ -f $file_name4 ]; then
		cp $file_name4 $dest_dir/$i
	fi
    if [ -f $file_name5 ]; then
		cp $file_name5 $dest_dir/$i
	fi
#     cp $file_name2 $dest_dir/$i
#     cp $file_name3 $dest_dir/$i
#     cp $file_name4 $dest_dir/$i
#     cp $file_name5 $dest_dir/$i
    cd $src_dir
    
done

