% hw2_prob7: from assignment 1 (12, and find the determinate of both matrices)
clear; close all;
%% problem 7
A = [3 -3 1; 0 0 1; -2 2 -1];
invA = inv(A);
disp(invA);
I = invA*A;
disp(I);

%% problem 15
clear;
A = [-1 1 0 -1; -1 1 -1 0; -1 0 0 0; -2 1 -1 1];
invA = inv(A);
disp(invA);
I = invA*A;
disp(I);