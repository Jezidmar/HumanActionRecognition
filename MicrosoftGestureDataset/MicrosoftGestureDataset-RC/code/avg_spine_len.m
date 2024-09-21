% compute average spine length per sample


df=dir('../data/*.csv');
avg_spine_length=0;
spine_length=0;
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
        spine_length=0;
        %compute spine length for each frame separately
        for frame=start_frame:end_frame
            skel=reshape(X(frame,:), 4, NUI_SKELETON_POSITION_COUNT);
            Y=skel(1:3,:);
            %hip_center = Y(:, 1);  % NUI_SKELETON_POSITION_HIP_CENTER
            %centered_joints = Y - hip_center;
            spine_length = spine_length + norm(Y(:, 3) - Y(:, 1));
        end
        avg_spine_length=spine_length/(end_frame-start_frame);
        fprintf('Average spine length for action sequence %d is: %.2f\n',s,avg_spine_length);
        
    end
end