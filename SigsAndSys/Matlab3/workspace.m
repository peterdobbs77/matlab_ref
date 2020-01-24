


%needs work
%x6000 = inline('t.^(2.*((t>=-2)&(t<0)))+(cos(2*pi.*t).*((t>=0)&(t<4)))+(2.*((t>=4)&(t<5))','t');

load('aflut.txt');
plot(aflut)

afsq = af.^2;
powaf = sum(afsq(714:817);
