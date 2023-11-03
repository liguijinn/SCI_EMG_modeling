function sn3DF_MUPool(config,traNum,cPath,rPath,op_DF,nMU)

%{

MUPool - 3 - Recruitment

Recruitment
Discharge and firing timing

Project: SCI EMG modeling

Author: Guijin Li
Date: Oct 31st, 2023

Adaptive Neurorehabilitations Systems Lab
KITE Research Institute, Toronto Rehabilitation Institute
Institute of Biomedical Engineering, University of Toronto

%}


%% 1 Setup

cd(rPath)
files_MUfb = dir('MU*_FBL_100.mat');
% nMU = length(files_MUfb);

%% 2 Recruitment

RR = 40; % range of recruitment
instance_tot = 500; % discharge instances

PFR1 = 45; % imp/s
PFRD = 10; % imp/s
ISI_cv = 0.2; % coefficient of variation in ISI variability
gain_E = 1;

co_a = log(RR)/nMU;
iMN = 1:1:nMU;
RTE = exp(co_a*iMN); % Eq(1); recruitment threshold excitation for ith MN

% Rate coding
FRmin = 8; % min steady firing rate, assigned 8 imp/s
PFR = PFR1 - PFRD * RTE/RTE(nMU); % Eq(5)

ExcD_max = RTE(nMU) + (PFR(nMU)-FRmin)/gain_E; % Eq(8)
ExcD = ExcD_max;

%% 3 Discharge

discharge_t = zeros(nMU,instance_tot); % start firing at the beginning

for cntMN = 1:nMU % for each MN
    if ExcD >= RTE(cntMN) % if Exc Drive is lower than RTE, skip this MN.
        % firing rate, inverse of interspike intervals (ISI)
        FR = gain_E*(ExcD - RTE(cntMN)) + FRmin; % Eq(2)
        ISI_u = 1/FR; % Eq(3)
        for cnt_t = 2:instance_tot % for each time stamp
            ISI_z = -3.9 + 3.9*2*rand(1); % a random number from -3.9 to 3.9
            discharge_t(cntMN, cnt_t) = ...
                ISI_u + ISI_u*ISI_cv*ISI_z + discharge_t(cntMN,cnt_t-1);   
        end        
    end    
end

discharge_ms = round(discharge_t * 10000)/10;
cd(cPath);
parsave_DF(['MUAP_DF_',config,'_tra',num2str(traNum)],discharge_ms,cPath,op_DF)

