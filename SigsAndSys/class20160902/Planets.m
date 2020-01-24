% class work Sept 2, 2016
% MatLab 1 (from D2L)
clear
% WHEN PLANETS COLLIDE!!

% variable declaration
z = 0.01;
F = 180;
d1 = 1.4;
d2 = 2.45;
E1 = 2.3e7;
E2 = E1;
v1 = 0.3;
v2 = v1;

% setup
a = ((3*F/8)*(((1-v1^2)/E1 + (1-v2^2)/E2)/(((1/d1+1/d2)))))^(1/3);
Pmax = (3*F)/(2*pi*a^2);

% calc
Sigx = -Pmax*((1-(z/a)*atan(a/z))*(1-v1) - 0.5*(1+((z^2)/(a^2)))^-1);
Sigy = Sigx;

Sigz = -Pmax/(1+(z^2)/(a^2));

