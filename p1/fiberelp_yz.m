function z = fiberelp_yz(y0,z0,n,y,RB,dw,d1,flagPlot)

%{

(y0,z0) - center of the MU territory in yz plane
n = number of fibers within the MU
y = loc in y direction

output:
loc of each fiber in the MU in z direction

Project: SCI EMG modeling (Li et al.)

%}

A = [z0 + dw,      y0 + RB];
B = [z0 + dw + d1, y0 + RB];
D = [z0 - dw - d1, y0 - RB];

co = polyfit([A(1),D(1)],[A(2),D(2)],1);
bd = (y - co(2))./co(1);

z = rand(n,1)*0.9 + bd;

if flagPlot
    figure;

    C = [z0 - dw,     y0 - RB]; 
    aa = [A;B;C;D;A];
    plot(aa(:,1),aa(:,2),'--','LineWidth',1.5); hold on
    
    plot(z,y,'x','LineWidth',1.5,'MarkerSize',10)
    xlabel('fiber direction (mm)')
    ylabel('fiber depth (mm)')
    set(gca,'ydir','reverse' )
    
end



