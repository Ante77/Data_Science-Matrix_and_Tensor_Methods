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

% Choosing the value for parameter alpha and creating Grammian matrix

G = zeros(m,m);
alpha = 0.59;

for i = 1:m
    for j = 1:m
        G(i,j) = kernel_f(X_train_new(:,i),X_train_new(:,j),alpha);
    end
end

d = 10;

% Y should be one-hot-encoded

Y = one_hot_encode(y_train_new, d, m);

Z = Y/G;

figure(2)
imagesc(reshape(X_test(:,1),[28,28])');colormap(gray);

x = X_test(:,1);
y = f(X_train_new,Z,x,alpha);
y
y_test(1)

figure(3)
imagesc(reshape(X_test(:,4001),[28,28])');colormap(gray);

x = X_test(:,4001);
y = f(X_train_new,Z,x,alpha);
y
y_test(4001)

figure(4)
imagesc(reshape(X_test(:,9001),[28,28])');colormap(gray);

x = X_test(:,9001);
y = f(X_train_new,Z,x,alpha);
y
y_test(9001)


% Let's test the algorithm on all testing samples

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

fprintf('Accuracy: %.2f%%\n', accuracy);