% "STARTER" FOR USING LTI 1st-order Muscle Spindle SENSOR (see Figs in Chap 4, Winters)
% For Summed Combo of Step, Pulse, Ramp Inputs, 
% 1st-ORDER: Y(s)=[(k1 s + k0)/(tau s + 1)]U(s), broken into 2
global P
clear all

%==========================================================================
% PARAMETERS & MODEL CREATION:
P. tau = 0.1; % 0.004;                   % time constant tau
%P.k1 = 0.1; P.k0 = 5;             % rate parameter, static gain
P.k1 = 0.8; P.k0 = 7;
den = [P.tau 1];                  % denom for TF approach, e.g., eye
nump = [P.k1 0]; nums = [P.k0];   % num for primary, secondary
sysp = tf(nump,den);              % primary model as transfer function 
syss = tf(nums,den);              % secondary model as transfer function 
%__________________________________________________________________________
% PREP for Simulation (times):
P.delt = 0.001;  P.tmax = 1.0;     % ==> USER: delt, max time
t = [0:P.delt:P.tmax];               % time vector for step, lsim
%__________________________________________________________________________
% INPUTS:
niter = length(t);               % # of iterations 
ustep = 10;  upulse = 4;  uramp = 10.0; % ==> step, pulse, ramp magn
nstp = 500;                      % for start of step (in iterations) 
u1 = ustep*[0.1*ones(1,nstp) ones(1,niter-nstp)];  % step input vector for lsim 
u1(901:1001) = 0; 
nsw = 150;  nsw2 = 100;           % for pulse switch (in iterations)
u2 = upulse*[ zeros(1,nsw) ones(1,nsw2) zeros(1,niter-nsw-nsw2)]; % pulse
nsw3 = 499;                       % for end of ramp
u3 = uramp*[0 t(1:nsw3).*ones(1,nsw3) zeros(1,niter-nsw3-1)];  % ramp in
u = u1 + u2 + u3;                 % summed input (can take some off)
sysu_filt = tf([1],[.005 1]);     % light filtering of idealized input
ufilt = lsim(sysu_filt,u,t);      % mildly filtered muscle length (input perturbation) 
%__________________________________________________________________________
% SIMULATIONS (using lsim():
yp  = lsim(sysp,ufilt,t);         % primary AP response using LSIM, in Hz
ys  = lsim(syss,ufilt,t);         % secondary  response using LSIM, in Hz
y = yp + ys;                      % get summed response
%__________________________________________________________________________
% PLOTTING:
figure(1); set(1,'Color',[1 1 1]);  
subplot(2,1,1);                   % Inputs
plot(t,u1+u2+u3,'--',t,ufilt,'-'); ylabel('Input (mm, relative)');   
axis([0 1 -5 15]) 
subplot(2,1,2);                   % Outputs 
plot(t,yp,'r-',t,ys,'g-',t,y,'-.');  hold on; % ,t,y,'-');   
xlabel('Time (sec)'); ylabel('Firing Rate (Hz)'); 
axis([0 1 0 100])                 % assume saturates at 0 & 100 Hz


 