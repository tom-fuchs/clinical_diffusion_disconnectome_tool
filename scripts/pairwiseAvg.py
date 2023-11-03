#!/bin/env python

import csv
import scipy.io as sio
import numpy as np
import os

m = input("Network name? (in quotes!) ")

proj = os.environ["path"]
list_dir = proj+"/subject_lists"

ms_file_name = raw_input("Enter name of ms list (with extension): ") 
ms_list = list_dir+"/" + ms_file_name

with open(ms_list) as csvfile:
        subject_list = csv.reader(csvfile, delimiter=',', quotechar='"')
        filename= m+'_pairwise_averages.csv'
        count=0
		
        os.system("cd "+proj+"/data && rm -f "+filename)
        
        for subject in subject_list: 
            subid = subject[0]
            idnum = subid[2:]
            if int(idnum) < 50000:
            
                subjects_dir_dti = proj+'/subjects/'

                mat_contents = sio.loadmat(subjects_dir_dti+subid+'/default_output/ChaCo86_MNI.mat')


                nConMat = mat_contents['ChaCoResults'][0][0]['nConMat']
                nmaptfc = mat_contents['ChaCoResults'][0][0]['OrigMat'][0][0]['nMapTFC']

                ConMat = mat_contents['ChaCoResults'][0][0]['ConMat']
                where3 = np.where([x < 3 for x in ConMat])
                nConMat[where3] = 0
      
                prop_mat=(nmaptfc-nConMat)/nmaptfc

                wherenan = np.isnan(prop_mat)  
                prop_mat[wherenan] = 0

                with open(proj+'/data/'+m+'_pairs.csv') as csvfile:
                    pairs = csv.reader(csvfile, delimiter=',', quotechar='"')
                    total=0
                    sum=0
                    for pair in pairs:
                        x=int(pair[0])-1
                        y=int(pair[1])-1
                        sum=sum+prop_mat[x][y]
                        total=total+1
                    avg=sum/total

	            os.system("cd "+proj+"/data && echo "+idnum+","+str(avg) +" >> "+filename)

              





