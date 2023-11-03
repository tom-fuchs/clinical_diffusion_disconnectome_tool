#!/bin/bash
a=0
b=0
nodir=0

echo "provide file name for ms subject list"
read csv_name_ms
lst=$path/subject_lists/$csv_name_ms

dir=$path

for i in $( cat $lst ); do
    sub_id=`echo  $i | cut -d"," -f1`
    ex_id=`echo $i | cut -d"," -f2`
    cd $dir/study_scans/$sub_id/$ex_id/diffusion
    
	if [ -f "masked_final_deviation.nii.gz" ]; then
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
