#!/bin/bash
c=0
d=0
e=0
echo "provide file name for subject list"
read csv_name
lst=$path/subject_lists/$csv_name

dir=$path


# echo 'Id,reason' >> $noflair
for i in $( cat $lst ); do
    sub_id=`echo  $i | cut -d"," -f1`
    ex_id=`echo $i | cut -d"," -f2`
 
	if [ ! -d "$dir/study_scans/$sub_id/$ex_id/diffusion" ]; then
		echo $i 
	fi
# 	if [[ -f "dti.nii.gz" && -f "dti.dcmdir.tgz" && -f "t1.nii.gz" ]]; then
# 		if [[ -f "t1_inp.nii.gz" || -f "t2flair.dcmdir.tgz" ]]; then
# 			c=$(($c + 1))
# 			echo $i >> $hc
# 		fi
# 	fi
# echo "before check file" + $i
# 	if [ -f "dti_FA_to_MNI.nii.gz" ]; then
# 		d=$(($d + 1))
# 		echo $i >> $saveto
# 	fi
# echo "after check file"
# 	if [ ! -f "t1.nii.gz" ]; then
# 		e=$(($e + 1))
# 	fi
#Sample conditional for multiple statements
#[[ ! -f "t1_inp.nii.gz" && ! -f "t2flair.nii.gz" ]]
done

# echo $d is the count
