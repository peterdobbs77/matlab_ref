%   Load the 100 VER recordings stored in the ver.mat file.
%   Plot one individual record (#50).
%   Calculate & plot the average and SNR in dB as a function of t.
clear; close all;

load ver.mat;
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

noise = ver(50,:)-avg;
figure; plot(t,noise)

%SNR = snr(ver(50,:),noise);

SNR = 20*log(ver(50,:)/noise);
figure;
plot(t,SNR);   % plot individual record
title("Signal to Noise Ratio");
ylabel("SNR");
xlabel("Time (msec)");