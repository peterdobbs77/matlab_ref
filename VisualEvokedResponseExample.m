% Example 2.3
%       Find the average response of a number of individual VER (Visual
%       Evoked Response). The responses are stored in a MATLAB file
%       'ver.mat' which contains the matrix 'ver', a simulation of the VER.
%       Also plot one of the individual response.
clear; close all;

load ver.mat        % Get visual evoked response data
fs=1/.005;          % Sample interval = 5 msec
[nu,N]=size(ver);   % Get data matrix size
if nu>N
    ver=ver';       % transpose matrix 
    t=(1:nu)/fs;    % generate time vector
else
    t=(1:N)/fs;     % time vector (if no transpose)
end
figure;
plot(t,ver(50,:));   % plot individual record
title("Typical Individual Response");
ylabel("EEG");
xlabel("Time (msec)");

% Construct and plot the ensemble average
avg = mean(ver);    % calculate ensemble average
figure;
plot(t,avg);        % plot ensemble average other data
title("Average of 100 Individual Response");
ylabel("EEG");
xlabel("Time (msec)");