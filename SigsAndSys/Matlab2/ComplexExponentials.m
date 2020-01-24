% Matlab 2 Examples
%    Complex Exponentials
%        a)
            a = -0.07;
            b = -1.5;
            t = 0:0.01:100;
            s = exp((a+b*j)*t);
            plot(t,real(s))
            %hold on; plot(t,imag(s),'m')
            %hold off;
            
            subplot(2,1,1),plot(t,real(s))
            subplot(2,1,2),plot(t,imag(s))
%        b) a =  -0.07;  b = 1.5

%        c) a = 0.07; b = 1.5

%        d) a = -0.07; b = 0;

%        e) a=0; b=-1.5