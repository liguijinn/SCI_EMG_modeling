function psiOut = psi_dVm2(z)

%{
Input: 
z: location in z direction

Output: 
second derivative of Vm

Project: SCI EMG modeling

Author: Guijin Li
Date: Oct 31st, 2023

Adaptive Neurorehabilitations Systems Lab
KITE Research Institute, Toronto Rehabilitation Institute
Institute of Biomedical Engineering, University of Toronto

%}

D1 = 96; % mVmm^-3

if z < 0
    
    psiOut = -exp(z).*(z.^3 + 6*(z.^2) + 6*z)*D1;
    
else
    psiOut = 0;
end

end