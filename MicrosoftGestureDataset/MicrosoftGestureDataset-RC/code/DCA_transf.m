
X_train_S = X_S(trainIdx, :);
X_train_S = zscore(X_train_S);
X_train_T = X_T(trainIdx, :);
X_train_T = zscore(X_train_T);
[p,n] = size(X_train_S);

%X_train_S = X_train_S - mean(X_train_S, 2);
%X_train_S = X_train_S ./ std(X_train_S, 0, 2);

%X_train_T = X_train_T - mean(X_train_T, 2);
%X_train_T = X_train_T ./ std(X_train_T, 0, 2);

[Ax,Ay,Spatial,Temporal]=dcaFuse(X_train_S',X_train_T',Y_train' );



%Projekcija testnih podataka na potprostor konstruiran sa DCA
X_test_S = X_S(testIdx, :);
X_test_S = zscore(X_test_S);
X_test_T = X_T(testIdx, :);
X_test_T = zscore(X_test_T);
%X_test_S = X_test_S - mean(X_test_S, 2);
%X_test_S = X_test_S ./ std(X_test_S, 0, 2);

%X_test_T = X_test_T - mean(X_test_T, 2);
%X_test_T = X_test_T ./ std(X_test_T, 0, 2);
[p1,n1] = size(X_test_S);
X_test_S = Ax * X_test_S';
X_test_T = Ay * X_test_T';
% 

X_train = [Spatial ];
X_test  = [X_test_S ];


ModelRF = TreeBagger(1000,X_train', Y_train,'OOBPred','On');
pred = predict(ModelRF,X_test');
confM = confusionmat(Y_test, str2double(pred) );
num_classes = 12;
total_incorrect=0;
total_correct=0;
for i = 1:num_classes
    total_incorrect=total_incorrect+sum(confM(i,:))-confM(i,i);
    total_correct=total_correct+confM(i,i);
end

Acc_dca=total_correct/(total_incorrect+total_correct)