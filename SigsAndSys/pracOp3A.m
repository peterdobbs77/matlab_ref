% Practice Opportunity 3A
%    Peter Dobbs
%    BIEN 3300
%
%
% overhead
clear
close all
%
t = -10:0.001:10;
x1 = step_func(t)-step_func(t-1);
%plot(t,x1)
x2 = step_func(t-2)-step_func(t-3);
%plot(t,x1,t,x2)
a=2;
b=3;

%% Example: y(t) = x(t).^2
y1 = x1.^2;
y2 = x2.^2;
figure
subplot(2,1,1),plot(t,y1,t,y2)
title('Example');
% It is time invariant, since time shift works
y3 = (a.*x1+b.*x2).^2;
y12 = a.*y1+b.*y2;
subplot(2,1,2),plot(t,y3,t,y12)
% It is nonlinear, since plots are different

%% a) y(t) = x(t) + 5
y1 = x1 + 5;
y2 = x2 + 5;
figure
subplot(2,1,1),plot(t,y1,t,y2)
title('y(t) = x(t) + 5');
% time invariant
y3 = (a.*x1+b.*x2) + 5*(a+b);
y12 = a.*y1+b.*y2;
subplot(2,1,2),plot(t,y3,t,y12)
% linear

%% d) y(t) = x(-t-5)
y1 = step_func(-t-5)-step_func((-t-5)-1);
y2 = step_func((-t-5)-2)-step_func((-t-5)-3);
figure
subplot(2,1,1),plot(t,y1,t,y2)
title('y(t) = x(-t-5)');
% time invariant
y3 = a.*(step_func(-t-5)-step_func((-t-5)-1))+b.*(step_func(-t-5)-step_func((-t-5)-1));
y12 = a.*y1+b.*y2;
subplot(2,1,2),plot(t,y3,t,y12)
% nonlinear

%% f) y(t) = x(t), x(t)<=10; 10, x(t)>10
if (x1>10) 
    y1 = 10;
else
    y1 = x1;
end
if (x2>10) 
    y2 = 10;
else
    y2 = x2;
end
figure
subplot(2,1,1),plot(t,y1,t,y2)
title('y(t) = x(t),x(t)<=10;10,x(t)>10');
% time invariant
if (x1>10) 
    y3 = 10;
else
    y3 = a.*x1+b.*x2;
end
y12 = a.*y1+b.*y2;
subplot(2,1,2),plot(t,y3,t,y12)
% linear

%% g) y(t) = x((t/2)-1)
y1 = step_func((t/2)-1)-step_func((t/2)-1-1);
y2 = step_func((t/2)-1-2)-step_func((t/2)-1-3);
figure
subplot(2,1,1),plot(t,y1,t,y2)
title('y(t) = x((t/2)-1)');
% time invariant
y3 = a.*(step_func((t/2)-1)-step_func((t/2)-1-1))+b.*(step_func((t/2)-1)-step_func((t/2)-1-1));
y12 = a.*y1+b.*y2;
subplot(2,1,2),plot(t,y3,t,y12)
% nonlinear