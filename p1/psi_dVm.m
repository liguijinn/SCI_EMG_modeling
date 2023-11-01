function psiOut = psi_dVm(z)

%{
Input: 
z: location in z direction

Output: 
first derivative of the voltage (Vm)

Project: SCI EMG modeling (Li et al.)

%}

D1 = 96; % mVmm^-3

if z < 0
    psiOut = exp(z).*(3*((-z).^2) + (-z).^3)*D1;
else
    psiOut = 0;
end


end