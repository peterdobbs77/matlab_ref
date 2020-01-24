% Practice Opportunity 1
% Author: Peter Dobbs
clear
% 1) Cartesian to Polar
%    a)
%       i) (1 + 3j)
            [angle,r]=cart2pol(real(1+3j),imag(1+3j));
%      ii) (4 - 3j)
            [angle,r]=cart2pol(real(4-3j),imag(4-3j));
%     iii) (sqrt(2) - sqrt(2)j
            [angle,r]=cart2pol(real(sqrt(2)-sqrt(2)*1i),imag(sqrt(2)-sqrt(2)*1i));
%      iv) (-3)
            [angle,r]=cart2pol(-3,0);
%       v) (3j)
            [angle,r]=cart2pol(0,3);
%    b)
%       i) (3)*exp(j*(pi)/3)
            [real,img]=pol2cart(3,pi/3);
%      ii) (sqrt(2)*exp(-j*(pi)/4))
            [real,img]=pol2cart(sqrt(2),-pi/4);
%     iii) (-2)*angle(pi)
            [real,img]=pol2cart(-2,pi);
%      iv) (-1/3)*angle(pi/4)
            [real,img]=pol2cart(-1/3,pi/4);
% 2)
%    a) (4 + 3j) + (-6 + 2j)
        z = (4+3j)+(-6+2j); 
%    b) (4 + 3j) - (-6 + 2j)
        z = (4+3j)-(-6+2j);
%    c) (4 + 3j) * (-6 + 2j)
        z = (4+3j)*(-6+2j);
%    d) (4 + 3j) / (-6 + 2j)
        z = (4+3j)/(-6+2j);
% 3)
%    a) (sqrt(5)*exp(j*(pi)/4))^2
        z = (sqrt(5)*exp(1i*pi/4))*(sqrt(5)*exp(1i*pi/4));
%    b) (sqrt(2)*exp(j*(pi)/4)) / (sqrt(2)*exp(-j*(pi)/2))
        z = (sqrt(2)*exp(1i*pi/4))*(sqrt(2)*exp(-1i*pi/2));
%    c) (3)*exp(-j*(pi)/4) + (3)*exp(-j*pi)
        z = (3)*exp(-1i*(pi)/4) + (3)*exp(-1i*pi);
%    d) (-2)*exp(j*(pi)/2) - (4)*exp(j*(pi))
        z = (-2)*exp(1i*(pi)/2) - (4)*exp(1i*(pi));
% 4)
        t = 0:0.01:10;
%    a) s(t) = 3*exp(-j*pi*t)
        s1 = 3*exp(-1i*pi*t);
        plot(t,s1)
%    b) s(t) = (5*exp(j*pi/3))*exp(10*j*pi*t)
        s2 = (5*exp(1i*pi/3))*exp(10*1i*pi*t);
        plot(t,s2)
%    c) s(t) = 2*exp(pi/3)*exp(2*j*pi*t)
        s3 = 2*exp(pi/3)*exp(2*1i*pi*t);
        plot(t,s3)
%    d) s(t) = 6*exp(t*pi/3)
        s4 = 6*exp(t*pi/3);
        plot(t,s4)
% B22
%    a) x1 = real(2*exp((-1 + j*2*pi)*t))
        x1 = 2*exp((1i*pi*2-1)*t);
        plot(t,x1)
%    b) x2 = imag(3 - exp((1-j*2*pi)*t))
        x2 = 3-exp((1-1i*2*pi)*t);
%    c) x3 = 3 - imag(exp((1-j*2*pi)*t))
        x3 = exp((1-1i*2*pi)*t);
        subplot(2,1,1),plot(t,imag(x2))
        subplot(2,1,2),plot(t,(3-imag(x3)))
%EOF