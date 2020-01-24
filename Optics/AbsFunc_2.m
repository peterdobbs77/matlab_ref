function a = AbsFunc_2(region,~)


N=2; % number of equations
nr = length(region.x); %length of columns to output
a = zeros(2*N,nr); %allocate

omega = 2*pi*1e8;  % in radians/s, for 100 MHz frequency
cl = 3e10/1.34; %speed of light in tissue 
mu_axf = 0.2;
phi = 0.02;
tau = 0.56e-9;
mu_a = 0.02; %cm^-1

a(1,:) = (region.subdomain ==2) * complex(mu_axf+mu_a,omega/cl) + (region.subdomain ==1) * complex(mu_a,omega/cl);
a(2,:) = -(region.subdomain ==2) * mu_axf*phi/complex(1,omega*tau) + (region.subdomain ==1) * complex(0,0);
a(3,:) = 0;
a(4,:) = (region.subdomain ==2) * complex(mu_a,omega/cl) + (region.subdomain ==1) * complex(mu_a,omega/cl);

a = complex(real(a),imag(a)); %this is redundant, but nice to specify