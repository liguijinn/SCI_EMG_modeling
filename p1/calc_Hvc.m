function H_vc = calc_Hvc(kx,kz,y0,d,h1)

%{

Transfer function for volume conduction with given specifications

Project: SCI EMG modeling (Li et al.)

%}


%% Volume conduction
%{
Variables
thickness of tissue layers
Unit: mm

Conductivity: sigma
Unit: ohm/m
z: conductivity in the z direction (axial, fiber direction)
x: conductivity in the x direction (radial)
%}

% Conductivity                                  
% [Merletti Farina 2001, Fig.1]
% unit to ohm/mm (/1000)
sigma_f = 0.05/1000;             % fat, isometric    % sigma b
sigma_s = 1/1000;                % skin, isometric   % sigma c
sigma_mx = 0.1/1000;             % muscle (x=y)      % sigma 1a=2a
sigma_mz = 5*sigma_mx;           % muscle (z)        % sigma 3a

% conductivity ratios
rc = sigma_s/sigma_f;       
rm = sigma_f/sigma_mx;
ra = sigma_mz/sigma_mx; %JZ caught this

% angular frequencies
ky = sqrt(kx^2 + kz^2);
kya = sqrt(kx^2 + ra * kz^2);

% [Petersen 2019 Eq.26, to make Eq.25 shorter]
ky_plus = ky*(h1+d); % jia +    % fat + skin
ky_minus = ky*(h1-d); % jian -   % fat - skin

% [Petersen 2019 Eq.25, Merletti Farina 2001 Eq.1]
H_vc = 2*(exp(-abs(y0)*kya))/(sigma_mx*...
    ((1+rc)*cosh(ky_plus)*(kya+rm*ky_plus*tanh(ky_plus))+...
    (1-rc)*cosh(ky_minus)*(kya+rm*ky_minus*tanh(ky_minus))));

end