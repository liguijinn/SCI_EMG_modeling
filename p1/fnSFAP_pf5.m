function fnSFAP_pf5(cntMU,MU_xyz,y0r,MU_fiberNum,cv,fiberLen,posEnd1,...
    x,z,t,H_glo,LOI_z,LOI_x,outPath,cPath)
%{

SFAP calculation from IAP

MU Territory:
Center: xc,yc,zc
MU_fiberNum: number of fibers in the territory
MU_Rxy: radius in xy plane (muscle cross section)

Project: SCI EMG modeling (Li et al.)

%}

%% MU setup

MU_xi = MU_xyz(:,1);
MU_y0 = MU_xyz(:,2);
MU_zi = MU_xyz(:,3);

IAP_xzt = zeros(length(x), length(z), length(t));

[~, LOI_zidx] = ismember(LOI_z,z); % index
[~, LOI_xidx] = ismember(LOI_x,x);

cd(outPath);fbFiles = dir(['MU',num2str(cntMU),'_fb*.mat']);cd(cPath);
allfbFileNames = {fbFiles.name};
allfbsplit = cellfun(@(x) split(x,'_'), allfbFileNames, 'UniformOutput',false);
allfbs = cellfun(@(x) x{2,:}(1:end-4),allfbsplit,'UniformOutput',false);

%% Loop thru all muscle fibers within the MU
% parfor i = 1:MU_fiberNum
for i = 1:MU_fiberNum
    
    if ~isempty(find(strcmp(allfbs,['fb',num2str(i)]), 1))        
        disp(['MU',num2str(cntMU),'fb#',num2str(i),': there']);
        continue;       
    end

    %% Fiber setup
    y0 = MU_y0(i);
    y0_idx = round(y0*10)./10 == round(y0r*10)./10;
    H_glo_i = H_glo(:,:,y0_idx);

    zi = MU_zi(i); % zi, NMJ location
    xi = MU_xi(i); % fiber location in x direction
    xi_idx = round(x*10)./10 == round(xi*10)./10;
    
    if sum(xi_idx)==0
        disp(['MU',num2str(cntMU),'fb#',num2str(i),': xi'])
        continue;
    end

    L1 = posEnd1 - zi;              % Right
    L2 = zi - (posEnd1 - fiberLen); % Left

    %% IAP, fft_IAP, and SFAP

    IAP_zt = zeros(length(z),length(t));

    for tt = 1:length(t)
        for zz = 1:length(z)
            IAP_zt(zz,tt) = calc_IAP(t(tt),z(zz),zi,cv,L1,L2);
        end
    end
    %}

    IAP_xzt(xi_idx,:,:) = IAP_zt;

    Phi_xzt_fromconv = zeros(length(x), length(z), length(t));
    for tt = 1:length(t)
        IAP = IAP_xzt(:,:,tt);
        Phi_xzt_fromconv(:,:,tt) = ifft2(fft2(IAP).*ifftshift(H_glo_i(:,:)));  
    end

    LOI_SFAP = squeeze(Phi_xzt_fromconv(LOI_xidx,LOI_zidx,:));
    parsave_fb(['MU',num2str(cntMU),'_fb',num2str(i)],LOI_SFAP,cPath,outPath) 
    clear Phi_xzt_fromconv H_glo_i
%     disp(['MU',num2str(cntMU),'fb#',num2str(i),' done'])

end

end