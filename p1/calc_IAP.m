function IAP_out = calc_IAP(t,z,zi,v,L1,L2)

%{
Inputs:
t: time point of the observation (or of a given propogation from NMJ
z: location of the fiber
zi: location of the NMJ
v: propogation velocity (4 m/s)

Output:
IAP at a given location at a given time point.

Project: SCI EMG modeling

Author: Guijin Li
Date: Oct 31st, 2023

Adaptive Neurorehabilitations Systems Lab
KITE Research Institute, Toronto Rehabilitation Institute
Institute of Biomedical Engineering, University of Toronto

%}

GEN = 2*psi_dVm(-v*t);

% step functions for propagation, both directions from NMJ, fiberZ, not ZR
% Or Tukey window [Carriou et al (2016)]
p1_z = heaviside(z-zi) - heaviside(z-(zi+L1));
p2_z = heaviside(z-(zi-L2)) - heaviside(z-zi);

EOF1 = -psi_dVm(L1-v*t); EOFZ1 = zi + L1;
EOF2 = -psi_dVm(L2-v*t); EOFZ2 = zi - L2;

IAP_out = GEN*(abs(z-zi)<0.001) + ...
    psi_dVm2(z - zi - v*t)*p1_z + psi_dVm2(-z + zi - v*t)*p2_z + ...
    EOF1*(abs(z-EOFZ1)<0.001) + EOF2*(abs(z-EOFZ2)<0.001);
% account for floating-point roundoff error

end