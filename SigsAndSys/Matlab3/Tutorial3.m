%Matlab Tutorial 3
%Signals & Systems BIEN 3300
%Fall 2013

clear all
close all
clc

%% Energy

load('control_extension.txt');
load('control_flexion.txt');
load('stroke_extension.txt');
load('stroke_flexion.txt');

t2 = 0:0.001:9.999;

figure
subplot(4,1,1), plot(t2, control_extension)
title('Control Extension')
ylabel('amplitude')
subplot(4,1,2), plot(t2, control_flexion)
title('Control Flexion')
ylabel('amplitude')
subplot(4,1,3), plot(t2, stroke_extension)
title('Stroke Extension')
ylabel('amplitude')
subplot(4,1,4), plot(t2, stroke_flexion)
title('Stroke Flexion')
ylabel('amplitude')
xlabel('time (sec)')

EnergyCE = 0.001*trapz(abs(control_extension).^2)
EnergyCF = 0.001*trapz(abs(control_flexion).^2)
EnergySE = 0.001*trapz(abs(stroke_extension).^2)
EnergySF = 0.001*trapz(abs(stroke_flexion).^2)

%% Power

load('normal_sinus.txt')
load('aflut.txt')

t3 = 0:1/250:10-1/250;

figure
subplot(2,1,1), plot(t3, normal_sinus)
title('Normal Sinus Rhythm')
ylabel('amplitude')
subplot(2,1,2), plot(t3, aflut)
title('Atrial Flutter')
ylabel('amplitude')
xlabel('time (sec)')

power_normal = (1/13)*(0.001*trapz(abs(normal_sinus).^2))
power_aflut = (1/24)*(0.001*trapz(abs(aflut).^2))

%% Time Scaling

t4 = (24/13)*t3;

figure
subplot(2,1,1), plot(t3, normal_sinus)
title('Normal Sinus Rhythm')
ylabel('amplitude')
subplot(2,1,2), plot(t4, aflut)
title('Time Scaled Atrial Flutter')
ylabel('amplitude')
xlabel('time (sec)')
axis([0,10, -1000,2000])
