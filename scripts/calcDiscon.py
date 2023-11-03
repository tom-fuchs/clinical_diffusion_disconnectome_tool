import csv
import sys
import os
import pandas
import numpy
import scipy.io as sio

home = os.environ["DTIPATH"]
project_dir = os.environ["path"] 
list_dir = project_dir+"/subject_lists"

all_ids_file_name = raw_input("Enter name of a list of all ids (with extension): ") 
all_list = list_dir+"/" + all_ids_file_name
subj_dir = project_dir+"/subjects"


def getConnectedIndecies():
    mat_contents = sio.loadmat('/shared/studies/nonregulated/connectome/NeMo/subjects/EX25611/flair_lm_MNI/default_output/ChaCo86_MNI.mat')
    nOrigMatlist = []
    # for each control subject, obtain original connectivity matrix
    for i in range(1,74):  
        nOrigMatArray = mat_contents['ChaCoResults'][0][i]['OrigMat'][0][0]['nMapTFC'] 
        nOrigMatbool = numpy.array([x != x for x in nOrigMatArray]) # purposely broken!
        nOrigMatlist.append(nOrigMatbool) 

    # stack 73 True/False arrays into 3D array
    nOrigMatlist_array = numpy.array(nOrigMatlist) 

    # obtain array of True items (0.0 connection) by or-ing along 0 axis 
    connection_missing = numpy.any(nOrigMatlist_array, axis = 0) 
    connection_indices_duplicates = numpy.ndarray.tolist(numpy.argwhere(connection_missing == False ))
    # list indices for pairwise connections to be included, will contain duplicate pairs (e.g.[0, 1] and [1, 0]) 
    connection_indices = connection_indices_duplicates[:] # copy to remove duplicates
    for pair in connection_indices_duplicates:
        if pair and pair[::-1] in connection_indices:   
            connection_indices.remove(pair)
    return connection_indices

def getConnectedPairs():
    path = '/shared/studies/nonregulated/connectome/NeMo/notebooks'

    index_to_atlas = {}
    header = []
    connection_indices = getConnectedIndecies()
    atlas86 = []
    with open('/shared/studies/nonregulated/connectome/NeMo/notebooks/atlas86.cod') as csvfile:
        atlas = csv.reader(csvfile, delimiter=',', quotechar='"')
        for line in atlas:
            atlas86 =atlas86+line
            
    for p in connection_indices: 
            temp = (atlas86[p[0]], atlas86[p[1]])
            index_to_atlas[p[0], p[1]] = temp
            header.append(temp)   
    return header

def getCsvStyleLabels():
    connected_pairs = getConnectedPairs()
    restyled_pairs = []
    for pair in connected_pairs:
        label = pair[0][pair[0].index('=')+1:] +"_"+ pair[1][pair[1].index('=')+1:]
        restyled_pairs.append(label)
    return restyled_pairs  

def disconnectivity_calculation(mat):
    nMapTFC = mat['ChaCoResults'][0][0]['OrigMat'][0][0]['nMapTFC']                           
    nConMat = mat['ChaCoResults'][0][0]['nConMat']
    
    nMapTFC = numpy.array(nMapTFC)
    nConMat = numpy.array(nConMat)
    
    #If either of these changes are made change output file names to reflect
    nDisconMatAbs = numpy.subtract(nMapTFC, nConMat) 
    nDisconMatPct = numpy.divide(nDisconMatAbs, nMapTFC) 
    return [nDisconMatAbs, nDisconMatPct]
    
    
def createSubjectCsv(subId, mat, conn_indecies, conn_pairs):
    sub_dir = project_dir+"/subjects/"+subId
    os.system("cd "+sub_dir+" && mkdir -p disconnection")
    header = ['region_pair','abs_disruption','pct_disruption']
    disruption_arr = [[],[]]
    calculation_disruption = disconnectivity_calculation(mat)
        
    with open(sub_dir+'/disconnection/nemo_pairwise_disruption_abs_pct.csv',mode= 'w') as csvfile:
        disconFile = csv.writer(csvfile, delimiter=',', quotechar='"')
        disconFile.writerow(header)
        
        for i in range(0, len(conn_pairs)):
            pair = conn_indecies[i]
            abs_disrupt = calculation_disruption[0][pair[0]][pair[1]]
            pct_disrupt = calculation_disruption[1][pair[0]][pair[1]]
            
            if numpy.isnan(pct_disrupt):
                pct_disrupt = 0
            if numpy.isnan(abs_disrupt):
                abs_disrupt = 0
                
            disconFile.writerow([conn_pairs[i], abs_disrupt,pct_disrupt])
            disruption_arr[0].append(abs_disrupt)
            disruption_arr[1].append(pct_disrupt)
    return disruption_arr


#begining of processing for subject list
os.system("cd "+project_dir+" && mkdir -p disconnection_full") 
conn_indecies = getConnectedIndecies()
conn_pairs = getCsvStyleLabels()

with open(project_dir+'/disconnection_full/full_nemo_pairwise_disruption_pct.csv',mode='w') as csvFileWritePct:
    
    disruptFilePct = csv.writer(csvFileWritePct, delimiter=',', quotechar='"')   
    disruptFilePct.writerow(['subject']+getCsvStyleLabels())
    
    with open(project_dir+'/disconnection_full/full_nemo_pairwise_disruption_abs.csv',mode='w') as csvFileWriteAbs:
        disruptFileAbs = csv.writer(csvFileWriteAbs, delimiter=',', quotechar='"')   
        disruptFileAbs.writerow(['subject']+getCsvStyleLabels())
    
        with open(all_list) as csvfile:
            subject_list = csv.reader(csvfile, delimiter=',', quotechar='"')

            for subject in subject_list:
                sub_mat = sio.loadmat(subj_dir+'/'+subject[0]+'/default_output/ChaCo86_MNI.mat')
                sub_data = createSubjectCsv(subject[0], sub_mat, conn_indecies, conn_pairs)
                disruptFileAbs.writerow([subject][0]+sub_data[0])
                disruptFilePct.writerow([subject][0]+sub_data[1])





            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            