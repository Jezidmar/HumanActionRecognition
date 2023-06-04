original_list = num(indices);
repeated_list = [];


test_indexes = [7,8];
train_indexes = [];
zadnjia=7;
zadnjib=8;
% loop through the sample
for i = 1:203
        test_indexes = [test_indexes, zadnjia+8];
        test_indexes = [test_indexes, zadnjib+8];
        zadnjia=zadnjia+8
        zadnjib=zadnjib+8
end

train_indexes =setdiff(1:1632,test_indexes)




for i = 1:length(original_list)
    repeated_list = [repeated_list, ones(1,8)*original_list(i)];
end


%idemo custom podjelu napravit.
%example
normalized_matrixS = bsxfun(@minus, D , mean(D,2));
normalized_matrixS = bsxfun(@rdivide, normalized_matrixS, std(normalized_matrixS,[],2));

normalized_matrixT = bsxfun(@minus, T, mean(T,2));
normalized_matrixT = bsxfun(@rdivide, normalized_matrixT, std(normalized_matrixT,[],2));


%

trainDataS = normalized_matrixS(train_indexes,:);
testDataS = normalized_matrixS(test_indexes,:);

trainDataT = normalized_matrixT(train_indexes,:);
testDataT = normalized_matrixT(test_indexes,:);



trainTar=repeated_list(train_indexes);
testTar=repeated_list(test_indexes);

[Ax,Ay,Spatial,Temporal]=dcaFuse(trainDataS',trainDataT',repeated_list(train_indexes) );



%Projekcija testnih podataka na potprostor konstruiran sa DCA
 testSpat = Ax * testDataS';
 testTemp = Ay * testDataT';
% 

trainZ1 = [Spatial ; Temporal];
testZ1  = [testSpat ; testTemp];
% 
 trainZ2 = [Spatial + Temporal];
 testZ2  = [testSpat + testTemp];