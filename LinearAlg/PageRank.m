% PageRank.m
%   Algorithm for determining page rank vector for
%       a 6 page web, defined in project document
%   @author Peter Dobbs
%   created for MATH3100 course project
clear; close all;
n=6;
syms p;
cardP_i=[2;0;3;2;2;1];
a=[0;0;0;0;0;0];
one=[1;1;1;1;1;1];

H = [ 0 , 1 , 1 , 0 , 0 , 0; 
      0 , 0 , 0 , 0 , 0 , 0;
      1 , 1 , 0 , 0 , 1 , 0;
      0 , 0 , 0 , 0 , 1 , 1;
      0 , 0 , 0 , 1 , 0 , 1;
      0 , 0 , 0 , 1 , 0 , 0];
  
for i=1:n
    for j=1:n
        if(H(i,j)==0) 
            continue
        end
        H(i,j)=(H(i,j)/cardP_i(i));
    end
    if(sum(H(i,:))==0)
        a(i)=1/n;
    else
        a(i)=0;
    end
end

p=0.9; %uncomment for question number 2
G = (p*H) + (p*a*one') + (((1-p)/n)*one*one');
%disp(G);

%calculate pi sub k+1 transpose (pi_kp1_T)
pi_0_T=[1/n,1/n,1/n,1/n,1/n,1/n];
pi_kp1_T=pi_0_T;
k_max=15;
for i=0:k_max
    pi_kp1_T = pi_kp1_T*G;
end
pi_k = pi_kp1_T';
disp(pi_k);

err=sqrt(sum((pi_k-pi_0_T).^2));
disp(err(1));
figure(1);
semilogy(err);
%plotm(err)