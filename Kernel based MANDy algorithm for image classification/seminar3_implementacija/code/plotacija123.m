figure()

alpha = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0];
accuracy = [85.54, 86.74, 86.55, 85.62, 84.73, 83.47, 82.65, 82.12, 81.67, 80.97];

plot(alpha, accuracy, 'b-o');
xlabel('Alpha');
ylabel('Accuracy (%)');
title('Change in Accuracy with varying Alpha');
grid on;

figure()

training_size = [1000, 2000, 5000, 15000, 30000];
accuracy = [93.77, 95.60, 96.72, 97.82, 98.47];

plot(training_size, accuracy, 'b-o');
xlabel('Training Dataset Size');
ylabel('Accuracy (%)');
title('Change in Accuracy with varying Training Dataset Size (\alpha = 0.2)');
grid on;

figure()

training_size = [1000, 2000, 5000, 15000];
accuracy = [89.73, 91.64, 94.53, 95.99];

plot(training_size, accuracy, 'b-o');
xlabel('Training Dataset Size');
ylabel('Accuracy (%)');
title('Change in Accuracy with varying Training Dataset Size');
grid on;

figure()

alpha = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0];
accuracy = [96.17, 96.72, 96.27, 95.50, 94.41, 94.11, 94.07, 93.84, 93.76, 93.79];

plot(alpha, accuracy, 'b-o');
xlabel('Alpha');
ylabel('Accuracy (%)');
title('Change in Accuracy with varying Alpha');
grid on;

