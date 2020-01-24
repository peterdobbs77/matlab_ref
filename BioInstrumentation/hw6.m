clear; close all;
%% 1. Calculate change in V_out
I = 14e-3; %current
R = 4.5e3; %maximum resistance
angle = 165; %change in angle (degrees)

deltaV_out = I*R*(angle/360);
disp(deltaV_out);


%% 4. Calculate the beta of a thermistor
Rt = 4.4e3; Ro = 2.85e3;
T = 21+273; To = 21+(21*.1)+273;
beta = (log(Rt/Ro)) * ((1/T - 1/To)^-1);
disp(beta);