function Y = one_hot_encode (labels, n_labels, n_samples)
    
    Y = zeros(n_labels, n_samples);
    for j = 1:n_samples
        Y(labels(j)+1,j) = 1;
    end
    
end