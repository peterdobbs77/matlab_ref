function d = dFun(region,~)



% Now create the output in desired format
N=2; % number of equations
nr = length(region.x); %length of columns to output
d = zeros(2*N,nr); %allocate

rho =1;
cp =1;

% Fill the terms 
d(1,:) = 0;
d(2,:) = 0; 
d(3,:) = 0;
d(4,:) = rho*cp;

