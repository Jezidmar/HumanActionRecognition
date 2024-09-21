% select referent skeleton.

df = dir('../data/*.csv');

% Iterate over all files
for k = 1:length(df)
    % Extract the base filename without extension
    file_name = strtok(df(k).name, '.');

    % Load the data (if needed)
    [X, L, tags] = load_file(file_name);  

    % Open the corresponding .sep file
    fp = fopen(['../data/' file_name '.sep'], 'rt');

    S = fscanf(fp, '%d', [2 Inf])';
    fclose(fp);
    disp(file_name)
    disp(L)
    skel=reshape(X(1,:), 4, NUI_SKELETON_POSITION_COUNT);
    Referent_Skeleton=skel(1:3,:);
    break; % I selected first frame of first sample


end