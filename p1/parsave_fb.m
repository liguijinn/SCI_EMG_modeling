function parsave_fb(fname,SFAP,cPath,outPath)

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
save(fname, 'SFAP','-v7.3')
cd(cPath)
end