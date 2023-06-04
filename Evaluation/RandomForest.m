%RandomForest
ModelRF = TreeBagger(1000,trainZ2', squeeze(trainTar),'OOBPred','On');
pred = predict(ModelRF,testZ2');
confM = confusionmat(squeeze(testTar), str2double(pred) );
num_classes = size(confM, 1);
accRF = zeros(num_classes, 1);
for i = 1:num_classes
    accRF(i) = confM(i,i) / sum(confM(i,:));
end
confusionchart(testTar,str2double(pred) )