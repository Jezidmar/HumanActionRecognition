% now, I make use of X_T and X_S
%Labels=extract_labels();
%X_S <- spatial feature set.
%Splits=cell(1, 30);
%for i=1:30
%    Splits{i}=splitMSRC12Dataset(df,i);
%end
%Modalities_for_seq =  strsplit(Modalities_for_seq, '_');
for i=1:30
    binary_split=Splits{i};
    %Modalities_for_seq =  strsplit(Modalities_for_seq, '_');
    %disp(Modalities_for_seq)
    %strcmp(Modalities_for_seq, 'C1')
    %disp(size(binary_split))
    trainIdx = (binary_split == 0 & strcmp(Modalities_for_seq(2:end), 'C5'));  % Logical index array for training data
    testIdx = (binary_split == 1 & strcmp(Modalities_for_seq(2:end), 'C5'));   % Logical index array for testing data
    %testIdx = max(0,trainIdx-1);
    X_train = X_T(trainIdx, :);
    Y_train = Labels(trainIdx, :);
    %disp(size(X_train))
    X_test = X_T(testIdx, :);
    Y_test = Labels(testIdx, :);
    %disp(size(X_test))
    % Define the proportion for the training set
    %trainRatio = 0.95;  % 37% for training, 63% for testing
    %rng(2);
    %c = cvpartition(Labels, 'HoldOut', 1 - trainRatio);
    %trainIdx = training(c);  % Logical array, true for training set
    %testIdx = test(c);       % Logical array, true for test set
    % Split the data
    %X_train = X_S(trainIdx, :);
    %X_train = zscore(X_train);
    %X_train_T = X_T(trainIdx, :);
    %Y_train = Labels(trainIdx, :);
    
    %X_test = X_S(testIdx, :);
    %X_test = zscore(X_test);
    %X_test_T = X_T(testIdx, :);
    %Y_test = Labels(testIdx, :);
    
    
    
    
    %
    ModelRF = TreeBagger(100,X_train, Y_train,'OOBPred','On');
    pred = predict(ModelRF,X_test);
    confusionchart(Y_test, str2double(pred));
    
    C = confusionmat(Y_test, str2double(pred) );
    
    accuracy = trace(C) / sum(C(:));
    
    fprintf('Accuracy for subject %d is: %.2f\n',i,accuracy);
end