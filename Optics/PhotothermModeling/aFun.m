function a = aFun(region,~)


% Create an interpolation based on table lookup, 
% First create a grid with 1mm resolution in X and Y direction.
[X,Y] = meshgrid(0:0.1:10,0:0.1:5);

% Define absorption due to a PT agent on this grid. default is zero
% everywhere
mu_axf = zeros(size(X,1),size(X,2));

% Define a 5mm disk of PT agent labeled region centered at x = 3, y = 3
mu_axf(((X-3).^2+(Y-3).^2) < 2^2) = 2;


% Other parameters are considered spatially independent
mu_a = 0.02; %cm^-1
h = 1;       % perfusion heat transfer coefficient;
c_blood = 1 ;% specific heat capacity of blood


% Now create the output in desired format
N=2; % number of equations
nr = length(region.x); %length of columns to output
a = zeros(2*N,nr); %allocate
mu_axf_interp = interp2(X,Y,mu_axf,region.x,region.y);
% Fill the terms 
a(1,:) =  mu_a + mu_axf_interp;
a(2,:) = -mu_a; 
a(3,:) = 0;
a(4,:) = h*c_blood;




