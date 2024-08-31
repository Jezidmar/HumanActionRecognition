K=32;
[idx1,idx2,C_S,C_T]=coding(Codebook_1_frames_20,Codebook_2_frames_20,K);
df=dir('../data/*.csv');
% maybe it is the best to create function which would take 1 file with
% multiple action sequences and work with it. Or maybe it would be better
% to go over all action sequences.
X_S=[];
X_T=[];
%dim1=20;
%dim2=20;
%dim3=20;
for k=1:593
    % go over all action sequences
    [X,L,tags]=load_file(strtok(df(k).name,'.')); 
    file_name=strtok(df(k).name,'.');
    fp = fopen(['../data/' file_name '.sep'], 'rt');
    if fp==-1
        continue
    end
    disp('Sample:');
    disp(k);
    S = fscanf(fp, '%d', [2 Inf])';
    fclose(fp);

    for s=1:size(S,1) % go over all action sequences
        start_frame=S(s,1);
        end_frame=S(s,2);
        % now is the interpolating / downsampling to 64 frames
        %sample=resample_frames(X(start_frame:end_frame,:),target_frames);
        sample=X(start_frame:end_frame,:);
        sample=normalizeSequenceZscore(sample);
        % now extract 2 types of features
        [x_S,x_T]=extract_one_sample(sample,C_S,C_T,dim1,dim2,dim3,number_of_sv,K,end_frame-start_frame);
        X_S=vertcat(X_S,x_S);
        X_T=vertcat(X_T,x_T);


    end

end
        
            

