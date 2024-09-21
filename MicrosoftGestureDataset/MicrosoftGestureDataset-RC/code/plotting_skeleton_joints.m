% let's plot problematic skeletons from subject 2!

df = dir('../data/*.csv');
total_number_of_frames = 0;
Example_for_2 = []; % Assuming subject IDs range from 1 to 30
Example_for_2_S = [];
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

    % Display progress
    disp('Sample:');
    disp(k);

    % Extract subject ID from filename
    subject_id = getSubjectID(file_name);
    if subject_id==2
        %Example_for_2=X;
        disp(file_name)
        %Example_for_2_S = S;
        %skel=reshape(X(frame,:), 4, NUI_SKELETON_POSITION_COUNT);
        %Y=skel(1:3,:);
        break;
    end

end

% Plot skeleton
figure;
plot3(Y(1, :), Y(2, :), Y(3, :), 'o-');
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Preprocessed Skeleton');
axis equal;
grid on;