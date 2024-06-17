function [sigma_A,sigma_D]=kompresija1(K,D)

for i=1:800

    %For computational purposes, the loading is hardcoded only for first 800 frames

    %prvo unfold. Oznake umjesto Y1,Y2,Y3 imamo K1, K2, K3.

    [K1,K2,K3]=unfold(K);

    U1_A(:,:,i)=rsvd(K1,size(K1,1)); %dummy entry, nu 2
    U2_A(:,:,i)=rsvd(K2,size(K2,1));
    U3_A(:,:,i)=rsvd(K3,size(K3,1));
    
    %unfold za kockaB

    [D1,D2,D3]=unfold(D);

    U1_B(:,:,i)=rsvd(D1,size(D1,1));
    U2_B(:,:,i)=rsvd(D2,size(D2,1));
    U3_B(:,:,i)=rsvd(D3,size(D3,1));
    
   

    S_A(:,:,:,i) = nmodeproduct(nmodeproduct(nmodeproduct(K, U1_A(:,:,i)', 1),U2_A(:,:,i)',2),U3_A(:,:,i)',3);
    S_D(:,:,:,i) = nmodeproduct(nmodeproduct(nmodeproduct(D, U1_B(:,:,i)', 1),U2_B(:,:,i)',2),U3_B(:,:,i)',3);

    %u zadnjoj liniji smo izracunali jezgre tenzora K i D.

    %sada nam treba MSV ; uzimamo prvih 10 singularnih vrijednosti sigma 
       
    %dimenzije tenzora su 10x10x10xf, tj. f framesa.

    a1 = squeeze(sqrt(sum(S_A(:,:,:,i).^2, [1 2])))' ;
    b1 = sqrt(sum(S_A(:,:,:,i).^2, [2 3]))';
    c1 = sqrt(sum(S_A(:,:,:,i).^2, [1 3]));

    a2 = squeeze(sqrt(sum(S_D(:,:,:,i).^2, [1 2])))' ;
    b2 = sqrt(sum(S_D(:,:,:,i).^2, [2 3]))';
    c2 = sqrt(sum(S_D(:,:,:,i).^2, [1 3]));
    
    %uzmi jos prvih 10 elemenata

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
         a=cat(1,a,a1);
         b=cat(1,b,b1);
         c=cat(1,c,c1);
         l=cat(1,l,a2);
         m=cat(1,m,b2);
         n=cat(1,n,c2);
    end
    %samo na kraj lijepimo


end
   sigma_A=[a, b, c];
   sigma_D=[l, m, n];
%f nam predstavlja broj framesa.


