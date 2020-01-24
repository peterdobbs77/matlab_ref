% Chapter 3 JBK Starter Code, here for step response 2 ways, pulse
% Model Params:
%P.j = .1; P.b = 4;  P.k = 20;    % JBK params
P.j = .001 + (.0003*165);
P.b = 5;
P.k = 50; % parameter when co-act = 0.0
sys_tf = tf(1,[P.j P.b P.k]);  sys_zp = zpk(sys_tf);  sys_ss = ss(sys_tf);
% Prep:
t = 0 : .001 : 1;              % Time vector
P.stepMag = 10.0;  P.pulseMag = 120.0;  P.pulseWidth = int16(10);
ustep = P.stepMag*ones(length(t),1);
upuls = [P.pulseMag*(ones(P.pulseWidth,1)); zeros(length(t)-P.pulseWidth,1)];
% Simulations (3):
y  = P.stepMag*step(sys_tf,t);   % Step response
ys = lsim(sys_tf,ustep,t);       % Step response with lsim()
yp = lsim(sys_tf,upuls,t);       % Impulse/Pulse response with lsim()
% Plotting:
figure(1); set(1,'Color',[1 1 1]);
plot(t,y,'-',t,ys,':',t,yp,'--'); grid on; hold on;
xlabel('Time'); ylabel('Outputs');
axis([0 1 0 .5]);
title('JBK model when co-act = 0.0, 0.2, 0.4');

figure(2); set(2,'Color',[1 1 1]); grid on; hold on;
plot(t,ys,'-');
xlabel('Time'); ylabel('Outputs');
axis([0 1 0 1.6]);
title('Step Response of 10Nm');

figure(3); set(3,'Color',[1 1 1]); grid on; hold on;
plot(t,yp,'-');
xlabel('Time'); ylabel('Outputs');
axis([0 1 0 0.2]);
title('Impulse Response');

zeta = P.b/(2*sqrt(P.k*P.j));