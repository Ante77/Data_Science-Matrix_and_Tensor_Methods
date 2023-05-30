function y = f (X, Z, x, alpha)

    D = zeros(size(Z,2),1);  
    for i = 1:size(Z,2)
        D(i) = kernel_f(X(:,i),x,alpha);
    end
    y = Z*D;
    
end