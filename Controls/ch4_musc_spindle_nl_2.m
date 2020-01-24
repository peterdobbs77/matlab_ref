% "STARTER" FOR USING LTI 1st-order Muscle Spindle SENSOR (see Figs in Chap 4, Winters)
% For Summed Combo of Step, Pulse, Ramp Inputs 
% Core: 1st-ORDER: Y(s)=[(k1 s + k0)/(tau s + 1)]U(s), broken into 2
% Added: mildly soothed input; 
global S P U
clear all
%==========================================================================
% PARAMETERS & MODEL CREATION:
P.tau = 0.1;  P.tauU = 0.005;    % time constant tau
P.k0 = 7; P.k1 = 0.8; P.k2 = 0.002; % static gain, rate param, accel param 
den = [P.tau 1];                   % denom for TF approach, e.g., eye
nump = [P.k1 0]; nums = [P.k0];    % num for primary, secondary
P.kmx = 105.0;  P.nh = 2;          % Hill's soft-sat max, nh
P.ksp = 40;  P.k0p = 2;            % Hill's ks, K0 for primary; init yp0
P.kss = 40;  P.k0s = 1;            % Hill's ks, K0 for secondary
sysp = tf(nump,den);               % primary model as transfer function 
syss = tf(nums,den);               % secondary model as transfer function
%syspa= tf([P.k2 0 0],[.0001 P.tau 1]); % primary accel part, for piecewise
%__________________________________________________________________________
% PREP for Simulation (times):
P.delt = 0.001;  P.tmax = 1.0;     % ==> USER: delt, max time
S.t = [0:P.delt:P.tmax];           % time vector for step, lsim
sysy0 = tf([P.tau],den);           % LTI object in case y0 not 0
P.y0 = 0;  P.yp0 = 0;             % initial firing (sec via length, primary)
S.y0 = zeros(1,length(S.t));
%__________________________________________________________________________
% INPUTS:
niter = length(S.t);               % # of iterations 
U.step = 10;  U.pulse = 4;  U.ramp = 10.0; % ==> step, pulse, ramp magn
U.nstp = 500;                      % for start of step (in iterations) 
S.u1 = [(P.y0/P.k0)*ones(1,U.nstp) U.step*ones(1,niter-U.nstp)]; % step input y0 to new 
S.u1(901:1001) = 4;                % if desire to turn off step   
U.npon = 150;  U.npwid = 100;      % for pulse switch (in iterations) - on & width
S.u2 = U.pulse*[ zeros(1,U.npon) ones(1,U.npwid) zeros(1,niter-U.npon-U.npwid)]; % pulse
U.nrmp = 498;                      % for end of ramp
S.u3 = U.ramp*[0 0 S.t(1:U.nrmp).*ones(1,U.nrmp) zeros(1,niter-U.nrmp-2)];  % ramp in
S.u = S.u1 + S.u2 + S.u3;          % summed input (can take some off)
sysu_filt = tf([1],[P.tauU 1]);    % light filtering of idealized input
S.ufilt = lsim(sysu_filt,S.u,S.t); % mildly filtered muscle length (input perturbation) 
S.ufil0 = (P.y0/P.k0).*exp(-S.t./P.tauU);  % exp response due to initial firing rate 
S.ufilt = S.ufilt' + S.ufil0;
%__________________________________________________________________________
% SIMULATIONS (using lsim():
S.ys  = lsim(syss,S.ufilt,S.t);    % secondary  response using LSIM, in Hz
S.yp  = lsim(sysp,S.ufilt,S.t);    % primary AP vel response using LSIM, in Hz
%S.ypa = max(S.ypa,0);             % keeping only positive (stretching) accel contributions
S.ys0  = P.y0.*exp(-S.t./P.tau);   % exp response due to initial firing rate 
S.ys  = S.ys + S.ys0';             % here giving initial FR to secondary
S.yp0 = -(P.k1/P.tau)*(P.y0/S.u(1)).*exp(-S.t./P.tau); % exp rate response, initial jumps 
S.yp  = S.yp + S.yp0' ; %+ S.ypa;  % adding rate and PW lin accel for primary
S.ypa = [0 P.k2*(diff(S.yp)/P.delt)']; % scaled derivative for acceleation
S.ypa= min(max(S.ypa,0),100);      % acceleration saturating of primary at 0
S.yp = S.yp + S.ypa';              % total primary (vel & accel, piecewise)
S.yp = min(max(S.yp+P.yp0,-P.yp0),100); % velocity saturating of primary 
S.ys = min(max(S.ys,0),100);       % saturating of secondary       
S.ysum = S.yp + S.ys;              % get summed response
S.ysum = min(max(S.ysum,0),100);      % acceleration saturating of primary at 0
S.yave = (S.yp + S.ys)./2;         % get average response
S.ypn = S.yp + P.k0p;              % nonlinear shift
S.yp = max(S.yp,0);          % full saturating of primary 
S.ypnl = P.k0p + (P.kmx.*S.ypn.^P.nh)./((P.ksp.^P.nh)+(S.ypn.^P.nh)); % soft-saturation of S.yp
S.ysnl = P.k0s + (P.kmx.*S.ys.^P.nh)./((P.kss.^P.nh)+(S.ys.^P.nh)) ;  % soft-saturation of S.ys
S.ypnl_n = S.ypnl/100;  S.ysnl_n = S.ysnl/100;  % Normalizing for "Fuzzy or" math
S.ynl = 100*(S.ypnl_n + S.ysnl_n - (S.ypnl_n.*S.ysnl_n)); % get NL ("fuzzy or") summed response
%__________________________________________________________________________
% PLOTTING:
figure(1); set(1,'Color',[1 1 1]);  
subplot(3,1,1);                    % Inputs
plot(S.t,S.u,'--',S.t,S.ufilt,'-',S.t,S.u1,':',S.t,S.u2,':',S.t,S.u3,':'); grid on; 
xlabel('Time (sec)'); ylabel('Input (mm, relative)');   
axis([0 1 -2 12]) 
subplot(3,1,2);                    % Outputs 
plot(S.t,S.yp,'r-',S.t,S.ys,'g-',S.t,S.ysum,'k--',S.t,S.yave,'m--');  hold on; grid on; % ,t,y,'-');   
xlabel('Time (sec)'); ylabel('Firing Rate (Hz)'); 
axis([0 1 -10 110])                % assume saturates at 0 & 100 Hz
subplot(3,1,3);                    % Outputs 
plot(S.t,S.ypnl,'r-',S.t,S.ysnl,'g-',S.t,S.ynl,'k--');  hold on;  grid on; % ,t,y,'-');   
xlabel('Time (sec)'); ylabel('Firing Rate (Hz)'); 
axis([0 1 -10 110])                % assume saturates at 0 & 100 Hz

 