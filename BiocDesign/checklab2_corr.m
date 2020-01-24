% checklab_corr.m
%    MATLAB confirmation of C program to calculate the correlation calculation
clear; close all;
x = load('ERP00/ERP0010.txt');
y = load('ERP00/ERP0011.txt');

%x = load('ERP05/ERP05.2.txt');
%y = load('ERP05/ERP05.20.txt');

meanX=mean(x,1);
meanY=mean(y,1);
sumXX=sum(x.^2);
sumYY=sum(y.^2);
sumXY=sum(x.*y);

numer = (sumXY-(500*(meanX*meanY)));
denom = (sqrt((sumXX-(500*meanX*meanX))*(sumYY-(500*meanY*meanY))));
rho=numer/denom;
disp(rho);