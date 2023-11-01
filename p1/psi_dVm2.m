function psiOut = psi_dVm2(z)

%{
Input: 
z: location in z direction

Output: 
second derivative of Vm

Project: SCI EMG modeling (Li et al.)

%}

D1 = 96; % mVmm^-3

if z < 0
    
    psiOut = -exp(z).*(z.^3 + 6*(z.^2) + 6*z)*D1;
    
else
    psiOut = 0;
end

end