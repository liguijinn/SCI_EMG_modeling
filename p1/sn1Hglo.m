function sn1Hglo(SHY,fiberLen,d,h1,pool_Rxy,MUc_y)

%{ 

MUPool - 1 - global transfer function

Setup the global transfer function with volume conduction and electrode
configuration

Project: SCI EMG modeling

Author: Guijin Li
Date: Oct 31st, 2023

Adaptive Neurorehabilitations Systems Lab
KITE Research Institute, Toronto Rehabilitation Institute
Institute of Biomedical Engineering, University of Toronto

%}

%%
setupfile=dir([SHY,'.mat']);

if ~isempty(setupfile)
    disp(['already have: ',SHY])
    return;
end

% space
dz = 0.1;
dx = 0.1;
z = -(fiberLen/2):dz:(fiberLen/2); % mm
x = -10:dx:10; % mm

Nyq_z = 1/(2*dz); 
Nyq_x = 1/(2*dx); 
dfz = 1/(length(z)*dz);   
dfx = 1/(length(x)*dx);   
fz = -Nyq_z : dfz : Nyq_z-dfz;
fx = -Nyq_x : dfx : Nyq_x-dfx;
lenfx = length(fx);
lenfz = length(fz);

% Transfer functions

y0r = (MUc_y-pool_Rxy):0.1:(MUc_y+pool_Rxy);
leny0 = length(y0r);
H_ele = zeros(lenfx,lenfz);   
H_vc = zeros(lenfx,lenfz);
H_glo = zeros(lenfx,lenfz,leny0);
% ticH = tic; % check time needed (un-comment if needed)
for i = 1:leny0
    y0i = y0r(i);
for n = 1:lenfz 
%     parfor n = 1:lenfz        
    for m = 1:lenfx
        H_vc(m,n) = calc_Hvc(fx(m),fz(n),y0i,d,h1);
        H_ele(m,n) = calc_Hele(fx(m),fz(n)); 
        H_glo(m,n,i) = H_vc(m,n) * H_ele(m,n);
    end  
end
end
% tocH = toc(ticH);
% disp(['Elapsed time transfer func: ',num2str(tocH),' sec'])
save(SHY,'H_glo','y0r')
