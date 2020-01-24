% pracOp5.m
%    Peter Dobbs
%    BIEN 3300
%    Practice Opportunity 5
%    24 October 2016
clear
close all
%% 2.4-15
t=-10:0.001:10;
x = 1./(t.^2+1);
h = step_func(t);
figure%('Name','Lathi 2.4-15','NumberTitle','off');
subplot(2,2,1),plot(t,x);
xlabel('Time (sec)');
ylabel('Signal Amplitude');
title('x(t)=1/(t^2+1)');
subplot(2,2,2),plot(t,h);
xlabel('Time (sec)');
ylabel('Signal Amplitude');
title('Step Function');
y=conv(x,h);
y=y.*0.001; %scaling by our incrementing factor for ‘t’
y1=y(10000:30000);
subplot(2,2,[3,4]),plot(t,y1)
xlabel('Time (sec)');
ylabel('Signal Amplitude');
title('Convolution of x(t) and h(t)');

%% 2.4-16
t = -10:0.001:10;
x = sin(t).*(step_func(t)-step_func(t-(2*pi)));
g = step_func(t);
figure%('Name','Lathi 2.4-16','NumberTitle','off');
subplot(2,2,1),plot(t,x);
xlabel('Time (sec)');
ylabel('Signal Amplitude');
title('x(t)=sin(t)');
subplot(2,2,2),plot(t,g);
xlabel('Time (sec)');
ylabel('Signal Amplitude');
title('Step Function');
y=conv(x,g);
y=y.*0.001; %scaling by our incrementing factor for ‘t’
y1=y(10000:30000);
subplot(2,2,[3,4]),plot(t,y1)
xlabel('Time (sec)');
ylabel('Signal Amplitude');
title('Convolution of x(t) and g(t)');

%% 2.4-18f
t = -10:0.001:10;
x1 = exp(-t).*step_func(t);
x2 = (step_func(t)-step_func(t-3));
figure%('Name','Lathi 2.4-18f','NumberTitle','off');
subplot(2,2,1),plot(t,x1);
xlabel('Time (sec)');
ylabel('Signal Amplitude');
title('x(t)=exp(-t)');
subplot(2,2,2),plot(t,x2);
xlabel('Time (sec)');
ylabel('Signal Amplitude');
title('Step Function');
y=conv(x1,x2);
y=y.*0.001; %scaling by our incrementing factor for ‘t’
y1=y(10000:30000);
subplot(2,2,[3,4]),plot(t,y1)
xlabel('Time (sec)');
ylabel('Signal Amplitude');
title('Convolution of x1 and x2');

%% 2.4-19
t = -10:0.001:10;
x = step_func(t)-step_func(t-2);
w = (step_func(t)-step_func(t-1))-(step_func(t-1)-step_func(t-2));
figure%('Name','Lathi 2.4-19','NumberTitle','off');
subplot(2,2,1),plot(t,x);
xlabel('Time (sec)');
ylabel('Signal Amplitude');
title('Step Function');
subplot(2,2,2),plot(t,w);
xlabel('Time (sec)');
ylabel('Signal Amplitude');
title('Step Function');
y=conv(x,w);
y=y.*0.001; %scaling by our incrementing factor for ‘t’
y1=y(10000:30000);
subplot(2,2,[3,4]),plot(t,y1)
xlabel('Time (sec)');
ylabel('Signal Amplitude');
title('Convolution of x and w');

%% Problem 2
t = -10:0.001:10;
x1 = (2.*t+1).*(step_func(t+3)-step_func(t+1));
x2 = (step_func(t+1)-step_func(t))+(step_func(t-1)-step_func(t-2));
figure%('Name', 'Problem 2','NumberTitle','off');
subplot(2,2,1),plot(t,x1);
xlabel('Time (sec)');
ylabel('Signal Amplitude');
title('Step Function');
subplot(2,2,2),plot(t,x2);
xlabel('Time (sec)');
ylabel('Signal Amplitude');
title('Step Function');
y=conv(x1,x2);
y=y.*0.001; %scaling by our incrementing factor for ‘t’
y1=y(10000:30000);
subplot(2,2,[3,4]),plot(t,y1)
xlabel('Time (sec)');
ylabel('Signal Amplitude');
title('Convolution of x1 and x2');