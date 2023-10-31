function parsave_DF(fname,discharge_ms,cPath,outPath)

%{
Save function to work with parfor

Project: SCI EMG modeling (Li et al.)

%}

%%
cd(outPath)
save(fname, 'discharge_ms','-v7.3')
cd(cPath)
end