
%data = loadAll()
K=64;
dim1=13;
dim2=13;
dim3=13;
num_frame=1;
Z=zeros(dim1,dim2,dim3); 
number_of_sv=10;
df=dir('../data/*.csv');

actual_frame_count=0;

Codebook_1_frames_20 = zeros(5311540,30);
Codebook_2_frames_20 = zeros(5311540,30);
frame_count=1;
for k=1:593
    % go over all action sequences
    [X,L,tags]=load_file(strtok(df(k).name,'.')); 
    file_name=strtok(df(k).name,'.');
    fp = fopen(['../data/' file_name '.sep'], 'rt');
    if fp==-1
        disp('Sample:');
        disp(file_name)
        continue
    end
    S = fscanf(fp, '%d', [2 Inf])';
    fclose(fp);
    disp('Sample:');
    disp(k);
    for s=1:size(S,1) % go over all action sequences
        start_frame=S(s,1);
        end_frame=S(s,2);
        originalSample=start_frame:end_frame;
        
        %X(originalSample,:)=normalizeSequenceZscore(X(originalSample,:));
        



        for frame=start_frame:end_frame
            skel=reshape(X(frame,:), 4, NUI_SKELETON_POSITION_COUNT);
            Y=skel(1:3,:);
            K_A = mod3d2(Y,dim1,dim2,dim3);
            %disp(size(K_A))
            %K_A = mod3d2_v2(Y,dim1,dim2,dim3,Referent_Skeleton);
            %disp(size(K_A))
            K_B= mod3dTemp(Z,K_A);
            Z=K_B;
            % for each representation
            [K1,K2,K3]=unfold(K_A);
            [D1,D2,D3]=unfold(K_B);
            U1_A=rsvd(K1,dim1,10); %dummy entry, nu 2
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
            


            
            a1=a1(1:number_of_sv);
            a2=a2(1:number_of_sv);

            b1=b1(1:number_of_sv);
            b2=b2(1:number_of_sv);

            c1=c1(1:number_of_sv);
            c2=c2(1:number_of_sv);

            feat_1 = [a1, b1, c1]/norm([a1, b1, c1]);
            feat_2 = [a2, b2, c2]/norm([a2, b2, c2]);
            %
            %feat_1 = [zscore(a1), zscore(b1), zscore(c1)];
            %feat_2 = [zscore(a2), zscore(b2), zscore(c2)];
            Codebook_1_frames_20(actual_frame_count+1,:)=feat_1;
            Codebook_2_frames_20(actual_frame_count+1,:)=feat_2;
            actual_frame_count = actual_frame_count + 1;
        end
        Z=zeros(dim1,dim2,dim3); 


    end
end

Codebook_1_frames_20 = Codebook_1_frames_20(1:actual_frame_count, :);
Codebook_2_frames_20 = Codebook_2_frames_20(1:actual_frame_count, :);            


