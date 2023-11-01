function parsave_fb(fname,SFAP,cPath,outPath)

%{
Save function to work with parfor

Project: SCI EMG modeling (Li et al.)

%}

%%
cd(outPath)
save(fname, 'SFAP','-v7.3')
cd(cPath)
end