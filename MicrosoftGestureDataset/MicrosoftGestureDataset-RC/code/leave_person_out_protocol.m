df=dir('../data/*.csv');
Acc=zeros(1,30);
rng(0);

net = feedforwardnet([10 ]);
net.layers{2}.transferFcn='softmax';
net.trainParam.lr = 0.001;
net.trainParam.epochs = 10000;
net.trainFcn = 'trainscg';
net.performFcn = 'crossentropy';
net.trainParam.goal = 1e-8;
net.outputs{end}.processFcns={};
%Splits=cell(1, 30);
%for i=1:30
%    Splits{i}=splitMSRC12Dataset(df,i);
%end
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
    num_classes = 12;  % Assuming Y_train contains classes 1, 2, 3, etc.
    classes = 1:num_classes;
    % One-hot encoding of the labels
    Y_train_one_hot = onehotencode(Y_train, 2, "ClassNames", classes);  % Encode along the 2nd dimension
    Y_test_one_hot = onehotencode(Y_test, 2, "ClassNames", classes);    % Encode along the 2nd dimension
    % Ensure the input data is transposed (features as columns)
    % Configure the network for training
    Y_train_one_hot=Y_train_one_hot';
    X_train=X_train';
    X_test=X_test';
    
    net = configure(net, X_train, Y_train_one_hot);
    
    % Train the network
    
    net = train(net, X_train, Y_train_one_hot);
    
    % Predict the output for the test set
    output = net(X_test);
    predicted_labels = vec2ind(output);
    % Convert the one-hot encoded output back to class labels
    predicted_labels = predicted_labels';  % Transpose to match Y_test
    % Display confusion matrix
    C = confusionmat(Y_test, predicted_labels );

    accuracy = trace(C) / sum(C(:));
   
    
    Acc(i)=accuracy;
    fprintf('Accuracy for subject %d is: %.2f\n',i,Acc(i));
end
fprintf('Average accuracy across all subjects is %.2f\n', mean(Acc));