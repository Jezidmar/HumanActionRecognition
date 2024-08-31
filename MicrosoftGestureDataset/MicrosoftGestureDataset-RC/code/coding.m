function [idx1,idx2,C1,C2]=coding(sigma_A,sigma_D,f)
% construct centers for the compression, i.e. codebook
%normalized_data_1 = zeros(size(sigma_A)); % Initialize an empty matrix for the result
%normalized_data_2 = zeros(size(sigma_D));

%for i = 1:size(sigma_A, 1)
    % Reshape the i-th sample (row) into (3, 13)
%    reshaped_sample_1 = reshape(sigma_A(i, :), 13, 3)';
%    reshaped_sample_2 = reshape(sigma_D(i, :), 13, 3)';
    
    % Apply zscore normalization to each of the three (1, 13) vectors independently
%    normalized_sample_1 = zscore(reshaped_sample_1, 0, 2);
%    normalized_sample_2 = zscore(reshaped_sample_2, 0, 2);
    
    % Reshape back to (1, 39) and store in the normalized_data matrix
%    normalized_data_1(i, :) = reshape(normalized_sample_1', 1, 39);
%    normalized_data_2(i, :) = reshape(normalized_sample_2', 1, 39);

%end
%[idx1, C1] = kmedoids(sigma_A, f, 'Replicates', 10);
[idx1, C1] = kmeans(sigma_A, f,'Start', 'plus',MaxIter=5000);
%[idx2, C2] = kmedoids(sigma_D, f, 'Replicates', 10);
[idx2, C2] = kmeans(sigma_D, f,MaxIter=5000);
end
%
