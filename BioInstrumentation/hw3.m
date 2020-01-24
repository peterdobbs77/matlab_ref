clear; close all;

t=-2:0.001:2;
%% 1. Square Wave
% f=0;
% for m=1:25
%    a_m = 0; %(1/(pi*m))*(2*sin(m*pi) - sin(2*m*pi));
%    b_m = (1/(pi*m))*(1 + cos(2*m*pi) - 2*cos(m*pi));
%    f   = f + (a_m*cos(m*t*pi)) + (b_m*sin(m*t*pi));
% end
% figure(1);
% plot(t,f);
% title('Square Wave');
% xlabel('Time ');
% ylabel('x(t)');

%% 2. Sawtooth Wave
f=0;
for n=1:50
   b_n = (1/(pi*n))*(0 - cos(pi*n));
   f   = f + (b_n*sin(2*pi*n*t));
end
figure(2);
title('Sawtooth Wave');
plot(t,f)

%% 3. Periodic Exponential
%C_o = (1/4)*(1-exp(-4));
%f = C_o;
%for n=1:100
%    C_n = (-1/(4+(2*1j*pi*n)))*(exp(-4)-1);
%    C_m = (-1/(4-(2*1j*pi*n)))*(exp(-4)-1);
%    f   = f + (C_n*exp(1j*n*pi*t)) + (C_m*exp(-1j*n*pi*t));
%end
%figure(3);
%title('Periodic Exponential (e^-2t)');
%plot(t,f)

%% 4. Aperiodic Pulse
% T=50;
% fs=256;
% N=T*fs;
% t=(1:N)*T/N;
% f=(1:N)*fs/N;
% x(1:N)=0;
% x(1:N/2)=1;
% figure(4);
% title('Impulse');
% plot(t,x);
% 
% Xf=fft(x);
% Mag=abs(Xf(2:end))/(N/2);
% Phase=-angle(Xf(2:end))*(360/(2*pi));
% figure;
% plot(f(1:20),Mag(1:20),'xb'); hold on;
% title('fft');
% xlabel('Frequency (Hz)');
% ylabel('|X(f)|');
% 
% %
% A=(x./(pi*f)).*(sin(25*pi*f));
% B=(x./(pi*f)).*(1-cos(25*pi*f));
% C = sqrt(A.^2 + B.^2);
% figure;
% plot(f(1:20),C(1:20),'xb');
% %plot(w,X);
% %