#calculate total runtime

import csv
import sys
import os

home = os.environ["DTIPATH"]
path = os.environ["path"] 

n = input("Use how many cores? ")

with open(path+'/subject_lists/ms_ids.csv') as csvfile:
    subject_list = csv.reader(csvfile, delimiter=',', quotechar='"')
    total=0

    for subject in subject_list: 
        subid = subject[0]

        #find voxel count of new image
        out = os.popen('cd '+path+'/subjects/'+subid+' && fslstats -t fa_dev_nemo_input.nii -V | cut -d" " -f1')
        
        vox = int(out.read().strip())

        #call my script that estimates # of hours in nemo based on number of nonzero voxels 
        out = os.popen('cd '+home+'/scripts && bash calc_hours.sh '+str(vox))
        hrs = out.read().strip()

        total=total+int(hrs)

    #print(total)
    #print(total / n)
    print str(total / 24.0 / 30 / n)+' months'
    print str(total / 24.0 / n)+' days'
    print str(total / n)+' hours'
    
