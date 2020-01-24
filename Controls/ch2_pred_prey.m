% STARTER: Predator-Prey-Resource Population Model with Logistic & Lotka-Volterra (Winters)
% Note: This script is set up more generally than the HW1 problem so as to expose students
%       to use of vectors of values, "for" loops, and Euler integration.  The key
%       adjustments are params P.mu & P.k & initial populations x0 (see Ex 2.4.2.2)
% Special cases: for single species (no predator "rate-logistic"), uncomment line 16 & comment out 1st plot
%                for idealized prey-prey model exhibiting limit cycles, uncomment line 18
global S P
clear all
%__________________________________________________________________________
% PARAMETER values (for default 3-species case, total of N = length(P.mu)):
P.mu = [100 200 50];    % ==> max carrying capacity for species (all non-zero)
P.k  = [1.0 1.0 1.0];   % ==> birth/death proportionality (exponential) rate constant 
P.k1 = [-1.0 1.0 1.0];  % ==> growth (1, birth >) or decay (-1, death) reference constant 
P.ef = [-0.1 1.0 1.0 ; -1.0 -0.1 0 ; -1.0 0 -0.1] ;  % norm effects(j,k), of k on j (square matrix)
P.h  = [0  0  0];       % Hypothetical sustained change in resources or threats
% 1-SPECIES "Logistic" special case: one non-prey, exp growth but "capacity"
  %P.mu = 100; P.k = 1.0; P.k1 = 1.0; P.ef = -1.0; P.h = 0; x0 = 50.0; 
% 2-SPECIES Lotka-Volterra special case (limit cycle):
  %P.mu = [100 200]; P.k = [1.0 1.0]; P.k1 = [-1 1]; P.ef = [0.0 1.0; -1.0 0.0]; P.h = [0 0]; x0 = [50 300];  
%__________________________________________________________________________  
% SIMULATION PREP:
P.delt = 0.01; P.tmax = 30.0;   % ==> Simuluation time parameters 
S.t = 0 : P.delt : P.tmax ;     % time vector (signal)
S.x0  = [50  300  50];          % ==> Initial states (i.e., populations, as column vector) 
S.x(1,:) = S.x0;                % initial values for loop iteration
S.y(1) = (S.x(1,1)/P.mu(1));    % initial output (alt: S.y(2:length(t)) = 1.0;) 
%__________________________________________________________________________  
% RUNNING SIMULATION (here using Euler integration): 
for i = 1 : length(S.t)-1
  S.y(i+1) = 1.0;
  for j = 1 : length(P.mu)
     S.dfsum(j) = P.k1(j);  % if pos, uni-trend towards exp growth, if neg, exp decay
     for k = 1 : length(P.mu)
        S.dfsum(j) = S.dfsum(j) + P.ef(j,k)*(S.x(i,k)/P.mu(k));  % Sum cross-species pred-prey effects
     end
     dfx(j) = P.k(j)*S.dfsum(j)*S.x(i,j) + P.h(j);   % getting dx/dt = f()
     S.x(i+1,j) = S.x(i,j) + P.delt*dfx(j);          % Euler Integration
     if S.x(i+1,j) > 0
        S.y(i+1) = S.y(i+1)*(S.x(i+1,j)/P.mu(j));    % "healthy" eco-pop if, say, y within ~0.8-1.1
     end
  end       % species loop
end         % time loop
S.y(length(S.t)) = S.x(length(S.t));  % for last iteration
%__________________________________________________________________________  
% PLOTTING:
fig = figure(1);  set(1,'Color',[1 1 1]); fig.Name = 'Predator-Prey Plots';
subplot(2,2,1)                            % Phase plane (adjust for #species, elim if 1)
  plot(S.x(:,1),S.x(:,2)); hold on; grid on; %,S.x(:,1),S.x(:,3)); 
  axis([0 250 0 500]); ylabel('Prey'); xlabel('Predator') 
subplot(2,2,2)
  for j = 1 : length(P.mu)
    plot(S.t,S.x(:,j)); hold on;  grid on; % States vs Time
    axis([0 P.tmax 0 500]); xlabel('time'); ylabel('Predator, Prey')
  end
subplot(2,2,4)  
  plot(S.t,S.y); hold on;  grid on;       % Output vs Time
  axis([0 P.tmax 0 2]); xlabel('time'); ylabel('"Eco-Health"') 
subplot(2,2,3)                            % 3D (only use if 3 species)
  plot3(S.x(:,1),S.x(:,2),S.x(:,3)); hold on;  rotate3d on;  grid on;
%__________________________________________________________________________  
