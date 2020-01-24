function a = AbsFunc_3(region,~)


% Create an interpolation based on table lookup, 
% First create a grid with 1mm resolution in X and Y direction.
[X,Y] = meshgrid(0:0.1:10,0:0.1:5);

% Define absorption due to fluorophore on this grid. default is zero
% everywhere
mu_axf = zeros(size(X,1),size(X,2));

% Define a 5mm disk of fluorophore labeled region centered at x = 3, y = 3
mu_axf(((X-3).^2+(Y-3).^2) < 0.5^2) = 0.2;


% Other parameters are considered spatially independent
omega = 2*pi*1e8;  % in radians/s, for 100 MHz frequency
cl = 3e10/1.34; %speed of light in tissue 
phi = 0.02;
tau = 0.56e-9;
mu_a = 0.02; %cm^-1


% Now create the output in desired format
N=2; % number of equations
nr = length(region.x); %length of columns to output
a = zeros(2*N,nr); %allocate
mu_axf_interp = interp2(X,Y,mu_axf,region.x,region.y);
% Fill the terms 
a(1,:) = complex( mu_a + mu_axf_interp ,omega/cl);
a(2,:) = - mu_axf_interp*phi/complex(1,omega*tau); 
a(3,:) = 0;
a(4,:) = complex(mu_a+mu_axf_interp,omega/cl);

a = complex(real(a),imag(a));