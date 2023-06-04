%
C = confusionmat(squeeze(testTar), round(output));

% Extract the accuracy of classification per group
num_classes = size(C, 1);
acc = zeros(num_classes, 1);
for i = 1:num_classes
    acc(i) = C(i,i) / sum(C(i,:));
end



confusionchart(testTar,round(output) )
plot( squeeze(output),squeeze(testTar) );

%first_row1 = columnVectorA(1:10,:);
%second_row2 = columnVectorA(11:20,:);
%third_row3 = columnVectorA(21:30,:);

%new_matrixS = horzcat(first_row1,second_row2,third_row3);


%first_row11 = columnVectorB(1:10,:);
%second_row22 = columnVectorB(11:20,:);
%third_row33 = columnVectorB(21:30,:);

%new_matrixT = horzcat(first_row11,second_row22,third_row33);



%[idx1,idx2,D_S,D_T,C_S,C_T]=coding(new_matrixS,new_matrixT,4000);
%codebooKS=C_S'; %codebooS€R^{30x10x8x194}  194 video klipa

%codebooKT=C_T'; %codebooT€R^{30x3x8x194}  194 video klipa

%save('output');