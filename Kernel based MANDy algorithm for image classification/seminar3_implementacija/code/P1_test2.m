% Let's load the dataset and make sure to scale the images to [0,1] range

clear all

nesto = load('mnist-original.mat');

X_data = double(nesto.data);
X_data = X_data/255;
y_data = double(nesto.label);

X_train = X_data(:,1:60000);
y_train = y_data(:,1:60000);
X_test = X_data(:,60001:70000);
y_test = y_data(:,60001:70000);

clear X_data;
clear y_data;

figure(1)
imagesc(reshape(X_train(:,333),[28,28])');colormap(gray);

% Let's choose the number of training samples and sample them randomly

m = 5000;

totalIndices = 60000; 
numIndices = m;  

randomIndices = randperm(totalIndices);
randomIndices = randomIndices(1:numIndices);

X_train_new = X_train(:, randomIndices);
y_train_new = y_train(:, randomIndices);

d = 10;

% Y should be one-hot-encoded

Y = one_hot_encode(y_train_new, d, m);

% Let's choose parameter space for alpha and test the algorithm for all of
% them... We need to create the Grammian and repeat the algorithm for each.

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