function H_ele = calc_Hele(kx,kz)

%{

Transfer function for specific electrode configuration

Shown here: 2x1 bipolar electrode (Delsys Bagnoli)
Modifiable to other configurations

Project: SCI EMG modeling (Li et al.)

%}

%% Electrodes (ele)
% H_sf assumes point electrodes --> use H_size to take care of electrode
% size and shape

%-- spatial filtering from 2x1 electrode configuration
% simplified from [Farina, Merletti, 2001, Eq.2]
    % 1 col, dx = 0, drop col related terms
    % 2 row (w=h=1), dz = 10 mm
% same as H_ec from [Petersen 2019, Eq.30]
% grid electrode R x S. R = 1 (x direction), S = 2 (z/fiber direction)

a_ir = [-1 1]; % weights given to each electrode, same weight
dz = 10; % inter-electrodes distance in z direction (10 mm)
H_sf = 0;
for rtemp = 1:2 
    r = rtemp-2; % r goes from -1 to 0
    H_sf = H_sf + a_ir(rtemp) * exp(-1i*kz*r*dz);
end

%-- electrode size  [Farina, Merletti, 2001, Eq.6]
% Rectangular electrodes a x b. 
% a = 8mm (x direction); b = 1 mm (z/fiber direction)
a = 10; % mm, x direction
b = 1; % mm, z direction
H_size = sinc(a*kx ./ (2*pi))*sinc(b*kz ./ (2*pi));
    % sinc(w) = sinc(w*pi)/(w*pi), if w ~= 0
    % sinc(0) = 1;
    
H_ele = H_size * H_sf;

end