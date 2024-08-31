function [D_S,D_T] = extract_one_sample_window(sample,C_S_window,C_T_window,dim1,dim2,dim3,number_of_sv,K,num_frames,frame_size,hop_length)
lS=[];
lT=[];
NUI_SKELETON_POSITION_COUNT = 20;
window_frame_count=0;
window_feat_1 = zeros(frame_size, 3*number_of_sv);
window_feat_2 = zeros(frame_size, 3*number_of_sv);
actual_frame_count=0;
%num_frames=64;
Z=zeros(dim1,dim2,dim3); 
for i=1:num_frames
    skel=reshape(sample(i,:), 4, NUI_SKELETON_POSITION_COUNT);
    Y=skel(1:3,:);
    K_A = mod3d2(Y,dim1,dim2,dim3);
    K_B= mod3dTemp(Z,K_A);
    Z=K_B;
    % for each representation
    [K1,K2,K3]=unfold(K_A);
    [D1,D2,D3]=unfold(K_B);
    U1_A=rsvd(K1,dim1);
    U2_A=rsvd(K2,dim2);
    U3_A=rsvd(K3,dim3);
    %
    U1_B=rsvd(D1,dim1);
    U2_B=rsvd(D2,dim2);
    U3_B=rsvd(D3,dim3);
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
    

    feat_1 = [a1,b1,c1];
    feat_2 = [a2,b2,c2];

    window_frame_count = window_frame_count + 1;
    window_feat_1(window_frame_count, :) = feat_1;
    window_feat_2(window_frame_count, :) = feat_2;

    if window_frame_count == frame_size
        actual_frame_count = actual_frame_count + 1;
        point_S = reshape(window_feat_1', 1, []);
        point_T = reshape(window_feat_2', 1, []);
        [~,label_kmean_S] = pdist2(C_S_window,point_S,'euclidean','Smallest',1);
        [~,label_kmean_T] = pdist2(C_T_window,point_T,'euclidean','Smallest',1);
        lS = cat(2, lS, label_kmean_S);
        lT = cat(2, lT, label_kmean_T);
        if hop_length < frame_size
            window_feat_1(1:frame_size-hop_length, :) = window_feat_1(hop_length+1:end, :);
            window_feat_2(1:frame_size-hop_length, :) = window_feat_2(hop_length+1:end, :);
            window_frame_count = frame_size - hop_length;
        else
            window_frame_count = 0;
        end
    end
    
end

histograms = cell(2, 1);
histograms{1} = histcounts(lS, K);
histograms{2} = histcounts(lT, K);
D_S = horzcat(histograms{1});
D_T = horzcat(histograms{2});
end