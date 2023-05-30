function T = fold(A, mod, l, m, n)
    T = zeros(l, m, n);
    
    if mod == 1
        J = 1:n:m*n;
        for j = 1:m
            T(:,j,:) = A(:,J(j):J(j)+(n-1));
        end
    end
    
    if mod == 2
        K = 1:l:l*n;
        for k = 1:n
           T(:,:,k) = A(:,K(k):K(k)+(l-1))';
        end
    end
    
    if mod == 3
        I = 1:m:m*l;
        for i = 1:l
            T(i,:,:) = A(:,I(i):I(i)+(m-1))';
        end
    end
end