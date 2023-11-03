#!/bin/bash
c=0
d=0
e=0
echo "provide file name for subject list"
read csv_name
ids=$path/subject_lists/$csv_name

dir=$path


# echo 'Id,reason' >> $noflair
for i in $( cat $ids ); do
    cd $dir/subjects/$i

#single item if statement
	if [ -d "dti_FA_to_MNI.nii.gz" ]; then
		d=$(($d + 1))
	fi
#checking for several conditions
	if [[ -f "t1_inp.nii.gz" && ! -f "t2flair.nii.gz" ]]; then
    echo $i
		e=$(($e + 1))
	fi
    cd $dir/subjects
done

 echo $e
