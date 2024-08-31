
% config for Neural net
net = feedforwardnet([10 ]);
net.layers{2}.transferFcn='softmax';
net.trainParam.lr = 0.001;
net.trainParam.epochs = 10000;
net.trainFcn = 'trainscg';
net.performFcn = 'crossentropy';
net.trainParam.goal = 1e-6;
net.outputs{end}.processFcns={};
net.layers{1}.transferFcn = 'logsig';
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
% Classify the inputs and get the predicted class labels
% Convert the one-hot encoded output back to class labels
predicted_labels = predicted_labels';  % Transpose to match Y_test
% Display confusion matrix
confusionchart(Y_test, predicted_labels);
confM = confusionmat(Y_test, predicted_labels );
num_classes = 12;

total_incorrect=0;
total_correct=0;
for i = 1:num_classes
    total_incorrect=total_incorrect+sum(confM(i,:))-confM(i,i);
    total_correct=total_correct+confM(i,i);
end

Acc_nn=total_correct/(total_incorrect+total_correct)