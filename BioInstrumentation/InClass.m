%% Example 2.2
% generate 4Hz sine, 1.0 amp; use N=500 pts, fs=500Hz. Plot & Calculate RMS
clear; close all;
f=4;        % sine wave frequency
amp=1;      % sine wave amplitude
N=500;      % number of points
fs=500;     % sample interval
t=0:1/N:1;  % generate time vector

y=amp*sin(2*pi*f*t);    % generate sine vector

RMS=sqrt(mean(y.^2));    % calculate RMS
disp(RMS);               %  and display

figure(1);
plot(t,y,'k','LineWidth',2) % plot y vs x
hold on;

phase=pi/4; % phase value
y2=amp*sin(2*pi*f*t+phase);
plot(t,y2,'b','LineWidth',2) % plot y2 vs x
hold off;