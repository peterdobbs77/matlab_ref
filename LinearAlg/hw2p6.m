% hw2_prob6: from assignment 1 (1,4)
%% problem 1
clear;
disp("assignment 1, problem 1");
syms x y z
eq1 = (-3*x - 2*y + 2*z == -2);
eq2 = (-1*x - 3*y + 1*z == -3);
eq3 = (x    - 2*y + 1*z == -2);

[A,B] = equationsToMatrix([eq1 eq2 eq3],[x y z]);
X = linsolve(A,B);
disp(X);

%% problem 4
clear;
disp("assignment 1, problem 4");
syms a b c
eq1 = (a*(0^2)    + b*0  + c == 0.25);
eq2 = (a*(1^2)    + b*1  + c == -1.75);
eq3 = (a*((-1)^2) + b*-1 + c == 4.25);

[A,B] = equationsToMatrix([eq1 eq2 eq3],[a b c]);
coeff = linsolve(A,B);
disp(coeff);