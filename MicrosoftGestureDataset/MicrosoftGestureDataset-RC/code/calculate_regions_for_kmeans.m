% Initialize variables
df = dir('../data/*.csv');
total_number_of_frames = 0;
Splits_kmeans_subjects = cell(1, 30);  % Assuming subject IDs range from 1 to 30

% Iterate over all files
for k = 1:length(df)
    % Extract the base filename without extension
    file_name = strtok(df(k).name, '.');

    % Load the data (if needed)
    %[X, L, tags] = load_file(file_name);  % Uncomment if you need to load data

    % Open the corresponding .sep file
    fp = fopen(['../data/' file_name '.sep'], 'rt');
    if fp == -1
        disp('Sample:');
        disp(file_name);
        continue;
    end

    % Read start and end frames of action sequences
    S = fscanf(fp, '%d', [2 Inf])';
    fclose(fp);

    % Display progress
    disp('Sample:');
    disp(k);

    % Extract subject ID from filename
    subject_id = getSubjectID(file_name);

    % Initialize variables for this file
    current_number_of_frames = total_number_of_frames;
    total_number_of_frames_in_all_sequences = 0;

    % Initialize the cell for the subject if it doesn't exist
    if isempty(Splits_kmeans_subjects{subject_id})
        Splits_kmeans_subjects{subject_id} = [];
    end

    % Process each action sequence in the file
    for s = 1:size(S, 1)
        start_frame = S(s, 1);
        end_frame = S(s, 2);

        % Calculate the number of frames in this sequence (inclusive)
        num_frames_in_sequence = end_frame - start_frame + 1;
        total_number_of_frames_in_all_sequences = total_number_of_frames_in_all_sequences + num_frames_in_sequence;
    end

    % Generate frame indices for this file
    frames_indices = current_number_of_frames + (1:total_number_of_frames_in_all_sequences);

    % Update the subject's split with the new frame indices
    Splits_kmeans_subjects{subject_id} = [Splits_kmeans_subjects{subject_id}, frames_indices];

    % Update the total number of frames processed so far
    total_number_of_frames = total_number_of_frames + total_number_of_frames_in_all_sequences;
end
