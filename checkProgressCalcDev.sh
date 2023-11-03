#!/bin/bash
a=0
b=0
nodir=0

echo "provide file name for ms subject list"
read csv_name_ms
ids=$path/subject_lists/$csv_name_ms

dir=$path

for i in $( cat $ids ); do
	cd $dir/subjects/$i
	if [ -f "masked_final_deviation_fsmni.nii.gz" ]; then
		a=$(($a + 1))
	else
		b=$(($b + 1))
	fi
	cd $dir
done
echo
echo "========================summary========================="
echo
if [ -d "$dir/calculations" ]; then
	echo "HC done processing"
	echo $b ms scans currently processing
else
	echo "HC currently processing"
	echo $b ms scans to be processed
fi
echo $a ms scans processed




# echo $b scans in progress in makefile
