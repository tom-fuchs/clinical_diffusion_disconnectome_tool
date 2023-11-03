#!/bin/bash
a=0
b=0
c=0
d=0
e=0
f=0
g=0
h=0

echo "provide file name for subject list"
read csv_name
ids=$path/subject_lists/$csv_name


dir=$path

for i in $( cat $ids ); do
	cd $dir/subjects/$i
	if [ -f "dti_FA_to_MNI.nii.gz" ]; then
		a=$(($a + 1))
	elif [[ ! -f "t1_inp.nii.gz" && ! -f "t2flair.nii.gz" ]]; then
		f=$(($f + 1))
	elif [[ ! -f "dti.nii.gz" && ! -f "dti.dcmdir.tgz" ]]; then
		h=$(($h + 1))
	elif [ ! -f "t1.nii.gz" ]; then
		e=$(($e + 1))
	elif [ -f "dti_brain.nii.gz"  ]; then
		b=$(($b + 1))
	elif [ -f "lesion_mask.nii.gz"  ]; then
		c=$(($c + 1))
	elif [[ ! -f "t1_inp.nii.gz" && -f "t2flair.nii.gz" ]]; then
		g=$(($g + 1))
	else
		d=$(($d + 1))
	fi
	cd $dir
done
echo
echo "========================summary========================="
echo
echo $a scans done
echo $(($c+$d)) yet to be processed by makefile
echo $(($e + $f + $g+ $h )) total scans can not be processed, missing files or errors
echo
echo "==========breakdown of future processing================"
echo
echo $c scans processed for lesion mask
echo $d scans not started for makefile, but not need lesion
echo
echo "=============breakdown of un-processed=================="
echo
echo $h can not be processed, no dti or dicom
echo $e can not be processed, no t1
echo $f can not be processed,no flair to create t1_inp
echo $g scans need to be processed for LPA, might never reach 0


# echo $b scans in progress in makefile
