
import csv
import sys
import os
import pandas as pd

project_dir = os.environ["path"]


print("")
list_dir = project_dir+"/subject_lists"

hc_file_name = raw_input("Enter name of hc list (with extension): ") 
ms_file_name = raw_input("Enter name of ms list (with extension): ") 
hc_list = list_dir+"/" + hc_file_name
ms_list = list_dir+"/" + ms_file_name

subj_dir = project_dir+"/subjects"

#so the idea is, the running sum is stored externally, in the calculations directory as sumbrain.nii.gz
#it is updated with every iteration, adding all the FA together
#the first subject is calculated separately outside the loop, to initialize the running sum

if not os.path.exists(project_dir+"/calculations"):

	os.system("cd "+project_dir+" && mkdir -p calculations")
	calc_dir = project_dir+"/calculations"

	print("Calculating average healthy control FA...")

	with open(hc_list) as csvfile:
	    subject_list = csv.reader(csvfile, delimiter=',', quotechar='"')
	    first = next(subject_list)
	    first=first[0]

	    #in case we are remaking these files
	    os.system("cd "+calc_dir+" && rm -f sumbrain.nii.gz && rm -f average_hc_dti_brain.nii.gz")

	    #first subject
	    os.system("cd "+subj_dir+"/"+first+" && cp dti_FA_to_MNI.nii.gz "+calc_dir+"/sumbrain.nii.gz")

	    for subject in subject_list:
			subid = subject[0]
			os.system("cd "+subj_dir+"/"+subid+" && fslmaths dti_FA_to_MNI.nii.gz -add "+calc_dir+"/sumbrain.nii.gz out.nii.gz && mv out.nii.gz "+calc_dir+"/sumbrain.nii.gz")

			with open(hc_list) as csvfile:
				subject_list = csv.reader(csvfile, delimiter=',', quotechar='"')
				numsubjects = sum(1 for row in subject_list)
				os.system("cd "+calc_dir+" && fslmaths sumbrain.nii.gz -div "+ str(numsubjects)+ " average_hc_dti_brain.nii.gz")


	print("Calculating standard deviation of healthy control FA...")

	#similar to the average, the running sum of the difference between each FA and the average is
	#stored externally in stdvbrain.nii.gz
	#there are several intermediate steps, since there is subtraction and squaring that occurs, but
	#those intermediate files are stored in a tmp folder and deleted
	#the first subject is calculated separately outside the loop, to initialize the running sum

	with open(hc_list) as csvfile:
	    subject_list = csv.reader(csvfile, delimiter=',', quotechar='"')

	    first = next(subject_list)
	    first=first[0]

	    #in case we are remaking these files
	    os.system("cd "+calc_dir+" && rm -f stdvbrain.nii.gz && rm -f stdv_hc_dti_brain.nii.gz")

	    #first subject
	    os.system("cd "+subj_dir+"/"+first+" && fslmaths dti_FA_to_MNI.nii.gz -sub "+calc_dir+"/average_hc_dti_brain.nii.gz one.nii.gz && fslmaths one.nii.gz -sqr out.nii.gz && mv out.nii.gz "+calc_dir+"/stdvbrain.nii.gz && rm one.nii.gz")

	    for subject in subject_list:
			subid = subject[0]
			os.system("cd "+subj_dir+"/"+subid+" && mkdir -p tmp && fslmaths dti_FA_to_MNI.nii.gz -sub "+calc_dir+"/average_hc_dti_brain.nii.gz tmp/one.nii.gz && fslmaths tmp/one.nii.gz -sqr tmp/two.nii.gz && fslmaths tmp/two.nii.gz -add "+calc_dir+"/stdvbrain.nii.gz out.nii.gz && mv out.nii.gz "+calc_dir+"/stdvbrain.nii.gz && rm -r tmp")
			os.system("cd "+calc_dir+" && fslmaths stdvbrain.nii.gz -div "+str(numsubjects)+" one.nii.gz && fslmaths one.nii.gz -sqrt stdv_hc_dti_brain.nii.gz && rm one.nii.gz")

else:
    calc_dir = project_dir+"/calculations"


print("Generating white matter masks...")


#Generate white matter masks
with open(ms_list) as csvfile:
    subject_list = csv.reader(csvfile, delimiter=',', quotechar='"')
    for subject in subject_list:
        subid = subject[0].strip()
        print("white matter calc for",subid)
        if not os.path.exists(project_dir+"/subjects/"+subid+"/wm_mask.nii.gz"):
		    if os.path.exists(subj_dir+'/'+subid+'/T1toMNIWarped.nii.gz'):
		        os.system("cd "+subj_dir+"/"+subid+" && bet T1toMNIWarped.nii.gz T1toMNIWarped_brain -m -f 0.2 && fast -g -t 1 --nopve -o dti -n 2 T1toMNIWarped_brain.nii.gz")
		    else:
		        print subid+" oh no"

		    #rename WM mask file for clarity
		    os.system("cd "+subj_dir+"/"+subid+" && mv dti_seg_1.nii.gz wm_mask.nii.gz")



#this uses fslmaths to calculate a zscore for every MS scan from the HC average
print("Calculating z scores for all MS scans...")
with open(ms_list) as csvfile:
    subject_list = csv.reader(csvfile, delimiter=',', quotechar='"')

    for subject in subject_list:
        subid = subject[0]

        os.system("cd "+subj_dir+"/"+subid+" && fslmaths dti_FA_to_MNI.nii.gz -sub "+calc_dir+"/average_hc_dti_brain.nii.gz one.nii.gz && fslmaths one.nii.gz -div "+calc_dir+"/stdv_hc_dti_brain.nii.gz zscore_brain.nii.gz && rm one.nii.gz")



#apply wm mask
print("Applying white matter masks to z scores...")
with open(ms_list) as csvfile:
    subject_list = csv.reader(csvfile, delimiter=',', quotechar='"')
    for subject in subject_list:
        subid = subject[0]

        os.system("cd "+subj_dir+"/"+subid+" && fslmaths zscore_brain.nii.gz -mas wm_mask.nii.gz zscore_masked.nii.gz")

print("Truncating z scores and applying logistic regression...")
#Truncate positive values, only care about regions where FA got worse
with open(ms_list) as csvfile:
    subject_list = csv.reader(csvfile, delimiter=',', quotechar='"')
    for subject in subject_list:
        subid = subject[0]
        os.system("cd "+subj_dir+"/"+subid+" && fslmaths zscore_masked.nii.gz -uthr 0 zscore_trunc.nii.gz")

#Negate truncated z scores, negative is now positive
with open(ms_list) as csvfile:
    subject_list = csv.reader(csvfile, delimiter=',', quotechar='"')
    for subject in subject_list:
        subid = subject[0]
        os.system("cd "+subj_dir+"/"+subid+" && fslmaths zscore_trunc.nii.gz -mul -1 neg_zscore_brain.nii.gz")

#Resize brains to fit NeMo and register to "NeMo MNI space" from "True MNI Space"
#note: remove this step if we successfully register to NeMo MNI earlier in processing (Make file)
# with open(ms_list) as csvfile:
#     subject_list = csv.reader(csvfile, delimiter=',', quotechar='"')

#     for subject in subject_list :
#         subid = subject[0]
#         os.system("cd "+subj_dir+"/"+subid+" && flirt -in neg_zscore_brain.nii.gz -ref /shared/studies/nonregulated/connectome/NeMo/resources/r1mm_grey.nii -applyxfm -init /usr/share/fsl/5.0/etc/flirtsch/ident.mat -out neg_zscore_brain_resized.nii.gz")

#Threshold image to eliminate voxelstemp_subj_list.csv
with open(ms_list) as csvfile:
    subject_list = csv.reader(csvfile, delimiter=',', quotechar='"')

    for subject in subject_list:
        subid = subject[0]

        #threshold
        os.system("cd "+subj_dir+"/"+subid+" && fslmaths neg_zscore_brain.nii.gz -thr 1.5 zscore_threshold.nii.gz")


#apply log transform


with open(ms_list) as csvfile:
    subject_list = csv.reader(csvfile, delimiter=',', quotechar='"')
    for subject in subject_list:
        subid = subject[0]
        k = 1
        x0 = 3
        negk = k * -1

        os.system("cd "+subj_dir+"/"+subid+" && fslmaths zscore_threshold.nii.gz -sub "+str(x0)+" one.nii.gz && fslmaths one.nii.gz -mul "+str(negk)+" two.nii.gz && fslmaths two.nii.gz -exp three.nii.gz && fslmaths three.nii.gz -add 1 four.nii.gz && fslmaths four.nii.gz -recip log_zscore_brain.nii.gz && rm one.nii.gz two.nii.gz three.nii.gz four.nii.gz")


#after log transform, all 0's are transformed to the new, non-zero (but close), min value
#threshold log output, to zero out these non-zero min values, which were zero's previous
#to the log transform.

with open(ms_list) as csvfile:
    subject_list = csv.reader(csvfile, delimiter=',', quotechar='"')
    for subject in subject_list:
        subid = subject[0]
        #add small value to the minimum so that the inclusive fslmaths
        #threshold removes the minumum
        out = os.popen("cd "+subj_dir+"/"+subid+" && fslstats -t log_zscore_brain.nii.gz -R -M -V | cut -d\" \" -f1")
        minn = float(out.read().strip())+0.000001
        os.system("cd "+subj_dir+"/"+subid+" && fslmaths log_zscore_brain.nii.gz -thr "+str(minn)+" log_zscore_threshold.nii.gz")


#Negate all transformed scores for NeMo
with open(ms_list) as csvfile:
    subject_list = csv.reader(csvfile, delimiter=',', quotechar='"')
    total=0
    for subject in subject_list:
        subid = subject[0]

        os.system("cd "+subj_dir+"/"+subid+" && fslmaths log_zscore_threshold.nii.gz -mul -1 neg_log_zscore_threshold.nii.gz")

print("Creating FA masks to mask final output...")
#Binarize FA brains to create masks
with open(ms_list) as csvfile:
    subject_list = csv.reader(csvfile, delimiter=',', quotechar='"')

    for subject in subject_list:
        subid = subject[0]

        #binarize original FA to create mask
        os.system("cd "+subj_dir+"/"+subid+" && fslmaths dti_FA_to_MNI.nii.gz -bin bin_FA.nii.gz")


#Resize FA masks
#remove this step if DTI data is successfully registered to NeMo MNI space in earlier processing (Make file)
# with open(ms_list) as csvfile:
#     subject_list = csv.reader(csvfile, delimiter=',', quotechar='"')

#     for subject in subject_list :
#         subid = subject[0]

#         os.system("cd "+subj_dir+"/"+subid+" && flirt -in bin_FA.nii.gz -ref /shared/studies/nonregulated/connectome/NeMo/resources/r1mm_grey.nii -applyxfm -init /usr/share/fsl/5.0/etc/flirtsch/ident.mat -out bin_FA_resized.nii.gz")

#         os.system("cd "+subj_dir+"/"+subid+" && flirt -in T1toMNIWarped.nii.gz -ref /shared/studies/nonregulated/connectome/NeMo/resources/r1mm_grey.nii -applyxfm -init /usr/share/fsl/5.0/etc/flirtsch/ident.mat -out T1toMNIWarped_qc.nii.gz")


print("Applying mask to final output...")
#create eroded mask and apply to get final output
with open(ms_list) as csvfile:
    subject_list = csv.reader(csvfile, delimiter=',', quotechar='"')
    for subject in subject_list:
        subid = subject[0]

        os.system("cd "+subj_dir+"/"+subid+" && fslmaths bin_FA.nii.gz -ero -ero bin_FA_ero.nii.gz && fslmaths neg_log_zscore_threshold.nii.gz -mas bin_FA_ero.nii.gz masked_final_deviation_fsmni.nii.gz")
        
with open(ms_list) as csvfile:
    subject_list = csv.reader(csvfile, delimiter=',', quotechar='"')

    for subject in subject_list :
        subid = subject[0]
        os.system("cd "+subj_dir+"/"+subid+" && antsApplyTransforms -d 3 -i masked_final_deviation_fsmni.nii.gz -o masked_final_deviation.nii.gz -r /shared/studies/nonregulated/connectome/NeMo/resources/r1mm_grey.nii")

print("Done!")
print("")
print("------------")
print("To view final images for quality control, run")
print("> bash Quality_check.sh")
print("------------")
print("")
