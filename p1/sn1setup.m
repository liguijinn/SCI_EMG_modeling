function sn1setup(SMU,nMU,MUT,density,MU_Rmin,MU_Rmax,MUc_xyz,cPath,op_MU)

%{

MUPool - 1 - Setup

Setup locations for all fibers in all MUs

Project: SCI EMG modeling (Li et al.)

%}

%% inputs
MUc_x = MUc_xyz(1);
MUc_y = MUc_xyz(2);
MUc_z = MUc_xyz(3);

pool_RxyA = MUT(1);
pool_RxyB = MUT(2);
dw = MUT(3);
d1 = MUT(4);

poolRratio = pool_RxyA/pool_RxyB;

%% MU Pool setup

setupfile=dir([SMU,'.mat']);

if isempty(setupfile)
    MU_Rxy = linspace(MU_Rmin,MU_Rmax,nMU); 
    MU_fiberNum = pi* (MU_Rxy.^2).*poolRratio * density;
    MU_fiberNum = round(MU_fiberNum); % convert to integers (get rid of .000)
    
    [xc,yc] = fiberelp_xy(MUc_x,MUc_y,nMU,pool_RxyA,pool_RxyB,1); 
    legend({'MU Pool territory','MU territory Centers - xy'})
    zc = fiberelp_yz(MUc_y,MUc_z,nMU,yc,pool_RxyB,dw,d1,1);
    legend({'MU Pool territory','MU territory Centers - yz'})
    MUPool_loc = [xc,yc,zc];
    save(SMU,'MUPool_loc','MU_fiberNum','MU_Rxy')
else
    load(setupfile.name) % MUPool_loc
    disp('already have: setup file startMU')
    xc = MUPool_loc(:,1);
    yc = MUPool_loc(:,2);
    zc = MUPool_loc(:,3);
end

cd(op_MU)
filenames = dir('loc_MU*.mat');
allMUlocFiles = {filenames.name};
cd(cPath)

for cntMU = 1:nMU
    
    if ~isempty(find(contains(allMUlocFiles,['MU',num2str(cntMU),'.mat']), 1))        
        disp(['already have fiber setup for MN',num2str(cntMU)])
        continue;
    end
    
    tpxc = xc(cntMU); tpyc = yc(cntMU); tpzc = zc(cntMU);
    tp_fiberNum = MU_fiberNum(1,cntMU);
    tp_Rxy = MU_Rxy(cntMU);
    tp_Ratio = tp_Rxy/pool_RxyB; tp_dw = tp_Ratio*dw; tp_d1 = tp_Ratio*d1;
    
    [tpMU_xi,tpMU_y0] = fiberelp_xy(tpxc,tpyc,tp_fiberNum,tp_Rxy*poolRratio,tp_Rxy,0);
    tpMU_zi = fiberelp_yz(tpyc,tpzc,tp_fiberNum,tpMU_y0,tp_Rxy,tp_dw,tp_d1,0);
    tp_xyz = [tpMU_xi,tpMU_y0,tpMU_zi];
    
    parsave_MUloc(['loc_MU',num2str(cntMU)],tp_xyz,cPath,op_MU)
    disp(['fiber setup: #MN=',num2str(cntMU),'; #fb=',...
        num2str(MU_fiberNum(1,cntMU))])
    clear tp*
    
end

save(SMU,'MU_fiberNum','-append')

