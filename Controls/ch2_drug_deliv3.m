% STARTER CODE, 3-State Normalized Compartmental Model
% States: x1: Blood Plasma Concentration; 
%         x2: Target Tissue(s) Concentration; 
%         x3: Oral (digestive path);  (x4: skin patch taken out)
%         Note: simplified by taking out volume params (amount=conc*vol)
% Inputs: u1: Injection/IV; u2: Oral;  %u3: Intramuscular tissue / Patch 
% Outputs:  y1 = x2;  y2 = "effect" on tissue (as nonlinear mapping)
global S P
clear all;
%__________________________________________________________________________
% PARAMETERS:
P.A = zeros(3,3);  P.B = zeros(3,2);  P.Kelim = zeros(3); % Rates start as all zero's
P.Kelim(1) = 1.0;  P.Kelim(2) = 2;    P.Kelim(3) = 1.0; % self-elimination 1/tau values, from blood can include via urine
P.kmax = 1.2;  P.ks = 0.2;  P.nh = 2.0;    % "Effect" params: mapping via Hill Function
P.A(1,3) = 2.0;  P.A(2,1) = 3;        % ==> norm rates for x3 (oral) to x1 (BP), x1 to x2 (tissue)                             
P.A(1,1) = -(P.A(2,1) + P.A(3,1)) - P.Kelim(1) ;  % diagonal - losses from blood state (rates are like 1/tau)
P.A(2,2) = -(P.A(1,2) + P.A(3,2)) - P.Kelim(2) ;  % diagonal - losses from target tissue (e.g., some "lost" when "consumed")
P.A(3,3) = -(P.A(1,3) + P.A(2,3)) - P.Kelim(3) ;  % diagonal - losses from digestive (e.g., some not absorbed)
P.B(1,1) = 1.0;   P.B(3,2) = 1.0;   % Inputs: infusion & oral   
P.C = [0 1 0];    P.D = [0 0] ;     % output y1 here = 2nd state x2
sys_ss = ss(P.A,P.B,P.C,P.D,'TimeUnit','hours'); % SS LTI model, with A,B,C,D containing params 
sys_ss.InputDelay = [0.01; 0.1]; % Adding pure time delays (e.g., Blood transit; via Oral-digestive)
%__________________________________________________________________________
% SIMULATION PREP:
P.delt = 0.01;  P.tmax = 18;   % units are hours by default
S.t = [0 : P.delt : P.tmax];   % Time vector
S.x0 = [0; 0; 0];              % Init states
S.u = zeros(2,length(S.t));      % Inputs start at all 0's for all timesteps
S.u(1,100:105) = 10;           % Directly into Blood Plasma (Injection or IV)
S.u(2,500:505) = 10;           % Oral med delivery
S.u(1,1000:1801) = 0.4;        % to BP via IV
%__________________________________________________________________________
% SIMULATION RUN:
[S.y1,S.t,S.x] = lsim(sys_ss,S.u,S.t,S.x0);   % y1 is tissue concentration, also getting 4 states
S.y2 = (P.kmax.*(S.y1.^P.nh))./(P.ks^P.nh +(S.y1.^P.nh)); % "Effect" output from y1 (=x2) 
%__________________________________________________________________________
% PLOTTING:
figure(1); set(1,'Color',[1 1 1]);
t = S.t;
subplot(3,1,1)                        % Inputs       
  plot(t,S.u(1,:),'-',t,S.u(2,:),'--');  hold on;    grid on; 
  ylabel('Inputs (Bld, Oral)') 
 axis([0 P.tmax 0 10])
subplot(3,1,2)                        % States:
  plot(t,S.x);       hold on;  grid on;
  ylabel('States')
  axis([0 P.tmax 0 1])
 subplot(3,1,3)                       % Outputs
  eff_lo = 0.6*ones(1,length(t));     % ideal "effect" between 0.6 & 1
  plot(t,S.y1,'b-',t,S.y2,'b--',t,eff_lo,'-.');  hold on; grid on;
  ylabel('Outputs (Xtis, Effect)')
  axis([0 P.tmax 0 1]) 
%__________________________________________________________________________
