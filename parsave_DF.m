function parsave_DF(fname,discharge_ms,cPath,outPath)

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
save(fname, 'discharge_ms','-v7.3')
cd(cPath)
end