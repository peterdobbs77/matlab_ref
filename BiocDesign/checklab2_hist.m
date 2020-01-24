% checklab2_hist.m
%   MATLAB confirmation of C program success
clear; close all;
load input.dat
stddev = std(input);
sMean = mean(input);
binWidth=0.4*stddev;
binlimits = (sMean-(2.4*stddev)):binWidth:(sMean+(2.4*stddev));

figure(1);
histogram(input,'BinWidth',0.4*stddev,'BinEdges',binlimits);
title('Histogram of input.dat file');
xlabel('bins');
ylabel('frequency');

%
x = load('xinput.dat');
y = load('yinput.dat');

meanX = mean(x);
meanY = mean(y);

size = length(x);

sum=0;
for i=1:size
    sum = sum + (x(i) * y(i));
end
numerator = sum-(size*meanX*meanY);

sumX=0; sumY=0;
for i=1:size
    sumX=sumX+(x(i).^2);
    sumY=sumY+(y(i).^2);
end
denom = sqrt((sumX-(size*(meanX.^2)))*(sumY-(size*(meanY.^2))));

r = numerator/denom;
disp(r);