function c = cFun(region,~)



% Now create the output in desired format
N=2; % number of equations
nr = length(region.x); %length of columns to output
c = zeros(2*N,nr); %allocate


mu_a = 0.02; %cm^-1
mu_sp = 10; %cm^-1
k= 1;% tissue thermal conductivity







% Fill the terms 
c(1,:) = 1/(3* (mu_a +mu_sp));  % Optical Diffusion coefficient;
c(2,:) = 0; 
c(3,:) = 0;
c(4,:) = 1/(3* (mu_a +mu_sp));  % Optical Diffusion coefficient;
c(5,:) = k;
c(6,:) = 0; 
c(7,:) = 0;
c(8,:) = k;