function psiOut = psi_dVm(z)

%{
Input: 
z: location in z direction

Output: 
first derivative of the voltage (Vm)

Project: SCI EMG modeling

Author: Guijin Li
Date: Oct 31st, 2023

Adaptive Neurorehabilitations Systems Lab
KITE Research Institute, Toronto Rehabilitation Institute
Institute of Biomedical Engineering, University of Toronto

%}

D1 = 96; % mVmm^-3

if z < 0
    psiOut = exp(z).*(3*((-z).^2) + (-z).^3)*D1;
else
    psiOut = 0;
end


end