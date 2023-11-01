function parsave_MUloc(fname,MUxyz,cPath,outPath)
%{
Save function to work with parfor

Project: SCI EMG modeling (Li et al.)

%}
%%
cd(outPath)
save(fname, 'MUxyz')
cd(cPath)
end