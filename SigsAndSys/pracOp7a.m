% Practice Opportunity 7A
% BIEN 3300
% Peter Dobbs
% 16 November 2016
clear
close all

%% 1/(s^2+9)
figure
X = tf([1],[1 0 9]);
step(X);

%% (s+1)/(s^2+2*s+10)
figure
X = tf([1 1],[1 2 10]);
step(X);

%% (s+1)/(s^2+5*s+6)
figure
X = tf([1 1],[1 5 6]);
step(X);

%% (s+1)^2/(s^2-s+1)
figure
X = tf([1 1],[1 -1 1]);
step(X);
