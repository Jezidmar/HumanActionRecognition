
X_train_S = X_S(trainIdx, :);
X_train_S = zscore(X_train_S);
X_train_T = X_T(trainIdx, :);
X_train_T = zscore(X_train_T);
[p,n] = size(X_train_S);

[Ax,Ay,Spatial,Temporal]=dcaFuse(X_train_S',X_train_T',Y_train' );



%Projekcija testnih podataka na potprostor konstruiran sa DCA
X_test_S = X_S(testIdx, :);
X_test_S = zscore(X_test_S);
X_test_T = X_T(testIdx, :);
X_test_T = zscore(X_test_T);
[p1,n1] = size(X_test_S);
X_test_S = Ax * X_test_S';
X_test_T = Ay * X_test_T';
% 

X_train = [Spatial; Temporal ];
X_test  = [X_test_S; X_test_T ];


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