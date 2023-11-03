#!/bin/bash
a=0
b=0
echo "provide file name for subject list"
read csv_name
ids=$path/subject_lists/$csv_name

echo "provide file name you are checking"
read csv_name
file_to_check=$path/subject_lists/$csv_name

dir=$path


# echo 'Id,reason' >> $noflair
for i in $( cat $ids ); do
    cd $dir/subjects/$i

#single item if statement
	if [ -f 't1_inp.nii.gz' ]; then
		a=$(($a + 1))
	fi
	b=$(($b + 1))

    cd $dir/subjects
done

echo $a have it
echo $b total
