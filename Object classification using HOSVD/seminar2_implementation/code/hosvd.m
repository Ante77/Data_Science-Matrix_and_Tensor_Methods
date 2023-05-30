function [S, U1, U2, U3] = hosvd(A)
    [U1, ~, ~] = svd(unfold(A, 1));
    [U2, ~, ~] = svd(unfold(A, 2));
    [U3, ~, ~] = svd(unfold(A, 3));
    
    S = ten_mat_m(ten_mat_m(ten_mat_m(A, U1', 1), U2', 2), U3', 3);
end