#!/bin/bash

echo "provide file name for subject list (with file extension)"
read csv_name
ids=$path/subject_lists/$csv_name

echo "provide file name to save missing IDs (with file extension)"
read csv_name
missing_ids=$path/subject_lists/$csv_name

dir=$path

for i in $( cat $ids ); do
    sub_id=`echo  $i | cut -d"," -f1`
    ex_id=`echo $i | cut -d"," -f2`

	if [ ! -d "$dir/study_scans/$sub_id/$ex_id/diffusion" ]; then
		echo $i >> $missing_ids
	fi
done


