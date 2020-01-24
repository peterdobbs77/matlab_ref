% Practice Opportunity 7B-8A
% BIEN 3300
% Peter Dobbs
% 30 November 2016
clear
close all

%% 1)
sys0 = tf([sqrt(3)/2 -5*pi],[1 0.2 (pi^2+0.01)]);
figure
bode(sys0)


%% 2)
% H(s) = 1/(s^2+9)
sys1 = tf([1],[1 0 0]);
figure
bode(sys1)

% H(s) = (s+1)/(s^2 + 2s + 10)
sys2 = tf([1 1],[1 2 10]);
bode(sys2)

% H(s) = (s+1)/(s^2 + 5s + 6)
sys3 = tf([1 1],[1 5 6]);
bode(sys3)

% H(s) = (s+1)^2/(s^2 - s + 1)
sys4 = tf([1 1],[1 -1 1]);
bode(sys4)
