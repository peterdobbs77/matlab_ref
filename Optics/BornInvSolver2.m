%close all
clearvars


load forwdAdjSoln 
load measData_50sd

mu_a = 0.02; %cm^-1
mu_sp = 10; %cm^-1
gamma = 1.89;   % Bounday factor based on refractive index mismatch
omega = 2*pi*1e8;  % in radians/s, for 100 MHz frequency
cl = 3e10/1.34; %speed of light in tissue 


% Fluorescence properties (Indocyanine green equivalent)
phi = 0.02;
tau = 0.56e-9;


% Create a piecewise grid defining the unknown absorption due to
% fluorophore.
[X,Y] = meshgrid(0.05:0.1:9.95,0.05:0.1:4.95);
mu_axf = zeros(size(X,1),size(X,2));  % Initial approximation.


% Jacobian matrix

% Initialize

forwdData = repelem( transpose(forwdData), size(adjData,2),1);
adjData   = repmat( transpose(adjData), [size(adjData,2),1]);

J = (phi/complex(1,omega*tau))*forwdData.*adjData;

meas = measData(:);

muaxf = artSolve(J,meas);

figure
pcolor(X,Y,reshape(muaxf,50,100));axis image
hold on;
x=3;
y=3;
r=0.5;
theta = linspace(0,2*pi,20);
x=x+r*cos(theta);
y=y+r*sin(theta);
plot(x,y,'b*-')
