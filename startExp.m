% function startExp(pNum)

%{
    
Set up experiments and loop through each participant (pNum)

Specify varying parameters
    ExcDLev:    0.1:0.1:1, CD_lev, common drive, volitional control
    MNLev:      0.1:0.1:1, LMN_lev, remaining LMN function level
    alphaExcD:  0.1:0.1:1, UMN_lev, remaining UMN function level
    FBL:        0.1:0.1:1, MF_lev, % of remaining muscle fibers within each MU

Project: SCI EMG modeling

Author: Guijin Li
Date: Oct 31st, 2023

Adaptive Neurorehabilitations Systems Lab
KITE Research Institute, Toronto Rehabilitation Institute
Institute of Biomedical Engineering, University of Toronto

%}

%% Setup

pNum = 1; % comment out if use as a function
pCode = ['p',num2str(pNum)];
rootPath = cd();
pPath = fullfile(rootPath,pCode);

% repeat the info below to set up "config" to label files/folders
nMU = 2;
d = 1;  % skin, 1 mm
h1 = 3; % fat layer, 3 mm
cv_mu = 4; % mm/ms
simT = 30; % ms, simulation time for each SFAP (generated already)
obsT = 3050; % ms, obervation time

config = [num2str(nMU),'_',num2str(h1*10),'h1_',num2str(cv_mu*10),'cv'];

% set up MUAP_FBL folder, only need to do once for each participant
sn2mu_fb(pCode,config)

%% 
cd(pPath)

cPath = cd();
rfolder = dir('MUAP_FBL_*');
rPath = fullfile(cPath, rfolder.name);

totTrials = 3; % specify number of trials

%% DF
outFolder_DF = ['PoolDF_',config,'_',num2str(obsT),'_Tra',num2str(totTrials)];
if ~isfolder(outFolder_DF)
    mkdir(outFolder_DF)   
end
op_DF = fullfile(cPath, outFolder_DF);

cd(op_DF); checkDF = dir(['MUAP_DF_',config,'_tra*']);

cd(rootPath)
if length(checkDF) ~= totTrials
for traNum = 1:totTrials
    sn3DF_MUPool(config,traNum,rootPath,rPath,op_DF,nMU)
end
end

%% Poten
cd(cPath)
outFolder_Poten = ['Poten_',config,'_',num2str(obsT),...
    '_Tra',num2str(totTrials)];
if ~isfolder(outFolder_Poten)
    mkdir(outFolder_Poten)   
end
op_Poten = fullfile(cPath, outFolder_Poten);

%% LMNrem
% generated once to be used in multiple experiments

cd(op_Poten);
if isfile('LMNrem.mat')
    load('LMNrem.mat')
else 
    MNLevPrep = 0.1:0.1:1;
    LMNrem = struct();
    for cntMNL = 1:length(MNLevPrep)
        lev = MNLevPrep(cntMNL)*100;
        MNperc = MNLevPrep(cntMNL);
        nMU_idx = sort(randperm(nMU,round(nMU*MNperc))); % remaining MUs
        LMNrem.(['MNLev',num2str(lev)]) = nMU_idx;
    end
    save('LMNrem','LMNrem')
end

%% Experiment example: MF_lev
% one example: varying MF_lev from 10% to 100% with 50% volitional effort,
% severe UMN damage and mild LMN damage

FBL = 0.1:0.3:1; % varying MF_lev
var = 'FBLev'; % for file/folder label

ExcDLev = 0.5; 
alphaExcD = 0.2; % severe UMN damage
MNLev = 0.8; % mild LMN damage
LMNidx = 81:100; % remove LMN# 81 - 100 
% this is only read when LMNrem is empty [] in the sn4PT_MUPool below

cd(rootPath)
parfor traNum = 1:totTrials
    
    sn4PT_MUPool(var,config,ExcDLev,MNLev,LMNidx,LMNrem,alphaExcD,FBL,...
        simT,obsT,traNum,rPath,op_DF,op_Poten)
end

disp([var,' done'])
