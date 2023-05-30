function A = unfold(T, mod)
    [l, m, n] = size(T);
    
    if mod == 1
        A = zeros(l, m*n);
        J = 1:n:m*n;
        for j = 1:m
            A(:,J(j):J(j)+(n-1)) = T(:,j,:);
        end
    end
    
    if mod == 2
        A = zeros(m, l*n);
        K = 1:l:l*n;
        for k = 1:n
            A(:,K(k):K(k)+(l-1)) = T(:,:,k)';
        end
    end
    
    if mod == 3
        A = zeros(n, m*l);
        I = 1:m:m*l;
        for i = 1:l
            B = squeeze(T(i,:,:));
            A(:,I(i):I(i)+(m-1)) = B';
        end
    end
end