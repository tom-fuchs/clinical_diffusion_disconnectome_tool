# Files:
# t1.nii.gz
# dti15.nii.gz
# dti15.dcmdir.tgz
#
# Optional files:
# t1hires_brain_mask_manual.nii.gz

all: dti15_FA.nii.gz dti15_FA_to_MNI.nii.gz 
#dti15_FA.nii.gz 
# dti21-25_FA.ni.gz


# Also makes dti15.bvals
dti15.bvecs: dti15.dcmdir.tgz
	mkdir -p tmp
	cd tmp && tar zxvf ../dti15.dcmdir.tgz && dcm2nii *
	cd tmp/* && mv `find .| grep bvec` ../../dti15.bvecs 	
	cd tmp/* && mv `find .| grep bval` ../../dti15.bvals  
	rm -rf tmp

# Also makes dti15_brain.nii.gz
dti15_brain_mask.nii.gz: dti15_prelim_b0.nii.gz
	bet dti15_prelim_b0.nii.gz dti15_brain -m -f 0.2

dti15.acqp: 
	echo "1 0 0 0.05" > dti15.acqp

dti15.index: 
	echo "1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1" > dti15.index


dti15_eddy.nii.gz: dti15.nii.gz dti15_brain_mask.nii.gz dti15.acqp \
	dti15.index dti15.bvecs
	eddy --imain=dti15.nii.gz --mask=dti15_brain_mask.nii.gz --index=dti15.index \
	--acqp=dti15.acqp --bvecs=dti15.bvecs --bvals=dti15.bvals --out=dti15_eddy


dti15_FA.nii.gz: dti15_eddy.nii.gz dti15_brain_mask.nii.gz dti15.bvecs dti15.bvals
	dtifit -k dti15_eddy.nii.gz -o dti15 -m dti15_brain_mask.nii.gz -r dti15.bvecs -b dti15.bvals

	
#TODO: It would be better to determine the b0s automatically from
# the bvals file
dti15_b0.nii.gz: dti15_eddy.nii.gz
	fslroi dti15_eddy.nii.gz dti15_b0.nii.gz 0 1

#TODO: It would be better to determine the b0s automatically from
# the bvals file
dti15_prelim_b0.nii.gz: dti15.nii.gz
	fslroi dti15.nii.gz dti15_prelim_b0.nii.gz 0 1

t1_corrected.nii.gz: t1.nii.gz
	N4BiasFieldCorrection \
	-d 3 \
	-i t1.nii.gz \
	-o t1_corrected.nii.gz 

t1_corrected2.nii.gz: t1_corrected.nii.gz
	N4BiasFieldCorrection \
	-d 3 \
	-i t1_corrected.nii.gz \
	-o t1_corrected2.nii.gz 


t1hires_brain.nii.gz: t1_corrected2.nii.gz
	bet2 t1_corrected2.nii.gz t1hires_brain -f 0.2 -m

dti15brain_to_t1hiresbrain1Warp.nii.gz: t1hires_brain.nii.gz dti15_brain.nii.gz
	antsRegistrationSyN.sh \
	-d 3 \
	-f t1hires_brain.nii.gz \
	-m dti15_brain.nii.gz \
	-o dti15brain_to_t1hiresbrain \
	-n 32
	
dti15_FA_to_MNI.nii.gz: dti15brain_to_t1hiresbrain1Warp.nii.gz T1toMNI1Warp.nii.gz \
	dti15_FA.nii.gz T1toMNI0GenericAffine.mat dti15brain_to_t1hiresbrain0GenericAffine.mat 
	antsApplyTransforms \
	-d 3 \
	-i dti15_FA.nii.gz \
	-r FSL_MNI152_FreeSurferConformed_1mm_head.nii.gz \
	-o dti15_FA_to_MNI.nii.gz \
	-t T1toMNI1Warp.nii.gz \
	-t T1toMNI0GenericAffine.mat \
	-t dti15brain_to_t1hiresbrain1Warp.nii.gz \
	-t dti15brain_to_t1hiresbrain0GenericAffine.mat 
#Doesn't work, nonessential, for sanity check
#dti15_V1_to_MNI.nii.gz: dti15brain_to_t1hiresbrain1Warp.nii.gz T1toMNI1Warp.nii.gz \
	dti15_V1.nii.gz T1toMNI0GenericAffine.mat dti15brain_to_t1hiresbrain0GenericAffine.mat
#	antsApplyTransforms \
	-d 3 \
	-i dti15_V1.nii.gz \
	-r FSL_MNI152_FreeSurferConformed_1mm_head.nii.gz \
	-o dti15_V1_to_MNI.nii.gz \
	-t T1toMNI1Warp.nii.gz \
	-t T1toMNI0GenericAffine.mat \
	-t dti15brain_to_t1hiresbrain1Warp.nii.gz \
	-t dti15brain_to_t1hiresbrain0GenericAffine.mat 


dti15_FA_to_t1hires.nii.gz: dti15brain_to_t1hiresbrain1Warp.nii.gz dti15_FA.nii.gz t1hires_brain.nii.gz
	antsApplyTransforms \
	-d 3 \
	-i dti15_FA.nii.gz \
	-r t1hires_brain.nii.gz \
	-o dti15_FA_to_t1hires.nii.gz \
	-t dti15brain_to_t1hiresbrain1Warp.nii.gz \
	-t dti15brain_to_t1hiresbrain0GenericAffine.mat \
	-v 0 \
	-n Linear

#ifeq ($(wildcard t1hires_brain_mask_manual.nii.gz),t1hires_brain_mask_manual.nii.gz) 
#t1hires_brain_mask.nii.gz: t1hires.nii.gz t1hires_brain_mask_manual.nii.gz
#	ln -s t1hires_brain_mask_manual.nii.gz t1hires_brain_mask.nii.gz
#	fslmaths t1hires.nii.gz -mas t1hires_brain_mask.nii.gz t1hires_brain.nii.gz
#else
#t1hires_brain_mask.nii.gz: t1.nii.gz
#	bet t1.nii.gz t1hires_brain -m 
#endif 
