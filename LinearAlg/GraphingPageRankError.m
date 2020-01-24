%shtuff
err09=[0.2086, 0.1314, 0.0756, 0.0489, 0.0282, 0.0179, 0.0105, 0.0066, 0.0039, 0.0024, 0.0014, 8.3066e-04, 4.5826e-04, 2.2361e-04, 1.7321e-04, 0];
err07=[0.0938, 0.0468, 0.0204, 0.0046, 0.0022, 0.0010, 4.6904e-04, 2.0000e-04, 1.4142e-04, 0, 0, 0, 0, 0, 0, 0];
err05=[0.0382, 0.0139, 0.0042, 0.0016, 4.7958e-04, 1.7321e-04, 1.4142e-04, 0, 0, 0, 0, 0, 0, 0, 0, 0];
err03=[0.0115, 0.0025, 5.0990e-04, 1.7321e-04, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; 
err01=[0.0010, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
%w=[1/n,1/n,1/n,1/n,1/n,1/n];
%var=dot(pi_k,initialpi)
%error=var/(norm(pi_k)*norm(initialpi))
%pi_final_k=pi_k;
y=0:15;
x1=log(err09);
x2=log(err07);
x3=log(err05);
x4=log(err03);
x5=log(err01);
figure
%plot(y,x1,y,x2,y,x3,y,x4,y,x5)
%plot(y,err09,y,err07,y,err05,y,err03,y,err01)
% semilogy(y,x1)
hold on
title('Graph of Error || \pi_k - \pi ||')
xlabel('K Value') 
ylabel('Error')
semilogy(y,err09)
semilogy(y,err07)
semilogy(y,err05)
semilogy(y,err03)
semilogy(y,err01)
% semilogy(y,x2)
% semilogy(y,x3)
% semilogy(y,x4)
% semilogy(y,x5)
legend('\alpha = 0.9','\alpha = 0.7','\alpha = 0.5','\alpha = 0.3','\alpha = 0.1')
hold off