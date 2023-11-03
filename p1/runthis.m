
%{
Start here to...
set up MUT for this participant, 
calculate the global transfer function, and
simulate SFAP for all fibers in all MUs

* If computational resources is limited, parse nMU (e.g. 100) into segments
and run segments in parallel. 

* If running on a cluster, specify this file to be executed.

Project: SCI EMG modeling

Author: Guijin Li
Date: Oct 31st, 2023

Adaptive Neurorehabilitations Systems Lab
KITE Research Institute, Toronto Rehabilitation Institute
Institute of Biomedical Engineering, University of Toronto

%}

%%
clear;clc
cPath = cd();
diary explog.txt
disp(datetime)

%%
nMU = 100; 
nMU_sta = 1; 
nMU_end = nMU;
% optional, use nMU sta/end to parse total MUs based on your machine

fiberLen = 120; % mm
density = 20; % 20 unit fibers/mm^2
pool_RxyB = 8; % mm
dw = 0.6; d1 = 0.9;
pool_RxyA = sqrt(pool_RxyB^2+(dw+d1/2)^2);

MU_Rmin = 0.5; % radius, mm
MU_Rmax = 4;
MUc_xyz = [0,10,0]; 
MUT = [pool_RxyA,pool_RxyB, dw,d1];

cv_mu = 4;
cv_sd = 0.7;
cv = cv_sd.*randn(nMU,1)+cv_mu;

%
d = 1;  % skin, 1 mm
h1_range = 3; % fat layer, 3 mm, expandable to multiple thickness levels
simT = 30; % ms simulation time

%
LOI_z1 = -5;
LOI_z2 = LOI_z1+10;
LOI_z = [LOI_z1,LOI_z2];
LOI_x = 0;

%% MU setup
s1OF_MU = ['MUxyz_',num2str(nMU),'MUs'];
if ~isfolder(s1OF_MU)
    mkdir(s1OF_MU)   
end
op_MU = fullfile(cPath, s1OF_MU);
SMU = ['startMU_',num2str(nMU),'MUs'];

sn1setup(SMU,nMU,MUT,density,MU_Rmin,MU_Rmax,MUc_xyz,cPath,op_MU)
check_MUxyz(nMU,MUc_xyz,pool_RxyB,SMU,cPath,op_MU)
disp('MUT setup done')

%%
for i = 1:length(h1_range) % loop thru multiple h1
    h1 = h1_range(i);
    config = [num2str(h1*10),'h1_',num2str(cv_mu*10),'cv'];   
    s1OF_fb = ['MUfbs_',config];
    if ~isfolder(s1OF_fb)
        mkdir(s1OF_fb)   
    end
    op_fb = fullfile(cPath, s1OF_fb);
    
    SHY = ['startHY_',config];
    sn1Hglo(SHY,fiberLen,d,h1,pool_RxyB,MUc_xyz(2))
    sn2APs(SMU,SHY,nMU_sta,nMU_end,fiberLen,cv,LOI_z,LOI_x,simT,cPath,op_MU,op_fb)
    
%     parfor j=1:length(nMU_sta)
%         sn2APs(SMU,SHY,nMU_sta(j),nMU_end(j),fiberLen,cv,LOI_z,LOI_x,simT,cPath,op_MU,op_fb)
%     end
% un-comment parfor section to replace line #63 to compensate for limited
% computational resources
    disp([config,' s2 ap done'])
end
