% STARTER: Hill function curves:
u = [0 : 0.01 : 25];  ur = [0 : 1 : 25];  % Input ranges - may need to change
% Parameters, CAN CHANGE:
%kmax1 = 4.0;   ks1 = 7.0;   n1 = 1;    % Params for Rising Hill #1 (CAN CHANGE)
%kmax2 = 4.0;   ks2 = 7.0;   n2 = 2;    % Params for Rising Hill #2 (CAN CHANGE)
kmax1 = 4.0;   ks1 = 7.0;   n1 = 1;    % Params for Rising Hill #1 (CAN CHANGE)
kmax2 = 4.0;   ks2 = 7.0;   n2 = 2;    % Params for Rising Hill #2 (CAN CHANGE)
kmax3 = 4.0;   ks3 = 7.0;   n3 = 4;    % Params for Rising Hill #2 (CAN CHANGE)
%kmax1r = 5.0;  ks1r = 4.0;  n1r = 1;   % Params for Falling Hill #1 (CAN CHANGE)
%kmax2r = 10.0; ks2r = 8.0;  n2r = 4;   % Params for Falling Hill #2 (CAN CHANGE)
% Getting curves (using forms, with "by-coefficient" (non-matrix) operations)
y1 = (kmax1.*(u.^n1))./((ks1.^n1) +(u.^n1));  % rising/"activator"
y2 = (kmax2.*(u.^n2))./((ks2.^n2) +(u.^n2));
y3 = (kmax2.*(u.^n3))./((ks3.^n3) +(u.^n3));
%y1r = (kmax1r.*(ks1r.^n1r))./((ks1r.^n1r) +(ur.^n1r));  % falling/"repressor"
%y2r = (kmax2r.*(ks2r.^n2r))./((ks2r.^n2r) +(ur.^n2r));
% Plots:
figure(1); set(1,'Color',[1 1 1]);
subplot(2,1,1);   plot(u,y1,'b-',u,y2,'g--',u,y3,'r:','LineWidth',1.5); grid MINOR; hold on;
  xlabel('Input','FontWeight','bold'); ylabel('Hill Output','FontWeight','bold');
%subplot(2,1,2);   plot(ur,y1r,ur,y2r,'r:','LineWidth',1.5); grid MINOR; hold on;
%  xlabel('Input','FontWeight','bold'); ylabel('Hill Output','FontWeight','bold');
