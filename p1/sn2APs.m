function sn2APs(SMU,SHY,nMU_sta,nMU_end,fiberLen,cv,LOI_z,LOI_x,simT,cPath,op_MU,op_fb)

%{

MUPool - 2 - generate action potential

Generate SFAP for all fibers (in all MUs)

Project: SCI EMG modeling (Li et al.)

%}

%% inputs
startMU = load([SMU,'.mat']);
MU_fiberNum = startMU.MU_fiberNum;

startHY = load([SHY,'.mat']);
y0r = startHY.y0r;
H_glo = startHY.H_glo;

posEnd1 = fiberLen/2; 

dz = 0.1;
dx = 0.1;
dt = 0.1; 
t = 0:dt:simT; % ms
z = -(fiberLen/2):dz:(fiberLen/2); % mm
x = -10:dx:10; % mm

%% check progress (existing/previously generated fibers)
cd(op_fb)
filenames = dir('MU*_fb*.mat');
allMUfb = {filenames.name};
allMUfbsplit = cellfun(@(x) split(x,'_'), allMUfb, 'UniformOutput',false);
allMU = cellfun(@(x) x{1,:},allMUfbsplit,'UniformOutput',false);
MUlist = unique(allMU);
cd(cPath)

%% AP

% ticMN = tic; % check time needed for one MU (un-comment if needed)
% parfor cntMN = 1:nMN % for each MN
for cntMU = nMU_sta:nMU_end
    
    cv_MU = cv(cntMU);
    tb_MUfbNum = MU_fiberNum(2,cntMU);
    
    if ~isempty(find(contains(MUlist,['MU',num2str(cntMU)]), 1))        
        cd(op_fb);fbs = dir(['MU',num2str(cntMU),'_fb*.mat']);cd(cPath)
        if length(fbs) == tb_MUfbNum
            continue;
        end
    end
    
    cd(op_MU);
    tpLoad =load(['loc_MU',num2str(cntMU),'.mat']); %MUxyz
    cd(cPath);
%     ticfb = tic; % check time needed for one fiber (un-comment if needed)
    
    fnSFAP_pf5(cntMU,tpLoad.MUxyz,y0r,tb_MUfbNum,cv_MU,fiberLen,posEnd1,...
        x,z,t,H_glo,LOI_z,LOI_x,op_fb,cPath);
    
%     tocfb = toc(ticfb);
%     disp(['Elapsed time MN',num2str(cntMU),' :',num2str(tocfb),' sec'])
    disp(['from sn2APs: ',SHY(end-8:end),...
        '; #MN=',num2str(cntMU),'; #fb=',num2str(tb_MUfbNum)])
    
end

% tocMN = toc(ticMN); 
% disp(['Elapsed time all MN: ',num2str(tocMN/3600),' h'])
save([SMU,'.mat'],'MU_fiberNum','-append')
