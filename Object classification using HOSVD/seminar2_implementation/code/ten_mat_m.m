function X = ten_mat_m(T, A, n)
    B = A * unfold(T, n);
    
    [J1, J2, J3] = size(T);
    [I, ~] = size(A);
    
    if n == 1
        X = fold(B, n, I, J2, J3);
    end
    
    if n == 2
        X = fold(B, n, J1, I, J3);
    end
    
    if n == 3
        X = fold(B, n, J1, J2, I);
    end
end