%example 3.4
clear; close all;

T=1;                                    % total time
fs=256;                                 % assumed sample frequency
N=fs*T;                                 % calculate number of points
t=(1:N)*T/N;                            % generate time vector
f=(1:N)*fs/N;                           %  and frequency vector for plotting
x=[t(1:N/2) zeros(1,N/2)];              % Generate signal, ramp-zeros
figure(1);
plot(t,x); hold on;
xlabel('Time (s)');
ylabel('Signal');
Xf=fft(x);                              % Take Fourier transform
Mag=abs(Xf(2:end))/(N/2);               % Calculate magnitude, remove DC value, and scale
Phase=-angle(Xf(2:end))*(360/(2*pi));   % Calculate phase and remove first point
    % 'angle' gives you in radians, so you have to convert
figure(2);
plot(f(1:20),Mag(1:20),'xb'); hold on;
title('Example 3.4 Results - fft');
xlabel('Frequency (Hz)');
ylabel('|X(f)|');
% ...labels

%calculate discrete Fourier transform using basic equations
for m = 1:20 
    a(m) = (2/N)*sum(x.*(cos(2*pi*m*t)));       % Non-complex 
    b(m) = (2/N)*sum(x.*(sin(2*pi*m*t)));       %  correlation eq. 
    C(m) = sqrt(a(m).^2 + b(m).^2);             % Calculate magnitude 
    theta(m) = (360/(2*pi)) * atan2(b(m),a(m)); %  and phase 
end 
%.......plot, label, and display....... 
figure(3);
plot(f(1:20),C(1:20),'xb'); hold on;
title('Example 3.4 Results - discrete fft');
xlabel('Frequency (Hz)');
ylabel('|X(f)|');

%% The spectrum produced by the two methods is identical!