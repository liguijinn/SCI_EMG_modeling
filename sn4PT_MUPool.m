function sn4PT_MUPool(var,config,ExcDLev,MNLev,LMNidx,LMNrem,...
    alphaExcD,FBL,simT,obsT,traNum,rPath,op_DF,op_Poten)

%{
    
MUPool - 4 - Motor unit action potential

MUAP (after recruitment and discharge information in sn3DF_MUPool)
    
    File and folder labels: var, config
    
    ExcDLev:    0.1:0.1:1, CD_lev, common drive, volitional control
    MNLev:      0.1:0.1:1, LMN_lev, remaining LMN function level
    alphaExcD:  0.1:0.1:1, UMN_lev, remaining UMN function level
    FBL:        0.1:0.1:1, MF_lev, % of remaining muscle fibers within each MU

LMNidx = LMN # to be included, only read if LMNrem is empty
LMNrem = remaining LMNs, specify which LMNs are left with different levels
of remaining LMN function

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
nMU = length(files_MUfb);
cd(op_DF);load(['MUAP_DF_',config,'_tra',num2str(traNum)],'discharge_ms')

outFolder = var;
cd(op_Poten)
if ~isfolder(outFolder)
    mkdir(outFolder)   
end
outPath = fullfile(op_Poten, outFolder);

%% 2 Recruitment

RR = 40; % range of recruitment

PFR1 = 45; % imp/s
PFRD = 10; % imp/s

gain_E = 1; % need validation

co_a = log(RR)/nMU;
iMN = 1:1:nMU;
RTE = exp(co_a*iMN); % Eq(1); recruitment threshold excitation for ith MN

% Rate coding
FRmin = 8; % min steady firing rate, assigned 8 imp/s
PFR = PFR1 - PFRD * RTE/RTE(nMU); % Eq(5)

ExcD_max = RTE(nMU) + (PFR(nMU)-FRmin)/gain_E; % Eq(8)
ExcD_max_aval = alphaExcD .* ExcD_max; % actually outputting

%% 4 MUAP

dt = 0.1;
t = 0:dt:simT; % ms

obs_t = 0:dt:obsT; % obs time

for cntFBL = 1:length(FBL)

FBLev = FBL(cntFBL);

for cntAE = 1:length(alphaExcD)

cExcD = ExcD_max_aval(cntAE);

for cntMNL = 1:length(MNLev)
  
MNperc = MNLev(cntMNL)*100;
if isempty(LMNrem)
    kp_nMU_idx = LMNidx;
else
    kp_nMU_idx = LMNrem.(['MNLev',num2str(MNperc)]); % remaining MUs
end

for cntExd = 1:length(ExcDLev)
    
    fnPotenSD = ['PotenSD_','nMNLev',num2str(MNLev(cntMNL)*100),...
        '_ExcDLev',num2str(ExcDLev(cntExd)*100),...
        '_alpha',num2str(alphaExcD(cntAE)*100),...
        '_FBL',num2str(FBLev*100),...
        '_tra',num2str(traNum)];
    
    cd(outPath)
    
    if isfile([fnPotenSD,'.mat'])
        continue;
    end
    
    ExcD = ExcDLev(cntExd) * cExcD;
    if ExcD < RTE(kp_nMU_idx(1))
        continue;
    end
    
    for cntMN = kp_nMU_idx % for each MN
        ExcD_adj = ExcD;
        
        if ExcD_adj >= RTE(cntMN) % if Exc Drive is lower than RTE, skip this MN.

            cd(rPath)
            fntoload = ['MU',num2str(cntMN),'_FBL_',num2str(FBLev*100),'.mat'];
            lastwarn('');
            matfile(fntoload);
            [~, warnId] = lastwarn;
            if contains(warnId, 'UnableToRead')
                disp(['fail to load: ',fntoload]);
                continue;
            end
            toload = load(fntoload); % new: MU_fb LOI_MUAP locations of interest
            MU_fb = toload.MU_fb;
            LOI_MUAP = sum(MU_fb,1);
            
            % extract MU discharge time
            MU_discharge = discharge_ms(cntMN,:);
            MU_disc_idx0 = round(MU_discharge(MU_discharge < obsT)/dt)+1;
            MU_disc_idx = MU_disc_idx0(sort(randperm(length(MU_disc_idx0),round(length(MU_disc_idx0)))));
            % starts at 0, idx = 1;

            % each location on z (electrodes)
            LOI_MUAPs = zeros(1,length(obs_t));

            % each discharge
            LOI_MUAP_disch = zeros(length(MU_disc_idx),length(obs_t));
            for cnt_disch = 1:length(MU_disc_idx)
                temp = zeros(1,length(obs_t));
                if length(temp)-MU_disc_idx(cnt_disch)-1 >= length(t)
                    temp(MU_disc_idx(cnt_disch):MU_disc_idx(cnt_disch)+length(t)-1) = LOI_MUAP;
                else
                    endpoint = length(temp)-MU_disc_idx(cnt_disch)+1;
                    if  endpoint > length(LOI_MUAP)
                        endpoint = length(temp)-MU_disc_idx(cnt_disch);
                        temp(MU_disc_idx(cnt_disch):end-1) = LOI_MUAP(1:endpoint);
                    else
                        temp(MU_disc_idx(cnt_disch):end) = LOI_MUAP(1:endpoint);
                    end
                end
                LOI_MUAP_disch(cnt_disch,:) = temp;                
            end

            LOI_MUAPs(1,:) = sum(LOI_MUAP_disch,1);
            
            if cntMN == kp_nMU_idx(1)
                potenSD = LOI_MUAPs;
            else
                potenSD = potenSD + LOI_MUAPs;
            end          
                  
        end
    end
    
    cd(outPath)
    save(fnPotenSD,'potenSD')
    clear potenSD
end


end
end
end
