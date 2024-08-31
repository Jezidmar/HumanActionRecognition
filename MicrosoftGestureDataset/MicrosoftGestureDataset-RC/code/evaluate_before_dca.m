% now, I make use of X_T and X_S
%Labels=extract_labels();
%X_S <- spatial feature set.

% Define the proportion for the training set
trainRatio = 0.37;  % 37% for training, 63% for testing
rng(8);
c = cvpartition(Labels, 'HoldOut', 1 - trainRatio);
trainIdx = training(c);  % Logical array, true for training set
testIdx = test(c);       % Logical array, true for test set
% Split the data
X_train = X_T(trainIdx, :);
X_train = zscore(X_train);
%X_train_T = X_T(trainIdx, :);
Y_train = Labels(trainIdx, :);

X_test = X_T(testIdx, :);
X_test = zscore(X_test);
%X_test_T = X_T(testIdx, :);
Y_test = Labels(testIdx, :);




%
ModelRF = TreeBagger(1000,X_train, Y_train,'OOBPred','On');
pred = predict(ModelRF,X_test);
confusionchart(Y_test, str2double(pred));
confM = confusionmat(Y_test, str2double(pred) );
num_classes = 12;
total_incorrect=0;
total_correct=0;
for i = 1:num_classes
    total_incorrect=total_incorrect+sum(confM(i,:))-confM(i,i);
    total_correct=total_correct+confM(i,i);
end

Acc_rf=total_correct/(total_incorrect+total_correct)