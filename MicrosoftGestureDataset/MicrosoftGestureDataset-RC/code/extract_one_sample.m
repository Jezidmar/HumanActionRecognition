function [D_S,D_T] = extract_one_sample(sample,C_S,C_T,dim1,dim2,dim3,number_of_sv,K,num_frames,Referent_Skeleton)
lS=[];
lT=[];
NUI_SKELETON_POSITION_COUNT = 20;
%num_frames=64;
Z=zeros(dim1,dim2,dim3); 
for i=1:num_frames
    skel=reshape(sample(i,:), 4, NUI_SKELETON_POSITION_COUNT);
    Y=skel(1:3,:);
    K_A = mod3d2(Y,dim1,dim2,dim3);
    %K_A = mod3d2_v2(Y,dim1,dim2,dim3,Referent_Skeleton);
    K_B= mod3dTemp(Z,K_A);
    Z=K_B;
    % for each representation
    [K1,K2,K3]=unfold(K_A);
    [D1,D2,D3]=unfold(K_B);
    U1_A=rsvd(K1,dim1,10); 
    U2_A=rsvd(K2,dim2,10);
    U3_A=rsvd(K3,dim3,10);
    %
    U1_B=rsvd(D1,dim1,10);
    U2_B=rsvd(D2,dim2,10);
    U3_B=rsvd(D3,dim3,10);
    %
    S_A = nmodeproduct(nmodeproduct(nmodeproduct(K_A, U1_A', 1),U2_A',2),U3_A',3);
    S_D = nmodeproduct(nmodeproduct(nmodeproduct(K_B, U1_B', 1),U2_B',2),U3_B',3);
    %
    a1 = squeeze(sqrt(sum(S_A.^2, [1 2])))' ;
    a2 = squeeze(sqrt(sum(S_D.^2, [1 2])))' ;

    b1 = sqrt(sum(S_A.^2, [2 3]))';
    b2 = sqrt(sum(S_D.^2, [2 3]))';

    c1 = sqrt(sum(S_A.^2, [1 3]));
    c2 = sqrt(sum(S_D.^2, [1 3]));

    % Normalize before kmeans

    %

    a1=a1(1:number_of_sv);
    a2=a2(1:number_of_sv);

    b1=b1(1:number_of_sv);
    b2=b2(1:number_of_sv);

    c1=c1(1:number_of_sv);
    c2=c2(1:number_of_sv);
    % perform data normalization here. This is first attempt...in second
    % attempt normalize each vector separately.
    %point_S = [zscore(a1), zscore(b1), zscore(c1)];
    %point_T = [zscore(a2), zscore(b2), zscore(c2)];
    point_S = [a1,b1,c1]/norm([a1, b1, c1]);
    point_T = [a2,b2,c2]/norm([a2, b2, c2]);
    [~,label_kmean_S] = pdist2(C_S,point_S,'euclidean','Smallest',1);
    [~,label_kmean_T] = pdist2(C_T,point_T,'euclidean','Smallest',1);
    lS = cat(2, lS, label_kmean_S);
    lT = cat(2, lT, label_kmean_T);

end

histograms = cell(2, 1);
histograms{1} = accumarray(lS', 1, [K, 1])';
histograms{2} = accumarray(lT', 1, [K, 1])';
D_S = horzcat(histograms{1});
D_T = horzcat(histograms{2});
end