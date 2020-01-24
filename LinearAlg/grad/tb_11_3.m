% Trefethen-Bau, 11.3
m=50;n=12;
t=linspace(0,1,m);
A=fliplr(vander(t')); A=A(:,1:n);
b=cos(4*t); b=b';

%% a. Formation and solution of the normal equations, using \textsc{Matlab's} \textbackslash
%disp('normal equations');
R = chol(A'*A);
v = A'*b;
w = R'\v;
x_norm = R\w;
%disp(x_norm);

%% b. QR factorization computed by \texttt{mgs}
%disp('QR factorization (mgs)');
[Q,R] = mgs(A);
v = Q'*b;
x_mgs = R\v;
%disp(x_mgs);

%% d. QR factorization computed by \textsc{Matlab's} \texttt{qr}
%disp('QR factorization (qr)');
[Q,R] = qr(A,0);
v = Q'*b;
x_qr = R\v;
%disp(x_qr);

%% e. \texttt{x = A\textbackslash b} in \textsc{Matlab}
%disp('mldivide');
x_solve=A\b;
%disp(x_solve);

%% f. SVD, using \textsc{Matlab's} \texttt{svd}
%disp('Singular value decomposition (svd)');
[U,S,V] = svd(A,'econ');
v = U'*b;
w = S\v;
x_svd = V*w;
%disp(x_svd);

%% plotting
figure;
scatter(t,b,1); hold on;
y=A*x_norm; plot(t,y); hold on;
y=A*x_mgs; plot(t,y); hold on;
y=A*x_qr; plot(t,y); hold on;
y=A*x_solve; plot(t,y); hold on;
y=A*x_svd; plot(t,y); hold on;
hold off;
legend('b = cos(4t)','Normal Equations','QR (mgs)','QR (qr)','Solve (\\)','SVD (svd)');

%% comparing
fprintf("Normal Equations \t QR (mgs) \t\t\t QR (qr) \t\t\t Solve (\\) \t\t\t SVD (svd) \n");
X = horzcat(x_norm,x_mgs,x_qr,x_solve,x_svd);
format long;
disp(X);