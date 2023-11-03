function parsave_MUloc(fname,MUxyz,cPath,outPath)
%{
Save function to work with parfor

Project: SCI EMG modeling

Author: Guijin Li
Date: Oct 31st, 2023

Adaptive Neurorehabilitations Systems Lab
KITE Research Institute, Toronto Rehabilitation Institute
Institute of Biomedical Engineering, University of Toronto

%}
%%
cd(outPath)
save(fname, 'MUxyz')
cd(cPath)
end