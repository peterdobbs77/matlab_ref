clear
close all

N=10;
x=(0:N-1)';
p = poisspdf(x,2);

figure
plot(x,p,'o')

q = ones(N,1)/N;
c = max(p./q);

hold on;
plot(x,c*q,'+')

n=10; nn=100;
X=zeros(n,1);
count=0; Y=zeros(n,1);
%R=p./(c*q)
for j=1:nn
    U1=rand(1,1);
    Y(j,1)=round((N-1)*U1)+1;
    U2=rand(1,1);
    if (U2<=p(Y(j,1),1)/(c*q(Y(j,1),1)))
        count=count+1;
        X(count,1)=Y(j,1);
    end
    if (count==n)
        return;
    end
end