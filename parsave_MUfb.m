function parsave_MUfb(fname,MU_fb,cPath,outPath)

%{
Save function to work with parfor

Project: SCI EMG modeling (Li et al.)

%}

%%
cd(outPath)
save(fname, 'MU_fb','-v7.3')
cd(cPath)
end