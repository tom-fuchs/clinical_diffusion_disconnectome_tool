gg = pwd;
addpath /shared/nonrestricted/connectome/dti_fa/DTI_processing_application/spm12/
addpath /shared/nonrestricted/connectome/dti_fa/DTI_processing_application/spm12/toolbox/LST
cd(gg);
try
    ps_LST_lpa('./flair.nii','','');
catch ME
    quit;
end
