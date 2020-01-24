clear; close all;
t=0:0.001:2;
C_o = 0; % (1/10)*(1-exp(-10));
f = C_o;
% for n=1:1000
%     C_n = (1/(10+(2*1j*pi*n)))*(1-(exp(-10)*cos(-2*pi*n)));
%     C_m = (-1/(10-(2*1j*pi*n)))*((exp(-10)*cos(-2*pi*n))-1);
%     f   = f + (C_n*exp(1j*n*pi*t)) + (C_m*exp(-1j*n*pi*t));
% end
X = (1/(5+(1j*2*pi*t)));
f = X;

figure(1);
plot(t,f)
title('Periodic Exponential e^{-5t}');
ylabel('x(t)');
xlabel('Time (sec)');
axis([-1 2 0 1.2]);