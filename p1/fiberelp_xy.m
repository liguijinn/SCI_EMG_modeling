function [x,y] = fiberelp_xy(x0,y0,n,RA,RB,flagPlot)

%{

R = MU territory radius
buff = Max radius of a single MU territory
(x0,y0) - center of the MU territory 
n = number of fibers within the MU

output:
(x,y) of each fiber in the MU

Project: SCI EMG modeling (Li et al.)

%}

ith = 2*pi*rand(n,1);
r = rand(n,1);

x = round((x0 + RB*r.*cos(ith))*10)./10;
y = round((y0 + RA*r.*sin(ith))*10)./10;

if flagPlot
    figure; 
    a = linspace(0,2*pi);
    x1 = x0 + RB*cos(a);
    y1 = y0 + RA*sin(a);
    plot(x1,y1,'--','LineWidth',1.5); hold on;
    plot(x,y,'x','LineWidth',1.5,'MarkerSize',10)
    xlabel('x direction (mm)')
    ylabel('fiber depth (mm)')
    axis equal
    set(gca, 'ydir', 'reverse' )
end