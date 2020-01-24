function f = SrcFunc_2(region,~)
N=2; % number of equations
nr = length(region.x); %length of columns to output
f = zeros(N,nr); %allocate

% compute source positioned at point (5,4.9)


    
   f(1,:) = exp(- ( (region.x-5).^2/(2*0.01) + (region.y-4.8).^2/(2*0.01)   ) );

f = complex(real(f),imag(f));