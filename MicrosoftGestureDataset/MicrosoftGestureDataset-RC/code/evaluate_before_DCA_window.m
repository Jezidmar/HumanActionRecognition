%Labels=extract_labels();

trainRatio = 0.37;  % 37% for training, 63% for testing
rng(8);
c = cvpartition(Labels, 'HoldOut', 1 - trainRatio);
trainIdx = training(c);  % Logical array, true for training set
testIdx = test(c);       % Logical array, true for test set

% Split the data
X_train = X_T_window(trainIdx, :); % Modify to X_S_window if you want results for spatial descriptor
Y_train = Labels(trainIdx, :);

X_test = X_T_window(testIdx, :);
Y_test = Labels(testIdx, :);




%
ModelRF = TreeBagger(1000,X_train, Y_train,'OOBPred','On');
pred = predict(ModelRF,X_test);
confM = confusionmat(Y_test, str2double(pred) );
num_classes = 12;
total_incorrect=0;
total_correct=0;
for i = 1:num_classes
    total_incorrect=total_incorrect+sum(confM(i,:))-confM(i,i);
    total_correct=total_correct+confM(i,i);
end

Acc_rf=total_correct/(total_incorrect+total_correct)