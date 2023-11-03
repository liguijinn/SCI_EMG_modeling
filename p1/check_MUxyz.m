function check_MUxyz(nMU,MUc_xyz,pool_RxyB,SMU,cPath,op_MU)
%{

Remove muscle fibers outside of the territory of a given MU

Project: SCI EMG modeling

Author: Guijin Li
Date: Oct 31st, 2023

Adaptive Neurorehabilitations Systems Lab
KITE Research Institute, Toronto Rehabilitation Institute
Institute of Biomedical Engineering, University of Toronto

%}

%% in MUxyz folder for checking
disp('check MUxyz')
load(SMU, 'MU_fiberNum')

MUc_x = MUc_xyz(1);
xL = MUc_x-pool_RxyB;
xR = MUc_x+pool_RxyB;

MUc_y = MUc_xyz(2);
yUp = MUc_y-pool_RxyB;
yDown = MUc_y+pool_RxyB;

for i = 1:nMU
    cd(op_MU)
    MUxyz = load(['loc_MU',num2str(i),'.mat']);
    tp_xyz = MUxyz.MUxyz;
    tp_x = tp_xyz(:,1);
    tp_y = tp_xyz(:,2);
        
    tp_delIdx_x = tp_x<xL|tp_x>xR;
    tp_delIdx_y = tp_y<yUp|tp_y>yDown;
    tp_delIdx = tp_delIdx_x|tp_delIdx_y;
    
    if ~isempty(find(tp_delIdx, 1))
        tp_xyz(tp_delIdx,:)=[];
        disp(['MN',num2str(i),' fiber num change: ',...
            num2str(MU_fiberNum(1,i)),' to ',num2str(MU_fiberNum(2,i))])
        cd(cPath)
        parsave_MUloc(['loc_MU',num2str(i)],tp_xyz,cPath,op_MU)
    end
    MU_fiberNum(2,i) = size(tp_xyz,1);
    
end
cd(cPath)
save(SMU,'MU_fiberNum','-append')
disp('check MUxyz done')