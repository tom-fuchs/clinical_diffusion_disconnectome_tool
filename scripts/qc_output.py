from nilearn import plotting 
from nilearn import image
import nibabel
import sys
import numpy as np
import os
import warnings
import matplotlib.pyplot as plt

img = sys.argv[1]
name = sys.argv[2]
path = sys.argv[3]
id = sys.argv[4]
proj_path = sys.argv[5]
opt = sys.argv[6]
typ= sys.argv[7]
sub_dir = sys.argv[8]

if os.path.exists(img) and not os.path.exists(path+'/'+name+'.png'):
    if(typ == 'c' and os.path.exists(sub_dir+'/T1toMNIWarped.nii.gz')):
        t1img = sub_dir+'/T1toMNIWarped.nii.gz'
        display = plotting.plot_img(t1img, annotate=False, draw_cross=False, title=id+" "+opt, cmap=plt.get_cmap('bone'))
        display.add_overlay(img,threshold =0.0001, cmap=plt.get_cmap('hot_white_bone'))
        display.savefig(path+'/'+name+'.png')
    else:
        display = plotting.plot_img(img, annotate=False, draw_cross=False, title=id+" "+opt, cmap=plotting.cm.hot_white_bone)
        display.savefig(path+'/'+name+'.png')


# python -W ignore $DTIPATH/scripts/qc_output.py $path/subjects/$i/masked_final_deviation.nii.gz $i\_fa_dev $qc_path $i $path "Deviation map" 'c' $path/subjects/$i
   