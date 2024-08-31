
%data = loadAll()

disp(data(4))

point = data(4);

point.X
point.Y
number_of_sv=10;
df=dir('../data/*.csv');
% maybe it is the best to create function which would take 1 file with
% multiple action sequences and work with it. Or maybe it would be better
% to go over all action sequences.
D=[];
T=[];
lS=[];
lT=[];

Codebook_1_frames = [];
Codebook_2_frames = [];

for k=1:593
    % go over all action sequences
    [X,L,tags]=load_file(strtok(df(indices(k)).name,'.')); 
    file_name=strtok(df(indices(k) ).name,'.');

    fp = fopen(['../data/' file_name '.sep'], 'rt');
    S = fscanf(fp, '%d', [2 Inf])';
    fclose(fp);

    for s=1:size(S,1) % go over all action sequences
        start_frame=S(s,1);
        end_frame=S(s,2);
        originalSample=start_frame:end_frame;
        % now is the interpolating / downsampling to 64 frames
        sample=resample_frames(X(start_frame:end_frame,:));
        % now extract 2 types of features
        feat_1 = extract_temporal_feats(sample); % feats_1 is [a1 b1 c1]
        feat_2 = extract_spatial_feats(sample); % feats_2 is [a2 b2 c2]
        if mod(num_frame, 10) == 0
            Codebook_1_frames=cat(Codebook_1_frames,feat_1)


    end
end
        
            


