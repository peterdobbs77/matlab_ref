%Homework 10, #9
a=3;b=1;c=1;d=3;

circ=zeros(2,360);  %a 2x360 zero array
deg=1:1:360;
circ(1,:)=cos(deg*pi/180);
circ(2,:)=sin(deg*pi/180);
A=[a b;c d];

[U, S, V]=svd(A);

hold on %concatenate all subsequent plots on the same graph
axis equal
plot(circ(1,:),circ(2,:),'o')
Acirc=A*circ;
plot(Acirc(1,:),Acirc(2,:),'mo')

Uline=[U(:,1)*S(1,1) [0 0]' U(:,2)*S(2,2)]; %note the prime
plot(Uline(1,:), Uline(2,:),'-c')
hold off