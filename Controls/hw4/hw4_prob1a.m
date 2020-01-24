% Unit step response for open-loop system
%
%   steady-state error:     nearly 0
%   rise time:              17 - 180 = 99 seconds
%   settling time:          226 - 301 = 45 seconds

tau1 = 0.5; tau2 = 0.2; 
Ks = 2.0;
sysp = tf(Ks,[(tau1*tau2) (tau1+tau2) 1]);
sysp.InputDelay = 0.04;
t = 0:0.01:3;
uo = 1;
y = uo*step(sysp,t);
plot(t,y);
grid on;