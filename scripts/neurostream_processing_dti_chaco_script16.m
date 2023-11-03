addpath(genpath('/shared/studies/nonregulated/connectome/NeMo/resources'));
disp('added path 1st time')
addpath(genpath('/shared/studies/nonregulated/connectome/NeMo/resources'));
disp('added path 2nd time')
addpath(genpath('/shared/studies/nonregulated/connectome/NeMo/resources'));
disp('added path 3rd time')
disp('attempt chacocalc')
try
ChaCoCalc
catch
try
ChaCoCalc
catch
try
ChaCoCalc
catch
disp('end attempt chacocalcs')
end
end
end
ChaCoCalc('/shared/nonrestricted/connectome/dti_fa/neurostream/neurostream_processing/subjects/EX55215/fa_dev_nemo_input.nii',[],'MNI',86,'/shared/nonrestricted/connectome/dti_fa/neurostream/neurostream_processing/subjects/EX55215/default_output',12)
ChaCoCalc('/shared/nonrestricted/connectome/dti_fa/neurostream/neurostream_processing/subjects/EX49786/fa_dev_nemo_input.nii',[],'MNI',86,'/shared/nonrestricted/connectome/dti_fa/neurostream/neurostream_processing/subjects/EX49786/default_output',12)
ChaCoCalc('/shared/nonrestricted/connectome/dti_fa/neurostream/neurostream_processing/subjects/EX72965/fa_dev_nemo_input.nii',[],'MNI',86,'/shared/nonrestricted/connectome/dti_fa/neurostream/neurostream_processing/subjects/EX72965/default_output',12)
