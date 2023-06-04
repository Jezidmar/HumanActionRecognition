



dim1 = 25;
dim2 =25;
dim3 = 25;

Z=zeros(dim1,dim2,dim3);      






df=dir('../data/*.csv');
D_test=[];
T_test=[];
lS=[];
lT=[];



    k=190;
	[X,L,tags]=load_file(strtok(df(indices(k)).name,'.')); 
    file_name=strtok(df(indices(k) ).name,'.');
    fp = fopen(['../data/' file_name '.sep'], 'rt');
    S = fscanf(fp, '%d', [2 Inf])';
    fclose(fp);








    for s=1:8   
        start_frame=S(s,1);
        end_frame=S(s,2);
        originalSample=start_frame:end_frame;
        for i=start_frame:end_frame
            skel=reshape(X(i,:), 4, NUI_SKELETON_POSITION_COUNT);
            Y=skel(1:3,:);
            %prikaz kao sparse tensor-svake slike zasebno
            K_A = mod3d2(Y,dim1,dim2,dim3);
            K_B= mod3dTemp(Z,K_A);
            


            %sada ih kompresiraj
            [K1,K2,K3]=unfold(K_A);

            U1_A=rsvd(K1,10); %dummy entry, nu 2
            U2_A=rsvd(K2,10);
            U3_A=rsvd(K3,10);
    
            %unfold za kockaB

            [D1,D2,D3]=unfold(K_B);

            U1_B=rsvd(D1,10);
            U2_B=rsvd(D2,10);
            U3_B=rsvd(D3,10);
    
   

            S_A = nmodeproduct(nmodeproduct(nmodeproduct(K_A, U1_A', 1),U2_A',2),U3_A',3);
            S_D = nmodeproduct(nmodeproduct(nmodeproduct(K_B, U1_B', 1),U2_B',2),U3_B',3);

        %u zadnjoj liniji smo izracunali jezgre tenzora K i D.

        %sada nam treba MSV ; uzimamo prvih 10 singularnih vrijednosti sigma 
       
        %dimenzije tenzora su x x y x h x f, tj. f framesa.

            a1 = squeeze(sqrt(sum(S_A.^2, [1 2])))' ;
            a2 = squeeze(sqrt(sum(S_D.^2, [1 2])))' ;

            b1 = sqrt(sum(S_A.^2, [2 3]))';
            b2 = sqrt(sum(S_D.^2, [2 3]))';

            c1 = sqrt(sum(S_A.^2, [1 3]));
            c2 = sqrt(sum(S_D.^2, [1 3]));
    
        %uzmi jos prvih 10 elemenata

            a1=a1(1:13);
            a2=a2(1:13);

            b1=b1(1:13);
            b2=b2(1:13);

            c1=c1(1:13);
            c2=c2(1:13);



            %odredi klaster za dati frame

           [~,test_S] = pdist2(codebooKS',[a1, b1, c1],'euclidean','Smallest',1);

            [~,test_T] = pdist2(codebooKT',[a2, b2, c2],'euclidean','Smallest',1);
            
            lS = cat(2, lS, test_S);
            lT = cat(2, lT, test_T);
    end
        Z=zeros(dim1,dim2,dim3); 
        histograms = cell(2, 1);
        histograms{1} = histcounts(lS, K);
        histograms{2} = histcounts(lT, K);
        D_S_test = horzcat(histograms{1});
        D_T_test = horzcat(histograms{2});


    D_test=vertcat(D_test,D_S_test);
    T_test=vertcat(T_test,D_T_test);

    


 end
 



normalized_matrixS_test = bsxfun(@minus, D_test , mean(D_test,2));
normalized_matrixS_test = bsxfun(@rdivide, normalized_matrixS_test, std(normalized_matrixS_test,[],2));

normalized_matrixT_test = bsxfun(@minus, T_test, mean(T_test,2));
normalized_matrixT_test = bsxfun(@rdivide, normalized_matrixT_test, std(normalized_matrixT_test,[],2));


testSpat_ADDED = Ax * D_test';
testTemp_ADDED = Ay * T_test';
%

testZ1_ADDED  = [testSpat_ADDED ; testTemp_ADDED];
testZ2_ADDED  = [testSpat_ADDED + testTemp_ADDED];




New = predict(ModelRF,testZ2_ADDED')
predict(ModelRF,trainZ2(:,190*6:190*6+5)')
output = net(testZ2_ADDED);