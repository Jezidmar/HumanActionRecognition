%SVM classifier


Mdl = fitcecoc(trainData, squeeze(trainTar));


%Mdl.ClassNames;

NJ= predict(Mdl,testData);

CSVM = confusionmat(squeeze(testTar), NJ);

% Extract the accuracy of classification per group
num_classes = size(CSVM, 1);
accSVM = zeros(num_classes, 1);
for i = 1:num_classes
    accSVM(i) = CSVM(i,i) / sum(CSVM(i,:));
end


confusionchart(testTar,NJ )