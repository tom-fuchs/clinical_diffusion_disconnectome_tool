# Files:
# t1_inp.nii.gz
# t1.nii.gz
# dti.nii.gz
# dti.dcmdir.tgz


all: dti_FA_to_MNI.nii.gz 

#used to generate brain mask
MNI_brain.nii.gz:
	cp /shared/nonrestricted/connectome/NeMo/mni/MNI152_T1_1mm_brain.nii.gz ./MNI_brain.nii.gz	

#used for registration 
FSL_MNI152_FreeSurferConformed_1mm_head.nii.gz:
	cp /shared/nonrestricted/connectome/NeMo/mni/FSL_MNI152_FreeSurferConformed_1mm_head.nii.gz .       

########## to make t1_brain_masked.nii.gz #########################

t1_bet.nii.gz: t1_inp_n4_2.nii.gz
	bet t1_inp_n4_2.nii.gz t1_bet -m


t1mniWarped.nii.gz: t1_bet.nii.gz MNI_brain.nii.gz
	antsRegistration \
	--dimensionality 3 \
	--float 0 \
	--output [t1mni,t1mni1Warp.nii.gz,t1mniWarped.nii.gz,t1mni0GenericAffine.mat] \
	--interpolation Linear \
	--winsorize-image-intensities [0.005,0.995] \
	--use-histogram-matching 0 \
	--initial-moving-transform [MNI_brain.nii.gz,t1_bet.nii.gz,1] \
	--transform Affine[0.1] \
	--metric MI[MNI_brain.nii.gz,t1_bet.nii.gz,1,32,Regular,0.25] \
	--convergence [1000x500x250x100,1e-6,10] \
	--shrink-factors 8x4x2x1 \
	--smoothing-sigmas 3x2x1x0vox

mni_mask.nii.gz: t1mniWarped.nii.gz
	fslmaths t1mniWarped.nii.gz -bin mni_mask.nii.gz

t1_brain_masked.nii.gz: t1_inp_n4_2.nii.gz mni_mask.nii.gz
	fslmaths t1_inp_n4_2.nii.gz -mas mni_mask.nii.gz t1_brain_masked.nii.gz

#################### Files for Eddy ################################

# Also makes dti.bvals
dti.bvecs: dti.dcmdir.tgz
	mkdir -p tmp
	cd tmp && tar zxvf ../dti.dcmdir.tgz && dcm2nii *
	cd tmp/* && mv `find .| grep bvec` ../../dti.bvecs 	
	cd tmp/* && mv `find .| grep bval` ../../dti.bvals  
	rm -rf tmp

dti_prelim_b0.nii.gz: dti.nii.gz
	fslroi dti.nii.gz dti_prelim_b0.nii.gz 0 1
    
# Also makes dti_brain_mask.nii.gz
dti_brain.nii.gz: dti_prelim_b0.nii.gz
	bet dti_prelim_b0.nii.gz dti_brain -m -f 0.2

dti.dimension: dti.nii.gz
	fslval dti.nii.gz dim4 >> dti.dimension

dti.acqp: dti.dimension
	if grep "52" dti.dimension; then echo "-1 0 0 0.0867" >> dti.acqp;\
	fi
	if grep "60" dti.dimension; then echo "0 -1 0 0.0931" >> dti.acqp;\
	fi
	if grep "16" dti.dimension; then echo "1 0 0 0.05" >> dti.acqp;\
	fi
	if grep "40" dti.dimension; then echo "0 1 0 0.0904" >> dti.acqp;\
	fi
	if grep "26" dti.dimension; then echo "0 1 0 0.0863" >> dti.acqp;\
	fi
	if grep "12" dti.dimension; then echo "0 1 0 0.0888" >> dti.acqp;\
	fi
	if grep "28" dti.dimension; then echo "0 1 0 0.0931" >> dti.acqp;\
	fi

dti.index: dti.dimension
	if grep "52" dti.dimension; then echo "1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1" >> dti.index;\
	fi
	if grep "60" dti.dimension; then echo "1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1" >> dti.index;\
	fi
	if grep "16" dti.dimension; then echo "1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1" >> dti.index;\
	fi
	if grep "40" dti.dimension; then echo "1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1" >> dti.index;\
	fi
	if grep "12" dti.dimension; then echo "1 1 1 1 1 1 1 1 1 1 1 1" >> dti.index;\
	fi
	if grep "26" dti.dimension; then echo "1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1" >> dti.index;\
	fi
	if grep "28" dti.dimension; then echo "1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1" >> dti.index;\
	fi

############ eddy steps sometimes commented out because they are slow #####################

dti_eddy.nii.gz: dti.nii.gz dti_brain_mask.nii.gz dti.acqp \
	dti.index dti.bvecs dti.bvals
	eddy --imain=dti.nii.gz --mask=dti_brain_mask.nii.gz --index=dti.index \
	--acqp=dti.acqp --bvecs=dti.bvecs --bvals=dti.bvals --out=dti_eddy

######################################

t1_inp_n4_1.nii.gz: t1_inp.nii.gz
	N4BiasFieldCorrection \
	-d 3 \
	-i $< \
	-o $@
    
t1_inp_n4_2.nii.gz: t1_inp_n4_1.nii.gz
	N4BiasFieldCorrection \
	-d 3 \
	-i $< \
	-o $@

T1toMNI1Warp.nii.gz: t1_inp_n4_2.nii.gz FSL_MNI152_FreeSurferConformed_1mm_head.nii.gz 
	antsRegistrationSyN.sh \
	-d 3 \
	-f FSL_MNI152_FreeSurferConformed_1mm_head.nii.gz \
	-m t1_inp_n4_2.nii.gz \
	-o T1toMNI \
	-n 1
   
T1toMNI1Warped.nii.gz: T1toMNI1Warp.nii.gz t1_inp_n4_2.nii.gz
	antsApplyTransforms \
	-d 3 \
	-i t1_inp_n4_2.nii.gz \
	-r FSL_MNI152_FreeSurferConformed_1mm_head.nii.gz \
	-o T1toMNI1Warped.nii.gz \
	-t T1toMNI1Warp.nii.gz \
	-t T1toMNI0GenericAffine.mat

t1_n4_1.nii.gz: t1.nii.gz
	N4BiasFieldCorrection \
	-d 3 \
	-i $< \
	-o $@

t1_n4_2.nii.gz: t1_n4_1.nii.gz
	N4BiasFieldCorrection \
	-d 3 \
	-i $< \
	-o $@

dti_FA.nii.gz: dti_eddy.nii.gz dti_brain_mask.nii.gz dti.bvecs dti.bvals
	dtifit -k dti_eddy.nii.gz -o dti -m dti_brain_mask.nii.gz -r dti.bvecs -b dti.bvals

dti_b0.nii.gz: dti_eddy.nii.gz
	fslroi dti_eddy.nii.gz dti_b0.nii.gz 0 1

dtibrain_to_t1brain1Warp.nii.gz: t1_brain_masked.nii.gz dti_brain.nii.gz
	antsRegistration \
--dimensionality 3 \
--float 0 \
--output [dtibrain_to_t1brain,dtibrain_to_t1brainWarped.nii.gz] \
--interpolation Linear \
--winsorize-image-intensities [0.005,0.995] \
--use-histogram-matching 0 \
--initial-moving-transform [t1_brain_masked.nii.gz,dti_brain.nii.gz,1] \
--transform Rigid[0.1] \
--metric MI[t1_brain_masked.nii.gz,dti_brain.nii.gz,1,32,Regular,0.25] \
--convergence [1000x500x250x100,1e-6,10] \
--shrink-factors 8x4x2x1 \
--smoothing-sigmas 3x2x1x0vox \
--transform Affine[0.1] \
--metric MI[t1_brain_masked.nii.gz,dti_brain.nii.gz,1,32,Regular,0.25] \
--convergence [1000x500x250x100,1e-6,10] \
--shrink-factors 8x4x2x1 \
--smoothing-sigmas 3x2x1x0vox \
--transform SyN[0.1,3,0] \
--metric MI[t1_brain_masked.nii.gz,dti_brain.nii.gz,1,4] \
--convergence [100x70x50x5,1e-6,10] --shrink-factors 8x4x2x1 \
--smoothing-sigmas 3x2x1x0vox 

dti_FA_to_t1.nii.gz: dtibrain_to_t1brain1Warp.nii.gz dti_FA.nii.gz t1_brain_masked.nii.gz
	antsApplyTransforms \
	-d 3 \
	-i dti_FA.nii.gz \
	-r t1_brain_masked.nii.gz \
	-o dti_FA_to_t1.nii.gz \
	-t dtibrain_to_t1brain1Warp.nii.gz \
	-t dtibrain_to_t1brain0GenericAffine.mat \
	-v 0 \
	-n Linear

dti_FA_to_MNI.nii.gz: T1toMNI1Warp.nii.gz dtibrain_to_t1brain1Warp.nii.gz \
	dti_FA_to_t1.nii.gz T1toMNI0GenericAffine.mat dtibrain_to_t1brain0GenericAffine.mat 
	antsApplyTransforms \
	-d 3 \
	-i dti_FA_to_t1.nii.gz \
	-r FSL_MNI152_FreeSurferConformed_1mm_head.nii.gz \
	-o dti_FA_to_MNI.nii.gz \
	-t T1toMNI1Warp.nii.gz \
	-t T1toMNI0GenericAffine.mat \
	-t dtibrain_to_t1brain1Warp.nii.gz \
	-t dtibrain_to_t1brain0GenericAffine.mat 



