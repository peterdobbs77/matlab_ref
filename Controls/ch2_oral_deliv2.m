% STARTER CODE, ch2_drug_deliv.m ... code illustrating use of Hill functions for drug delivery
% There are 3 Hill functions - two related to rates, and one a "drug effect" mapping
% Digestive state equation assumes no loss of drug, i.e., enters blood at variable rate kdrate
% Blood compartment is ideally mixes, with loss to decay at variable rate 
% The latter is set so that output of "1.0" is ideal (i.e., x_blood = 0.1)
% Equations are just one way to implement it, here keeping it intuitive
% Input is drug or nutrition bolus (e.g., pill, meal) - amount is area under curve
global S P
clear all;
%__________________________________________________________________________
% Parameters:
P.kdmx = 4.0;  P.kds = 0.6;  P.nd = 2;  P.kd0 = 0.05;  % digestive rate via Hill
P.kbmx = 3.0;  P.kbs = 0.15;  P.nb = 4;  P.kb0 = 0.1;  % blood "loss" rate via Hill 
P.kemx = 2.0;  P.kes = 0.1;  P.ne = 2;     % blood conc to tissue "effect" mapping 
P.kvol = 1.0;  P.kb = 0.5;                 % volume
%__________________________________________________________________________
% Simulation Prep:
P.delt = 0.01;  P.tmax = 24;               % simulation times
S.t = 0.0 : P.delt : P.tmax;               % time vector  
S.u = zeros(1,length(S.t));  S.kdrate = zeros(1,length(S.t));
S.kbrate = zeros(1,length(S.t));
S.u(11:15) = 20;  S.u(801:805) = 20;       % input "impulses" of drug amount = height*(width*delt)
%S.u(1:20) = 7; S.u(601:620) = 1.5; S.u(1201:1220) = 1.5; S.u(1801:1820) = 1.5; %increase "impulses" to 4 times daily
S.u(1601:1625) = 1;                        % here an input "pulse" with ~same area
S.x(1,1:2) = [ 0  0];  S.y(1) = S.x(1,2);  % init states to x0 at i=1
%__________________________________________________________________________
% Simulation:
for i = 1 : (length(S.t)-1)                % time loop for Euler integr 
    S.kdrate(i) = P.kd0 + (P.kdmx*(S.x(i,1))^P.nd)/((P.kds^P.nd)+(S.x(i,1)^P.nd)); % Hill for dijestive rate
    S.kbrate(i) = P.kb0 + (P.kbmx*(S.x(i,2))^P.nb)/((P.kbs^P.nb)+(S.x(i,2)^P.nb)); % Hill for blood decay rate
    dfxd   = S.kdrate(i)*(S.u(i)-S.x(i,1));     % dx/dt = f() for digestive
    dfxb   = P.kb*P.kvol*(S.x(i,1) - S.kbrate(i)*S.x(i,2)); % - S.x(i,2));
    S.x(i+1,1) = S.x(i,1) + P.delt*(dfxd); % Euler, digestive amount state
    S.x(i+1,2) = S.x(i,2) + P.delt*(dfxb); % Euler, blood concentration state
    S.y(i+1) = (P.kemx*S.x(i+1,2)^P.ne)/((P.kes^P.ne)+(S.x(i+1,2)^P.ne));  % tissue "effect" of blood conc
end
S.kdrate(length(S.t)) = S.kdrate(length(S.t-1));  % So fk vector is right length
S.kbrate(length(S.t)) = S.kbrate(length(S.t-1));  % So fk vector is right length
%__________________________________________________________________________
% Plotting:
fig = figure(1); set(1,'Color',[1 1 1]);  fig.Name = 'Simple 2nd-Order NL (Hill) Oral Drug Delivery';
subplot(1,3,1);         % Rates & Output via Hill Functions (
   plot(S.x(:,1),S.kdrate(:),'-',S.x(:,2),S.kbrate(:),'--',S.x(:,2),S.y(:),'.-'); hold on; grid on; % plotting xa=xb & xc
   axis([0,0.3,0,2]);  xlabel('x_{Digestive, Blood}'); ylabel('Rates_{Digestive, Blood}, Effect');
subplot(1,3,2); 
   plot(S.t,S.x(:,1),'-',S.t,S.x(:,2)); hold on; grid on; % plotting xa=xb & xc
   axis([0,P.tmax,0,0.4]);  xlabel('time (hrs)'); ylabel('x_{Digestive, Blood}');
subplot(1,3,3);
   plot(S.t,S.y); hold on; grid on;
   xlabel('time (hrs)'); ylabel('Tissue "Effect" (1=ideal)'); axis([0,P.tmax,0,2]); 
%__________________________________________________________________________
 
