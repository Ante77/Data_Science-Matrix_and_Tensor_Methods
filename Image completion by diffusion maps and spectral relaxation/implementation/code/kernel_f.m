function [rez] = kernel_f (x_i, x_j, sigma)
    rez = exp(-(norm(x_i-x_j)^2)/(sigma^2));
end