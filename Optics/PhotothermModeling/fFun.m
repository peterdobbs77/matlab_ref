function f = fFun(region,~)
N=2; % number of equations
nr = length(region.x); %length of columns to output
f = zeros(N,nr); %allocate
h = 1;
Ta = 37;
c_blood =1;
% compute source positioned at point (5,4.9)


    
   f(1,:) = 10*exp(- ( (region.x-5).^2/(2*0.1) + (region.y-4.8).^2/(2*0.1)   ) );
   f(2,:) = h*c_blood*Ta;

