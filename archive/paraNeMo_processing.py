import csv
import sys
import os

home = os.environ["DTIPATH"]
project_dir = os.environ["path"] 
num_instances = input("Use how many cores? ")
list_dir = project_dir+"/subject_lists"

hc_list = list_dir+"/hc_ids.csv"
ms_list = list_dir+"/ms_ids.csv"


subj_dir = project_dir+"/subjects"

with open(ms_list) as csvfile:
    subject_list = csv.reader(csvfile, delimiter=',', quotechar='"')
            
    for subject in subject_list : 
        subid = subject[0]
        
        os.system("cd "+subj_dir+"/"+subid+" && mkdir -p default_output")

print("")
print("Preparing nifti files for NeMo...")
print("")

with open(ms_list) as csvfile:
    subject_list = csv.reader(csvfile, delimiter=',', quotechar='"')
    
    for subject in subject_list : 
        subid = subject[0]

	if not os.path.exists(project_dir+"/subjects/"+subid+"/fa_dev_nemo_input.nii"):
            os.system("cd "+subj_dir+"/"+subid+" &&  gunzip -k -f masked_final_deviation.nii.gz && mv masked_final_deviation.nii fa_dev_nemo_input.nii")

print("Done!")
print("")
print("Running chacocalc scripts...")

os.system("bash "+home+"/paraRun.sh "+str(num_instances))

print("done")
