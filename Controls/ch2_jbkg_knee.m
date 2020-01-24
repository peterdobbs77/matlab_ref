% STARTER CODE, Knee JBK + Gravity Model  
% To use linear K, just use ksl part (i.e., set kfm=0)
global S P
clear all;
%__________________________________________________________________________
% PARAMETERS:
P.J = 0.8;  P.B = 4.0;           % Inertia, dashpot (default ave-to-small male)
P.mgl = 40.0;                    % Grav moment (default ave-to-small male, ~160 Ibs
P.ksl = 4.0 ;  P.ksh = 8.;       % kslope in Nm/r, ksh dimensionless (hi=concavity)
P.kxm = 1.0;   P.kfm = 100.0;    % kxm in rad; kfm in Nm (crossing coords)
P.z_angle = 60.;                 % resting knee angle, wrt straight leg, deg
P.phi = (30/57.296);             % grav vector shift, from rest angle, to 90, rad
P.nsens = 1;                     % >1 implies sensitivity runs
%__________________________________________________________________________
% SIMULATION PREP:
P.delt = 0.001; P.tmax = 1.0;    % delt, tmax
S.t = 0:P.delt:P.tmax;           % time vector
S.u = zeros(length(S.t),1);      % starting vector of zero pulse disturbances
P.upulse = 0;                    % pulse disturbance input magn, in Nm
P.ibeg = 200; P.iend = 250;      % pulse beginning and end times (in steps)
S.u(P.ibeg:P.iend) = P.upulse;   % adding pulse input (ext perturbation)
S.x = zeros(length(S.t),2);  S.fk = (zeros(length(S.t),1));  
S.x0(1,1) = (-30/57.296);        % init state: position angle wrt z_angle) 
S.x0(1,2) = 0.0;                 % init state: velocity
%__________________________________________________________________________
% SIMULATION RUN(S):
for isens = 1 : P.nsens
  %if isens = 2, P.* = P.* ; end  % new param value
  S.x(1,:) = S.x0(1,:);  
  for i = 1 : length(S.t)-1     % Loop for Euler integration
    if S.x(i,1) > 0             % Implementing nonlinear spring
       S.fk(i) = P.ksl*S.x(i,1) + (P.kfm/(exp(P.ksh)-1))*(exp((P.ksh/P.kxm)*S.x(i,1))-1);
    else
       S.fk(i) = P.ksl*S.x(i,1) - (P.kfm/(exp(P.ksh)-1))*(exp((P.ksh/P.kxm)*(-S.x(i,1)))-1);
    end
    dx1 = S.x(i,2);             % Position
    dx2 = (-P.mgl*sin(S.x(i,1)-P.phi) - S.fk(i) - P.B*S.x(i,2) + S.u(i))/P.J;
    S.x(i+1,1) = S.x(i,1) + P.delt*dx1;   % Integration for position state
    S.x(i+1,2) = S.x(i,2) + P.delt*dx2;   % Integration for velocity state
  end
  %if isens = 2, P.* = P.* ; end  % reset to initial param value
end
S.fk(length(S.t)) = S.fk(length(S.t-1));  % So fk vector is right length
%__________________________________________________________________________
% PLOTTING:  By default there are 4 plots for figure 1, then fig 2 just 1st bigger 
fig = figure(1); set(1,'Color',[1 1 1]);  fig.Name = 'Knee JBK-Grav Plots';
subplot(2,2,1)                       % Phase plane
  plot(S.x(:,1)*57.296+P.z_angle,S.x(:,2),'LineWidth',2); hold on; grid on; % Note: in deg, knee angle
  xlabel('Joint Angle (deg)'); ylabel('Velocity (r/s)'); 
  axis([0 150 -10 10]); 
subplot(2,2,2)
  plot(S.t,S.x(:,1)*57.296+P.z_angle)     % Position, in deg, shifted to knee angle
  xlabel('Time (sec)'); ylabel('Joint Angle (deg)'); hold on;  grid on;
subplot(2,2,4)
  plot(S.t,S.x(:,2)) ; hold on; grid on;  % Velocity, in rad/sec
  xlabel('Time (sec)'); ylabel('Velocity (r/s)');
subplot(2,2,3)
  plot(S.t,S.fk); hold on; grid on;       % Moment in spring, in Nm
  xlabel('Time (sec)'); ylabel('Spring Mom (Nm)');

