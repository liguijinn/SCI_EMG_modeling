function sn2mu_fb(pCode,config)

%{

Put all SFAP within a unit into one matrix.

flexible, independent from s1 parameters

%}

rootPath = cd();
pPath = fullfile(rootPath,pCode);

cd(pPath)
cPath = cd();

[~,config2] = strtok(config,'_');

s1OF_fb = ['MUfbs',config2];
op_fb = fullfile(cPath, s1OF_fb);

% nMUStr = strtok(config,'_');
% SMU = load(['startMU_',nMUStr,'MUs.mat']);

FBL = 0.1:0.1:1;

muap_folder = ['MUAP_FBL',config2];
if ~isfolder(muap_folder)
    mkdir(muap_folder)   
end
op_MUAP_FB = fullfile(cPath, muap_folder);

cd(op_fb); filenames = dir('MU*_fb*.mat');
loadSFAP0 = load(filenames(1).name); %SFAP
biSFAP0 = loadSFAP0.SFAP;
tlen = size(biSFAP0,2);
allMUfb = {filenames.name};
allMUfbsplit = cellfun(@(x) split(x,'_'), allMUfb, 'UniformOutput',false);
allMU = cellfun(@(x) x{1,:},allMUfbsplit,'UniformOutput',false);
MUlist = unique(allMU);
numMU = length(MUlist);

for cntFBL = 1:length(FBL)
    
tpFBL = FBL(cntFBL);

parfor i = 1:numMU
% for i = 1:numMU    
    mun = MUlist{i};  
    cd(op_fb); allfbFile = dir([mun,'_fb*.mat']);
    fn_muap = [mun,'_FBL_',num2str(tpFBL*100)];
    
    allfb = {allfbFile.name};
    
    numfb0 = length(allfb);
    
    kp_nFB_idx = sort(randperm(numfb0,round(numfb0*tpFBL))); % remaining fbs
    numfb = length(kp_nFB_idx);
    
    cd(op_MUAP_FB);
    if exist(fn_muap,'file')
        disp(['already done: ',fn_muap])
        continue;
    end
    cd(op_fb);
    
    MU_fb = zeros(numfb,tlen); k = 1;
    for j = 1:numfb0 
        if ismember(j,kp_nFB_idx)
            loadSFAP = load([mun,'_fb',num2str(j),'.mat']);
            biSFAP = loadSFAP.SFAP;  
            MU_fb(k,:) = diff(biSFAP); k = k+1;
        end
    end
    
    %parsave_MUfb(fname,MU_fb,cPath,outPath)    
    cd(rootPath)
    parsave_MUfb(fn_muap,MU_fb,cPath,op_MUAP_FB)
    disp(['saved: ',fn_muap])
%     parsave_MUAP(['MUAP_',num2str(i)],MU_fb,cPath,outPath)
end
% cd(cPath)
cd(rootPath)
end