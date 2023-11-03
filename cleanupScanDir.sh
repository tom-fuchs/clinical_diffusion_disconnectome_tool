#!/bin/bash

echo "provide file name for list of scan IDs"
read ids

lst_to_move=$path/subject_lists/$ids
#to change:
src_dir=$source_dir

dest_dir=$path/subjects
dir=$path

cd $src_dir

for i in $( cat $lst_to_move); do
    cd $src_dir/$i

   
done

###To keep:
dti.acqp
dti_brain_mask.nii.gz
dti_brain.nii.gz
dti.dcmdir.tgz
dti_eddy.nii.gz
dti_FA.nii.gz
dti_FA_to_MNI.nii.gz
dti_FA_to_t1.nii.gz
dti.index
flair_reorient_robust_n4.nii.gz
flair_to_t1.mat
flair_to_t1.nii.gz
flair.nii
dti.nii.gz
dti.bvals
dti.bvecs
lesion_mask.nii.gz
lesion_mask_t1.nii.gz
t1_brain_masked.nii.gz
MNI_brain.nii.gz
mni_mask.nii.gz
FSL_MNI152_FreeSurferConformed_1mm_head.nii.gz
t2flair.nii.gz
t1_inp_n4_2.nii.gz
t1_inp.nii.gz
t1.nii.gz
t1_reorient_robust_n4_brain_mask.nii.gz
t1_reorient_robust_n4_brain.nii.gz

####To remove:
dti_L1.nii.gz
dti_L2.nii.gz
dti_L3.nii.gz
dti_MD.nii.gz
dti_MO.nii.gz
dti_S0.nii.gz
dti_V1.nii.gz
dti_V2.nii.gz
dti_V3.nii.gz
flair_iso.nii.gz
dti_prelim_b0.nii.gz
dti.dimension
dti_eddy.eddy_movement_rms
dti_eddy.eddy_outlier_map
dti_eddy.eddy_outlier_n_stdev_map
dti_eddy.eddy_outlier_report
dti_eddy.eddy_parameters
dti_eddy.eddy_post_eddy_shell_alignment_parameters
dti_eddy.eddy_rotated_bvecs
flair_reorient.nii.gz
flair_reorient_robust.nii.gz
nabtseg_mixeltype.nii.gz
nabtseg_pve_0.nii.gz
nabtseg_pve_1.nii.gz
nabtseg_pve_2.nii.gz
nabtseg_pveseg.nii.gz
nabtseg_seg.nii.gz
lpa_mask_prelim.nii.gz
lpa_mflair.nii
LST_lpa_mflair.mat
mflair.nii
t1_reorient_robust_n4.nii.gz
t1_reorient_robust.nii.gz
t1_bet_mask.nii.gz
t1_bet.nii.gz
t1_inp_inneronly.nii.gz
t1_inp_n4_1.nii.gz
t1_reorient.nii.gz
t1_reorient_robust_n4_brain_skull.nii.gz

###unsure:
dtibrain_to_t1brain0GenericAffine.mat
dtibrain_to_t1brain1InverseWarp.nii.gz
dtibrain_to_t1brain1Warp.nii.gz
dtibrain_to_t1brainWarped.nii.gz
t1mni0GenericAffine.mat
t1mni1Warp.nii.gz
t1mniWarped.nii.gz
T1toMNI0GenericAffine.mat
T1toMNI1InverseWarp.nii.gz
T1toMNI1Warp.nii.gz
T1toMNIWarped.nii.gz

