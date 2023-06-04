



[~,~,~,~,C_S,~]=coding(columnVectorA,columnVectorA,200);
codebooKS=C_S'; %codebooS€R^{30x10x8x194}  194 video klipa










%parametrizacija
df=dir('../data/*.csv');



%okej sada znas kako ucitati svaki action sequence.
dim1 = 20;
dim2 = 20;
dim3 = 20;
D=[];

tic;

for k=1:542

	[X,L,tags]=load_file(strtok(df(indices(k)).name,'.')); 
    file_name=strtok(df(indices(k) ).name,'.');

    fp = fopen(['../data/' file_name '.sep'], 'rt');
    S = fscanf(fp, '%d', [2 Inf])';
    fclose(fp);

   
    if(size(S,1)<8)
        continue;
    end
    for s=1:8
        
        lS=[];
        lT=[];
        start_frame=S(s,1);
        end_frame=S(s,2);
     


        for i=start_frame:end_frame
            skel(:,:,i-start_frame+1)=reshape(X(i,:), 4, NUI_SKELETON_POSITION_COUNT);
            %nemamo problem sa normalizacijom. Sve se vrijednosti norm dok se dodje do trazene pozicije
            Y=skel(1:3,:,1:i-start_frame+1);
           

        
            %prikaz kao sparse tensor-svake slike zasebno
            K_A = mod3d2(Y(:,:,i-start_frame+1),dim1,dim2,dim3);
            %K_B =SecDesc(Y,min_x,max_x,min_y,max_y,min_z,max_z,dim1,dim2,dim3,i-start_frame+1);
        


            %sada ih kompresiraj
            [K1,K2,K3]=unfold(K_A);

            U1_A(:,:,i-start_frame+1)=rsvd(K1,size(K1,1)); %dummy entry, nu 2
            U2_A(:,:,i-start_frame+1)=rsvd(K2,size(K2,1));
            U3_A(:,:,i-start_frame+1)=rsvd(K3,size(K3,1));
    
            %unfold za kockaB

           
    
   

            S_A(:,:,:,i-start_frame+1) = nmodeproduct(nmodeproduct(nmodeproduct(K_A, U1_A(:,:,i-start_frame+1)', 1),U2_A(:,:,i-start_frame+1)',2),U3_A(:,:,i-start_frame+1)',3);
          
        %u zadnjoj liniji smo izracunali jezgre tenzora K i D.

        %sada nam treba MSV ; uzimamo prvih 10 singularnih vrijednosti sigma 
       
        %dimenzije tenzora su 10x10x10xf, tj. f framesa.

            a1 = squeeze(sqrt(sum(S_A(:,:,:,i-start_frame+1).^2, [1 2])))' ;
           
           
            %uzmi jos prvih 10 elemenata

            a1=a1(1:10);
            

            %odredi klaster za dati frame

            [~,label_kmean_S1] = pdist2(codebooKS',a1,'euclidean','Smallest',1);
               
            lS = cat(2, lS, [label_kmean_S1]);
            
        end
        histograms = cell(2, 1);
        histograms{1} = histcounts(lS, 200);
        D_S = horzcat(histograms{1});


    D=vertcat(D,D_S);

    


    end
    fprintf('less to go %d',k);
end   %ovo je za razlicite video klipove



% Print the elapsed time
fprintf('Elapsed time: %f seconds\n', toc);

    
%sada provedi DCA na dobivenoj transformaciji.




%[~,~,Spatial,Temporal]=dcaFuse(squeeze(D),squeeze(T), );


save('Feature_version_3TRUE');
%
%Ukljucimo samo prvih 200 video klipova.