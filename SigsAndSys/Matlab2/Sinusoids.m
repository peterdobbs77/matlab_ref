% Matlab 2 Examples
%    Sinusoids
%        a)
            A = 10;
            f = 30;
            phi = 0;
            t = -10:0.01:10;
            s = A*cos(f*(2*pi*t));
            plot(t,s)