function X_resampled = resample_frames(X, target_frames)
    % X: Input matrix (N x M), where N is the number of frames
    % target_frames: The target number of frames (e.g., 64)
    NUI_SKELETON_POSITION_COUNT = 20;
    [num_frames, num_features] = size(X);
    
    if num_frames == target_frames
        % No need to resample, return the original X
        X_resampled = X;
    elseif num_frames > target_frames
        % Downsample
        % Create an index to select frames
        idx = round(linspace(1, num_frames, target_frames));
        X_resampled = X(idx, :);
    else
        % Upsample
        % Create an index for the original frames
        original_idx = 1:num_frames;
        % Create an index for the target number of frames
        target_idx = linspace(1, num_frames, target_frames);
        % Interpolate to upsample
        X_resampled = interp1(original_idx, X, target_idx);
    end
end