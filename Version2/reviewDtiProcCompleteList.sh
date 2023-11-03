#!/bin/bash

echo "provide file name for HC subject list"
read hc_list
hc_path=$path/subject_lists/$hc_list

echo "provide file name for output of HC list, after review"
read hc_out
save_hc=$path/subject_lists/$hc_out

echo "provide file name for MS subject list"
read ms_list
ms_path=$path/subject_lists/$ms_list

echo "provide file name for output of MS list, after review"
read ms_out
save_ms=$path/subject_lists/$ms_out

dir=$path

for i in $( cat $hc_path ); do
    sub_id=`echo  $i | cut -d"," -f1`
    ex_id=`echo $i | cut -d"," -f2`
    cd $dir/study_scans/$sub_id/$ex_id/diffusion
    
	echo "before check file" + $i
	if [ -f "dti_FA_to_MNI.nii.gz" ]; then
		echo $i >> $save_hc
	fi
	cd $dir
done

for i in $( cat $ms_path ); do
    sub_id=`echo  $i | cut -d"," -f1`
    ex_id=`echo $i | cut -d"," -f2`
    cd $dir/study_scans/$sub_id/$ex_id/diffusion
    
	echo "before check file" + $i
	if [ -f "dti_FA_to_MNI.nii.gz" ]; then
		echo $i >> $save_ms
	fi
	cd $dir
done
