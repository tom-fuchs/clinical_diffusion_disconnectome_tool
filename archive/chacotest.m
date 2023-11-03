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

