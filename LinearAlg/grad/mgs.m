function [Q,R] = mgs(A)
    format long;
    [m,n] = size(A);
    V = A;
    R(1:n,1:n) = 0;
    Q(1:m,1:n) = 0;
    for i=1:n
        %r_{ii} = \|v_{i}\|_2
        R(i,i) = norm(V(:,i));
        %q_i = v_i / r_{ii}
        Q(:,i) = V(:,i) / R(i,i);
        for j=i+1:n
            %r_{ij} = q^*_i v_j
            R(i,j) = Q(:,i)' * V(:,j);
            %v_j = v_j - r_{ij}q_i
            V(:,j) = V(:,j) - R(i,j)*Q(:,i);
        end % end of inner for loop
    end % end of outer for loop
end % end of function 'mgs'