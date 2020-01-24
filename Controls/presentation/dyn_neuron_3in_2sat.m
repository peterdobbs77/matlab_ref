% Cynamic Neuron (additive model, nonlinear mapping function)
clear all;
P.w = [1 -1 2];     % synaptic weights; three weights for three inputs
P.b  = [0.1];       % bias
P.tau = 0.05;        % time constant
P.kmax = 1.1; P.ks = 0.4; P.nj = 2;
x0  = [0.1];     % Initial states (i.e., populations, as column vector) 
delt = 0.001; tmax = 0.5;  t = 0 : delt : tmax ;
u = 0.01*ones(length(t),length(P.w));
u(50:150,1)  = 1.0;  u(250:300,2) = 0.5;    % some input pulses
u(100:200,3) = 0.5;  u(400:450,3) = 0.4;    % some input pulses
x(1,1,1) = x0; x(1,1,2) = x0; % initial values for loop iteration
% Running Simulation (here using Euler integration):
for i = 1 : length(t)-1
  %y(i+1) = 0.1;
  for j = 1 : length(x0)
     dfsum(j) = P.b;
     for k = 1 : length(P.w)
        dfsum(j) = dfsum(j) + P.w(j,k)*(u(i,k));  % Sum cross-species pred-prey effects
     end
     df(i,j,1) = (dfsum(j)-x(i,j,1))/P.tau;       % df
     df(i,j,2) = (dfsum(j)-x(i,j,2))/P.tau;       % df
     x(i+1,j,1) = x(i,j,1) + delt*df(i,j,1);       % Euler Integration     
     x(i+1,j,1) = max(min(x(i+1,j,1),1),0);       % satlin mapping 
     x(i+1,j,2) = x(i,j,1) + delt*df(i,j,2);       % Euler Integration     
     x(i+1,j,2) = P.kmax*(x(i+1,j,2)^P.nj)/((P.ks(j)^P.nj)+(x(i+1,j,2)^P.nj)); % Hill soft-sat
  end
end
figure(1);  set(1,'Color',[1 1 1]);
subplot(2,1,2)
  plot(t,x(:,1,1),'r',t,x(:,1,2),'b'); hold on;  grid on;
  axis([0 tmax -0.05 1.05]); xlabel('time'); ylabel('Rel Neuron Excitation <0,1>');  
subplot(2,1,1)
  for j = 1 : length(P.w)
    plot(t,u(:,j)); hold on; grid on; % Inputs vs Time
    axis([0 tmax -0.05 1.05]); xlabel('time'); ylabel('Inputs <0,1>')
  end
