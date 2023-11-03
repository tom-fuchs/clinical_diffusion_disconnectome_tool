#!/bin/bash

dir=$path

export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=1

echo "Utilize how many cores? "
read num

mnibrain={$1:-/shared/nonrestricted/connectome/NeMo/mni/MNI152_T1_1mm_brain.nii.gz}
mnihead={$2:-/shared/nonrestricted/connectome/NeMo/mni/FSL_MNI152_FreeSurferConformed_1mm_head.nii.gz}

echo "Provide file name where to log errors (with file extension)"
read log_file
issues=$dir/subject_lists/$log_file
 
echo "Provide file name for ms subject list (with file extension)"
read ms_list

echo "Provide file name for all ids subject list (with file extension)"
read all_list

[ -d $dir/calculations ] && ids=$dir/subject_lists/$ms_list || ids=$dir/subject_lists/$all_list

echo ""
echo "Running inpainted on all scans..."

for i in $( cat $ids ); do
#cd into each subject's directory and create the t1_inp
    cd $dir/subjects/$i
    if [[ ! -f "t1_inp.nii.gz" && ! -f "lesion_mask.nii.gz" ]]; then
        make -f $DTIPATH/scripts/LPA_makefile
    fi
    cd $DTIPATH
done

echo ""
echo "Running t1_inp makefile on all scans..."

#creates the t1_inpained if it does not exit, if it does nothing happens for that id
for i in $( cat $ids ); do
	cd $dir/subjects/$i
	if [[ ! -f "lesion_mask.nii.gz" ]]; then
		echo $i+"error in processing in t1_inpainted" >> $issues
		continue
	elif [[ ! -f "t1_inp.nii.gz" && -f "t1.nii.gz" ]]; then
		sem --env ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS -j $num make -f $DTIPATH/scripts/T1_makefile MNI_brain.nii.gz=$mnibrain FSL_MNI152_FreeSurferConformed_1mm_head.nii.gz=$mnihead
	fi
	cd $dir/subjects
done

echo ""
echo "Running makefile on all scans..."


for i in $( cat $ids ); do
	cd $dir/subjects/$i
    
	echo $i+": attempting processing" >> $issues
    
	if [[ ! -f "t1_inp.nii.gz" && ! -f "lesion_mask.nii.gz" ]]; then
	echo $i+": no inpainted and no lesion mask" >> $issues
	cd $DTIPATH
	continue
	elif [[ ! -f "t1_inp.nii.gz" && -f "t1.nii.gz" ]]; then
	echo $i+": inpainted not created" >> $issues
	cd $DTIPATH
	continue
	elif [ ! -f "dti.nii.gz" ]; then
	echo $i+": no dti" >> $issues
	cd $DTIPATH
	continue
	elif [ ! -f "dti.dcmdir.tgz" ]; then
	echo $i+": no dicom" >> $issues
	cd $DTIPATH
	continue
	elif [ -f "dti_FA_to_MNI.nii.gz" ]; then
	cd $DTIPATH
	continue
	fi

	echo $i+" about to run makefile"    
	sem --env ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS -j $num make -f $DTIPATH/scripts/Makefile MNI_brain.nii.gz=$mnibrain FSL_MNI152_FreeSurferConformed_1mm_head.nii.gz=$mnihead

	if [ ! -f "dti_FA_to_MNI.nii.gz" ]; then
	echo $i+"error in processing" >> $issues
	fi
	echo $i+"finished processing" >> $issues
	cd $DTIPATH
done

sem --wait

echo ""
echo "------------"
echo "To view images for quality control, run"
echo "> bash Quality_check.sh"
echo "------------"
echo ""
