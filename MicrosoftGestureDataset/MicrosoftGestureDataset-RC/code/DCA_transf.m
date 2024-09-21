
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


C = confusionmat(Y_test, str2double(pred) );

accuracy = trace(C) / sum(C(:))