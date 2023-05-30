function s = mat_sk_prod(A, B)
    [m, n] = size(A);
    s = 0;
    
    for i = 1:m
        for j = 1:n
            s = s + A(i,j)*B(i,j);
        end
    end
end