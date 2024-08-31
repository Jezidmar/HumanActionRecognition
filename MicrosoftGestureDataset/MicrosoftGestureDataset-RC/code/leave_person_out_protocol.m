df=dir('../data/*.csv');
Acc=zeros(1,30);
Splits=cell(1, 30);
for i=1:30
    Splits{i}=splitMSRC12Dataset(df,i);
end
for i=1:30
    binary_split=Splits{i};

    %trainIdx = squeeze(binary_split);
    trainIdx = (binary_split == 0);  % Logical index array for training data
    testIdx = (binary_split == 1);   % Logical index array for testing data
    %testIdx = max(0,trainIdx-1);
    X_train = X_T(trainIdx, :);
    Y_train = Labels(trainIdx, :);
    
    X_test = X_T(testIdx, :);
    Y_test = Labels(testIdx, :);
    
    %
    ModelRF = TreeBagger(1000,X_train, Y_train,'OOBPred','On');
    pred = predict(ModelRF,X_test);
    confM = confusionmat(Y_test, str2double(pred) );
    num_classes = 12;
    total_incorrect=0;
    total_correct=0;
    for l = 1:num_classes
        total_incorrect=total_incorrect+sum(confM(l,:))-confM(l,l);
        total_correct=total_correct+confM(l,l);
    end
    
    Acc(i)=total_correct/(total_incorrect+total_correct);
    fprintf('Accuracy for subject %d is: %.2f\n',i,Acc(i));
end
fprintf('Average accuracy across all subjects is %.2f\n', mean(Acc));