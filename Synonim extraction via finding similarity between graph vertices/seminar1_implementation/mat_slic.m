function S = mat_slic(A, B)
    nA = max(size(A));
    nB = max(size(B));
    
    Z0 = ones(nB, nA);
    S = Z0;
    
    for k = 1:50
        M = B*Z0*A' + B'*Z0*A;
        S = M / norm(M, 'fro');
        Z0 = S;
    end
end