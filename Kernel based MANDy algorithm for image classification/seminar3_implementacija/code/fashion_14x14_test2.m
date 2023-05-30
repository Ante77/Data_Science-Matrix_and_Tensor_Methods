% The same procedure as in P1_test2.m, but for MNIST Fashion dataset where
% the images were rescaled to 14x14 resolution by using means of 2x2 groups
% of pixels, as it was done in the original paper

clear all

nesto1 = csvread('fashion-mnist_train.csv', 1, 0);
nesto2 = csvread('fashion-mnist_test.csv', 1, 0);

X_train = double(nesto1(:, 2:end));
X_train = X_train'/255;
y_train = double(nesto1(:, 1));
y_train = y_train';

X_test = double(nesto2(:, 2:end));
X_test = X_test'/255;
y_test = double(nesto2(:, 1));
y_test = y_test';

clear nesto1;
clear nesto2;

X_train_reshaped = reshape(X_train, 28, 28, size(X_train, 2));
X_train_new = zeros(14, 14, size(X_train, 2));

for i = 1:size(X_train_reshaped, 3)
    image = X_train_reshaped(:,:,i);
    new_image = imresize(image, [14 14]);
    X_train_new(:,:,i) = new_image;
end

X_train_new = reshape(X_train_new, [], size(X_train, 2));
X_train = X_train_new;
clear X_train_new

X_test_reshaped = reshape(X_test, 28, 28, size(X_test, 2));
X_test_new = zeros(14, 14, size(X_test, 2));

for i = 1:size(X_test_reshaped, 3)
    image = X_test_reshaped(:,:,i);
    new_image = imresize(image, [14 14]);
    X_test_new(:,:,i) = new_image;
end

X_test_new = reshape(X_test_new, [], size(X_test, 2));
X_test = X_test_new;
clear X_test_new

figure(1)
imagesc(reshape(X_train(:,333),[14,14])');colormap(gray);

m = 5000; 

totalIndices = 60000;
numIndices = m;    

randomIndices = randperm(totalIndices);
randomIndices = randomIndices(1:numIndices);

X_train_new = X_train(:, randomIndices);
y_train_new = y_train(:, randomIndices);

d = 10;

Y = one_hot_encode(y_train_new, d, m);

alpha_values = 0.1:0.1:1.0;


for alpha = alpha_values
    G = zeros(m,m);

    for i = 1:m
        for j = 1:m
            G(i,j) = kernel_f(X_train_new(:,i),X_train_new(:,j),alpha);
        end
    end

    Z = Y/G;

    totalIndices = 10000; 
    numIndices = 10000;   

    randomIndices = randperm(totalIndices);
    randomIndices = randomIndices(1:numIndices);

    X_test_new = X_test(:, randomIndices);
    y_test_new = y_test(:, randomIndices);

    y_preds = zeros(1, numIndices);

    for i = 1:numIndices
        x = X_test_new(:,i);
        rates = f(X_train_new, Z, x, alpha);
        [~, pred] = max(abs(rates));
        y_preds(1,i) = pred-1;
    end

    numCorrect = sum(y_preds == y_test_new);

    accuracy = (numCorrect / numIndices) * 100;

    fprintf('Alpha: %.2f, Accuracy: %.2f%%\n', alpha, accuracy);

    filename = sprintf('results_alpha_%.2f.txt', alpha);
    fid = fopen(filename, 'w');
    fprintf(fid, 'Alpha: %.2f\n', alpha);
    fprintf(fid, 'Accuracy: %.2f%%\n', accuracy);
    fclose(fid);
end