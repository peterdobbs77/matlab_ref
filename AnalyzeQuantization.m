clear; close all;
load quantization.mat

figure(1);
plot(t,x,'k'); hold on;
plot(t,y,'b-'); hold on;
plot(t,z,'r-'); hold on;
hold off;
title('Comparison of continuous and sampled data');
ylabel('Magnitude');
xlabel('Time');
axis([0 max(t) 0 max(x)]);
label={'Original','6-bit ADC','4-bit ADC'};
legend(label);

yError=x-y;
zError=x-z;
figure(2);
plot(t,yError); hold on;
plot(t,zError); hold on;
hold off;
title('Comparison of error signals');
ylabel('Error');
xlabel('Time');
label={'x - y','x - z'};
legend(label);

V_rms_xy=sqrt(mean(yError).^2);
V_rms_xz=sqrt(mean(zError).^2);

theoreticalErrXY=sqrt((5^2)/(12*(2^6 -1)^2));
theoreticalErrXZ=sqrt((5^2)/(12*(2^4 -1)^2));