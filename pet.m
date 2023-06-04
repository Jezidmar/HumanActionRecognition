%parametrizacija
df=dir('../data/*.csv');



%okej sada znas kako ucitati svaki action sequence.
dim1 = 25;
dim2 =25;
dim3 = 25;
U1_A=[];
U2_A=[];
U3_A=[];
S_A=[];
Z=zeros(dim1,dim2,dim3);      
tic;

for k=1:541 %idi po svih 542 videa
    
	[X,L,tags]=load_file(strtok(df(indices(k)).name,'.')); 
    file_name=strtok(df(indices(k) ).name,'.');

    fp = fopen(['../data/' file_name '.sep'], 'rt');
    S = fscanf(fp, '%d', [2 Inf])';
    fclose(fp);

    
    if(size(S,1)<8)
        continue;
    end
    for s=1:6   %koristi samo prvih 8 action sequencea
     start_frame=S(s,1);
     end_frame=S(s,2);
     
     originalSample=start_frame:end_frame;

    for i=start_frame:end_frame
            skel(:,:,i-start_frame+1)=reshape(X(i,:), 4, NUI_SKELETON_POSITION_COUNT);
            Y=skel(1:3,:,1:i-start_frame+1);

        
            %prikaz kao sparse tensor-svake slike zasebno
            K_A = mod3d2(Y(:,:,i-start_frame+1),dim1,dim2,dim3);
            K_B= mod3dTemp(Z,K_A);
            


            %sada ih kompresiraj
            [K1,K2,K3]=unfold(K_A);

            U1_A(:,:,i-start_frame+1)=rsvd(K1,10); %dummy entry, nu 2
            U2_A(:,:,i-start_frame+1)=rsvd(K2,10);
            U3_A(:,:,i-start_frame+1)=rsvd(K3,10);
    
            %unfold za kockaB

            [D1,D2,D3]=unfold(K_B);

            U1_B(:,:,i-start_frame+1)=rsvd(D1,10);
            U2_B(:,:,i-start_frame+1)=rsvd(D2,10);
            U3_B(:,:,i-start_frame+1)=rsvd(D3,10);
    
   

            S_A(:,:,:,i-start_frame+1) = nmodeproduct(nmodeproduct(nmodeproduct(K_A, U1_A(:,:,i-start_frame+1)', 1),U2_A(:,:,i-start_frame+1)',2),U3_A(:,:,i-start_frame+1)',3);
            S_D(:,:,:,i-start_frame+1) = nmodeproduct(nmodeproduct(nmodeproduct(K_B, U1_B(:,:,i-start_frame+1)', 1),U2_B(:,:,i-start_frame+1)',2),U3_B(:,:,i-start_frame+1)',3);

        %u zadnjoj liniji smo izracunali jezgre tenzora K i D.

        %sada nam treba MSV ; uzimamo prvih 10 singularnih vrijednosti sigma 
       
        %dimenzije tenzora su x x y x h x f, tj. f framesa.

            a1 = squeeze(sqrt(sum(S_A(:,:,:,i-start_frame+1).^2, [1 2])))' ;
            a2 = squeeze(sqrt(sum(S_D(:,:,:,i-start_frame+1).^2, [1 2])))' ;

            b1 = sqrt(sum(S_A(:,:,:,i-start_frame+1).^2, [2 3]))';
            b2 = sqrt(sum(S_D(:,:,:,i-start_frame+1).^2, [2 3]))';

            c1 = sqrt(sum(S_A(:,:,:,i-start_frame+1).^2, [1 3]));
            c2 = sqrt(sum(S_D(:,:,:,i-start_frame+1).^2, [1 3]));
    
        %uzmi jos prvih 10 elemenata

            a1=a1(1:13);
            a2=a2(1:13);

            b1=b1(1:13);
            b2=b2(1:13);

            c1=c1(1:13);
            c2=c2(1:13);


    
%disp(['l = ' num2str(l) ', i = ' num2str(i)]);
            %samo na kraj lijepimo. Dobijemo 
        if s==1 && k==1
            columnVectorA = horzcat(a1, b1, c1)';
            columnVectorB = horzcat(a2, b2, c2)';

        %disp('Prosao si ovdje');
        end
    
        if i>1 || s>1
            columnVectorA = vertcat(columnVectorA', horzcat(a1, b1, c1))';
            columnVectorB = vertcat(columnVectorB', horzcat(a2, b2, c2))';
             % disp('Prosao si ovdje2');
        end

end
  Z=zeros(dim1,dim2,dim3);          
    end
    fprintf('less to go %d',k);
end

fprintf('Elapsed time: %f seconds\n', toc);

    

            

   

    



save('CodewordsTRUEpet');
