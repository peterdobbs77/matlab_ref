% STARTER CODE, PUPIL MODELS, CHAP 5 (J. Winters)
% PARAMETERS for Various Models:
ks = -10.0;  Tdelm = 0.1;  Tdelt = 0.3;  % static gain , time delays, model & techn
tau1 = 0.25; tau2 = .14;  tau3 = 0.1;    % time const, crit damped, LTI
tau2a = 0.1;  tau2b = 0.2;               % NEW F16
tau1p = tau1/2; tau1s = tau1*2;          % piecewise, 1st, parasym, sympath
tau2p = tau2/2; tau2s = tau2*2;          % piecewise, 2nd, also by 4 
kz1 = ks/tau1; kz2 = ks/(tau2^2);  kz3 = ks/(tau3^3);  
             kz2ab = ks/(tau2a*tau2b);   % NEW F16
% LTI Systems:
sys1 = zpk([],[-1/tau1],[kz1]);          % 1st-order LTI
%sys2 = zpk([],[-1/tau2 -1/tau2],[kz2]); % 2nd-order LTI
sys2 = zpk([],[-1/tau2a -1/tau2b],[kz2ab]); % 2nd-order LTI - NEW F16
sys3 = zpk([],[-1/tau3 -1/tau3 -1/tau3],[kz3]); % 3rd-order LTI
sys1.InputDelay = Tdelt; sys2.InputDelay = Tdelt; sys3.InputDelay = Tdelt;

% Prep Work - HW Part a, obtaining pulse response:
delt = 0.001; tmax = 4.0; tpulse = 1.0;  % prep for simulation
t = 0 : delt : tmax ;                    % time vector
non = tpulse/delt;  noff = (tmax/delt)-non;  
ntd = Tdelt/delt;  ntdm = Tdelm/delt;
uon = 1.0;                               % "on" magnitude for light
% Getting Inputs
u = uon*[zeros(501,1); ones(non,1); zeros(noff-500,1)]; % input pulse
y1 = lsim(sys1,u,t);                     % 1st order
y2 = lsim(sys2,u,t);                     % 2nd order
y3 = lsim(sys3,u,t);                     % 3rd order
y4(1:ntd) = 0.0; 
y5(1:ntd) = 0.0;
x2(1:ntd) = 0.0;
for i = ntd : (length(t)-1)              % time loop for Euler - 2 Nonlinear cases
  if y4(i) >= y4(i-1)                    % 1st order, piecewise tau             
      tau1pw = tau1s;
  else
      tau1pw = tau1p;
  end
  if y5(i) >= y5(i-1)                    % 2nd order, piecewise tau
      tau2pw = tau2s;
  else
      tau2pw = tau2p;
  end  
  f1 = (-y4(i)/tau1pw)+(ks/tau1pw)*u(i-ntd+1);   % 1st-order functional
  f2 = (-y5(i) - (2*tau2pw*x2(i)) + ks*u(i-ntd+1))/tau2pw^2; %2nd-ord
  y4(i+1) = y4(i) + delt*f1; 
  y5(i+1) = y5(i) + delt*x2(i);          % Euler; output y5 = state x1
  x2(i+1) = x2(i) + delt*f2;             % Euler; state x2 
end
figure(1)
%plot(t,y1,'--',t,y2,'-',t,y3,'.-',t,y4,'-',t,y5,'--');  % plot (3rd=solid, 1st=dashed) 
plot(t,u,':',t,y2,'-',t,y3,'.-',t,y5,'--');  % NEW F16 - only plotting 3 runs (no 1st-ord)   
xlabel('time (sec)'); ylabel('Change in Pupil Diameter (mm)')

% HW: Closed-Loop "Light Switch by Pupil" Simulation:
tmax2 = 12.0 ;  ythresh = -2;            % new tmax, give ythresh
t2 = 0 : delt : tmax2 ;
ntd2 = tmax2/delt ;
y42 = 0; y52 = 0.0; x22 = 0.0; u2 = 0.0; u2a = 0.0;
y42(1:ntd2) = 0.0; 
y52(1:ntd2) = 0.0;
x22(1:ntd2) = 0.0;
u2a(1:ntd2+1) = 0.0;  u2 = u2a';
u2(10:510) = uon; ii = 0;
for i = ntd : (length(t2)-1)              % time loop for Euler 
  if y42(i) >= y42(i-1)                   % 1st order, piecewise tau             
      tau1pw = tau1s;
  else
      tau1pw = tau1p;
  end
  if y52(i) >= y52(i-1)                   % 2nd order, piecewise tau
      tau2pw = tau2s;
  else
      tau2pw = tau2p;
  end  
  if i < (length(t2)-ntdm-1)
    if y42(i) >= ythresh                    % 1st order, piecewise tau             
      u2(i+ntdm+1) = uon;
    else
      u2(i+ntdm+1) = 0;
    end
    if y52(i) >= ythresh                    % 2nd order, piecewise tau
      u2(i+ntdm+1) = uon;
    else
      u2(i+ntdm+1) = 0;
    end
  end
  ii = ii + 1;
  f12 = (-y42(i)/tau1pw)+(ks/tau1pw)*u2(i-ntd+1);   % 1st-order functional
  f22 = (-y52(i) - (2*tau2pw*x22(i)) + ks*u2(i-ntd+1))/tau2pw^2; %2nd-ord
  y42(i+1) = y42(i) + delt*f12; 
  y52(i+1) = y52(i) + delt*x22(i);        % Euler; output y5 = state x1
  x22(i+1) = x22(i) + delt*f22;           % Euler; state x2 
end
figure(2)
subplot(2,1,1)
plot(t2,u2);  % plot   
axis([0 12 0 2])
subplot(2,1,2)
%plot(t2,y42+30,'-',t2,y52+30,'--');  % plot   
plot(t2,y52+30,'-');  % NWE F16 - only plotting 2nd-ord piecewise  
xlabel('time (sec)'); ylabel('Change in Pupil Area (mm^2)')
axis([0 12 10 30])