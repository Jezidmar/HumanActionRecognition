[idx1,idx2,C_S_window,C_T_window]=coding_window(Codebook_1_frames_window,Codebook_2_frames_window,K);
df=dir('../data/*.csv');

X_S_window=[];
X_T_window=[];

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
        % now extract 2 types of features
        [x_S,x_T]=extract_one_sample_window(sample,C_S_window,C_T_window,dim1,dim2,dim3,number_of_sv,K,end_frame-start_frame,frame_size,hop_length);
        X_S_window=vertcat(X_S_window,x_S);
        X_T_window=vertcat(X_T_window,x_T);


    end

end
      