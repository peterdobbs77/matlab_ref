% Practice Opportunity 2
clear
close all
clc
% 1.
u = inline('1.*(t>=0)','t');
t = -20:0.01:20;
%    b.        
        figure        
        x1 = 5.*(u(t+6)-u(t+3));
        x2 = (-2*t-1).*(u(t+3)-u(t-3));
        x3 = (4*t-19).*(u(t-3)-u(t-5));
        x4 = (1).*(u(t-5)-u(t-6));
        plot(t,x1+x2+x3+x4)
        
%    c. x(t+3)
        figure
        x1 = 5.*(u(t+9)-u(t+6));
        x2 = (-2*(t+3)-1).*(u(t+6)-u(t-0));
        x3 = (4*(t+3)-19).*(u(t-0)-u(t-2));
        x4 = (1).*(u(t-2)-u(t-3));
        plot(t,x1+x2+x3+x4)
        
%    d. x(-t+3)
        figure
        x1 = 5.*(u(-t+9)-u(-t+6));
        x2 = (-2*(-t+3)-1).*(u(-t+6)-u(-t-0));
        x3 = (4*(-t+3)-19).*(u(-t-0)-u(-t-2));
        x4 = (1).*(u(-t-2)-u(-t-3));
        plot(t,x1+x2+x3+x4)

%    e. x(t/3)
        figure
        x1 = 5.*(u((t/3)+6)-u((t/3)+3));
        x2 = (-2*(t/3)-1).*(u((t/3)+3)-u((t/3)-3));
        x3 = (4*(t/3)-19).*(u((t/3)-3)-u((t/3)-5));
        x4 = (1).*(u((t/3)-5)-u((t/3)-6));
        plot(t,x1+x2+x3+x4)
        axis([-20 20 -8 6]);

% Lathi Problems
clear
close all
%    1.1.3a find energies of the signals
u = inline('1.*(t>=0)','t');
t = 0:0.01:2*pi;
%        i)
           funx = @(t) 1.*(u(t)-u(t-2));
           funy = @(t) 1.*(u(t)-u(t-1))+(-1.*(u(t-1)-u(t-2)));
           conn = quad(funx,0,2)
           conn = quad(funy,0,2)
           funx_y = @(t) 1.*(u(t)-u(t-2)) + (1.*(u(t)-u(t-1))+(-1.*(u(t-1)-u(t-2))));
           funxy = @(t) 1.*(u(t)-u(t-2)) - (1.*(u(t)-u(t-1))+(-1.*(u(t-1)-u(t-2))));
           conn = quad(funx_y,0,2)
           conn = quad(funxy,0,2)
%       ii)         
           x = @(t) sin((t>=0)-(t<2*pi));
           y = @(t) 1.*(u(t)-u(t-2*pi));
           conn = quad(x,0,2*pi)
           conn = quad(y,0,2*pi)
           x_y = @(t) sin((t>=0)-(t<2*pi)) + 1.*(u(t)-u(t-2*pi));
           xy = @(t) sin((t>=0)-(t<2*pi)) - 1.*(u(t)-u(t-2*pi));
           conn = quad(x_y,0,2*pi)
           conn = quad(xy,0,2*pi)
%      iii)        
           x = @(t) sin((t>=0)-(t<pi));
           y = @(t) 1.*(u(t)-u(t-pi));
           conn = quad(x,0,pi)
           conn = quad(y,0,pi)
           x_y = @(t) sin((t>=0)-(t<pi)) + 1.*(u(t)-u(t-pi));
           xy = @(t) sin((t>=0)-(t<pi)) - 1.*(u(t)-u(t-pi));
           conn = quad(x_y,0,pi)
           conn = quad(xy,0,pi)
           
%    1.1.5: pwr and rms value
clear
close all
clc
t = 0:0.01:10;
%        c) (10+2sin(3t))cos(10t)
            fun = (10+2*sin(3*t)).*cos(10*t);
            func = @(t) (10+2*sin(3*t)).*cos(10*t);
            pwr = quad(func,0,Inf)
            rootmeansquare = rms(fun)

%        e) 10*sin(5t)*cos(10t)
            fun = 10.*sin(5*t).*cos(10*t);
            func = @(t) 10.*sin(5*t).*cos(10*t);
            pwr = quad(func,0,Inf)
            rootmeansquare = rms(fun)
            
            
           