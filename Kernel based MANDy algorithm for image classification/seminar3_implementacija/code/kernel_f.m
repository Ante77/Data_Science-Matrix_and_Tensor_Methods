function y = kernel_f(x1, x2, alpha)

    n = max(size(x1));
    y = 1;
    for i = 1:n
        y = y*cos(alpha*(x1(i)-x2(i)));
    end
    
end