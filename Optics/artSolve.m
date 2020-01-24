function x = artSolve(A,b)
% Solve by random projection method
lambda = 0.000001;
%lambda = 0.1;

A = [real(A);imag(A)];
b = [real(b);imag(b)];
x = zeros(size(A,2),1);

for k=1:100
permInd = randperm(size(A,1));

for i=1:length(permInd)
    
    x = x + lambda * (b(permInd(i)) - sum(A(permInd(i),:).*x')) / sum(A(permInd(i),:).* A(permInd(i),:)) * A(permInd(i),:)';
   % x(x<0) =0;


end
end

