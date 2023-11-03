function I = calc_tripole(len, dist)

%{

Mesin and Farina 2006, 9 mm tripole set up: I1 - a - I2 - b - I3

I1+I2+I3 = 0;
a/b = abs(I3/I2);

Impulse amplitudes: I1 = 24.6, I2 = -35.4, I3 = 10.8 (A/m^2)
a = 2.1, b = 6.9 (mm) for 9mm --> 1.6 and 5.4 (mm) for 7mm (same ratio)

Project: SCI EMG modeling

Author: Guijin Li
Date: Oct 31st, 2023

Adaptive Neurorehabilitations Systems Lab
KITE Research Institute, Toronto Rehabilitation Institute
Institute of Biomedical Engineering, University of Toronto

%}

%%
cv = 4; % mm/ms

I1 = 24.6 * 1e6; % A/(mm^2)
I2 = -35.4 * 1e6;
I3 = 10.8 * 1e6;

ratio = abs(I3/I2);
% a = b*ratio; a+b = len; --> b*(1+ratio) = len
b = round(len/(1+ratio)*10) / 10;
a = len - b;

t_duration = dist/cv; % ms

t = 0:0.1:t_duration; % ms
z = 0:0.1:dist;       % mm

I = zeros(len/0.1,1); % step = 0.1 mm
I(1) = I1;
a_idx = round(a/0.1); % remove trailing zeros after the decimal point
I(a_idx) = I2;
I(end) = I3;


% IAP = zeros(length(z), length(t));
% 
% for i = 1:length(t)
%     z_st = 1 + cv*(i-1);
%     z_ed = z_st + len/0.1 - 1;
%     IAP(z_st:z_ed,i) = I';
% end

% figure;mesh(IAP)

end