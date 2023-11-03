#!/bin/bash
echo "provide file name for subject list"
read csv_name
ids=$path/subject_lists/$csv_name
echo "provide file name for where to save missing ids"
read csv_name
missing_ids=$path/subject_lists/$csv_name
dir=$path
echo $dir
for i in $( cat $ids ); do
	if [ ! -d "$dir/subjects/$i" ]; then
 		echo $i >> $missing
	fi
done


