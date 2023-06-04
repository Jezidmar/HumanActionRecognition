%action
broj_scene=0;
df=dir('../data/*.csv');

dim1 = 20;
dim2 = 20;
dim3 = 20;

tic;

for k=1:1

	[X,Ybitan,tags]=load_file(strtok(df(k).name,'.')); 
    
    frames=size(X,1);

    indicesY = find(Ybitan);
    [row, col] = ind2sub(size(Ybitan), indicesY);
    

    %idi po svakom action sequenceu
    for j=1:size(row,1)

    %spremi scene
        for i=1:row(j)
            skel(:,:,i)=reshape(X(i,:), 4, NUI_SKELETON_POSITION_COUNT);
            skel(1,:,i)=normalize(skel(1,:,i) );  
            skel(2,:,i)=normalize(skel(2,:,i) );
            
            skel(3,:,i)=normalize(skel(3,:,i) ); %nemamo problem sa normalizacijom. Sve se vrijednosti norm dok se dodje do trazene pozicije
            
            Y=skel(1:3,:,1:i);

            min_x = min(Y(1,:,:),[],'all');
            max_x = max(Y(1,:,:),[],'all');
            min_y = min(Y(2,:,:),[],'all');
            max_y = max(Y(2,:,:),[],'all');
            min_z = min(Y(3,:,:),[],'all');
            max_z = max(Y(3,:,:),[],'all');

        
             %prikaz kao sparse tensor-svake slike zasebno

            K_A = skeleton3dsparse(Y(:,:,i),min_x,max_x,min_y,max_y,min_z,max_z,dim1,dim2,dim3);
            K_B =SecDesc(Y,min_x,max_x,min_y,max_y,min_z,max_z,dim1,dim2,dim3,i);

             %sada ih kompresiraj
            [K1,K2,K3]=unfold(K_A);

            U1_A(:,:,i)=rsvd(K1,size(K1,1)); %dummy entry, nu 2
            U2_A(:,:,i)=rsvd(K2,size(K2,1));
            U3_A(:,:,i)=rsvd(K3,size(K3,1));
    
            %unfold za kockaB

            [D1,D2,D3]=unfold(K_B);

            U1_B(:,:,i)=rsvd(D1,size(D1,1));
            U2_B(:,:,i)=rsvd(D2,size(D2,1));
            U3_B(:,:,i)=rsvd(D3,size(D3,1));
    
   

            S_A(:,:,:,i) = nmodeproduct(nmodeproduct(nmodeproduct(K_A, U1_A(:,:,i)', 1),U2_A(:,:,i)',2),U3_A(:,:,i)',3);
            S_D(:,:,:,i) = nmodeproduct(nmodeproduct(nmodeproduct(K_B, U1_B(:,:,i)', 1),U2_B(:,:,i)',2),U3_B(:,:,i)',3);

             %u zadnjoj liniji smo izracunali jezgre tenzora K i D.

             %sada nam treba MSV ; uzimamo prvih 10 singularnih vrijednosti sigma 
       
             %dimenzije tenzora su 10x10x10xf, tj. f framesa.

             a1 = squeeze(sqrt(sum(S_A(:,:,:,i).^2, [1 2])))' ;
             b1 = sqrt(sum(S_A(:,:,:,i).^2, [2 3]))';
             c1 = sqrt(sum(S_A(:,:,:,i).^2, [1 3]));

             a2 = squeeze(sqrt(sum(S_D(:,:,:,i).^2, [1 2])))' ;
             b2 = sqrt(sum(S_D(:,:,:,i).^2, [2 3]))';
             c2 = sqrt(sum(S_D(:,:,:,i).^2, [1 3]));
    
             %uzmi prvih 10 elemenata

            a1=a1(1:10);
            a2=a2(1:10);
            b1=b1(1:10);
            c1=c1(1:10);
            b2=b2(1:10);
            c2=c2(1:10);

        %[a1,b1,c1]=MSV(S_A(:,:,:,i),10,10,10);
        %[a2,b2,c2]=MSV(S_D(:,:,:,i),10,10,10);
    

        %samo na kraj lijepimo. Dobijemo 
         if i==1
              a=[a1];
              b=[b1];
              c=[c1];
              l=[a2];
              m=[b2];
              n=[c2];
         else
             a=cat(2,a,a1);
             b=cat(2,b,b1);
             c=cat(2,c,c1);
             l=cat(2,l,a2);
             m=cat(2,m,b2);
             n=cat(2,n,c2);
         end
         %samo na kraj lijepimo
        

    end
    

   sigma_A=[a, b, c];
   sigma_D=[l, m, n];
        

    %dosli smo do prostornih i vremenski reprezentacija.
    
    %ako promatras prvu scenu; napravi dictionary...
    %varijable C_S i C_T oznacavaju centre.
   if j==1 & k==1
        [idx1,idx2,D_S,D_T,C_S,C_T]=coding(sigma_A,sigma_D,row(j));

   else %ako promatras bilo koju iducu scenu, koristi isti dictionary.

        [~,idx1_test] = pdist2(C_S,sigma_A','euclidean','Smallest',1);
        [~,idx2_test] = pdist2(C_T,sigma_D','euclidean','Smallest',1);
        histograms = cell(2, 1);
        histograms{1} = histcounts(idx1_test, row(j));
        histograms{2} = histcounts(idx2_test, row(j));
        D_S = horzcat(histograms{1});
        D_T = horzcat(histograms{2});

   end
    broj_scene=broj_scene+1
    %spremi histogram za j-tu scenu.
    Daction(:,:,broj_scene)=D_S;

    Taction(:,:,broj_scene)=D_T;
    


    end

    %mozemo na iduci video
end

toc;



save('action');