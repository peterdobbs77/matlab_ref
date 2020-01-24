function a = AbsFunc_2(region,~)


N=2; % number of equations
nr = length(region.x); %length of columns to output
a = zeros(N,nr); %allocate

omega = 2*pi*1e8;  % in radians/s, for 100 MHz frequency
cl = 3e10/1.34; %speed of light in tissue 
mu_axf = 0.2;
phi = 0.02;
tau = 0.56e-9;

if region.subdomain==2

    a(1,:) = 5;

else 
    a(1,:) = 0.1;

end

a = complex(real(a),omega/cl);