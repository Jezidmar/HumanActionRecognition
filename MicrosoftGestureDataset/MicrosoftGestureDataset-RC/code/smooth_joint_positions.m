function smoothed_joints = smooth_joint_positions(joint_positions, window_size, sigma)
    % smooth_joint_positions applies Gaussian WMA smoothing to joint positions
    %
    % Parameters:
    % - joint_positions: a 3D array of size (num_frames, num_joints, 3)
    % - window_size: the size of the moving window (must be odd)
    % - sigma: standard deviation of the Gaussian kernel
    %
    % Returns:
    % - smoothed_joints: the smoothed joint positions

    [num_frames, num_joints, num_coords] = size(joint_positions);
    smoothed_joints = zeros(size(joint_positions));
    
    % Ensure window_size is odd
    if mod(window_size, 2) == 0
        error('window_size must be odd');
    end
    
    % Create Gaussian kernel
    half_window = floor(window_size / 2);
    t = -half_window:half_window;
    gaussian_kernel = exp(-(t.^2) / (2 * sigma^2));
    gaussian_kernel = gaussian_kernel / sum(gaussian_kernel);  % Normalize kernel

    % Apply the Gaussian WMA to each joint coordinate over time
    for joint = 1:num_joints
        for coord = 1:num_coords  % x, y, z coordinates
            % Extract the time series for this joint and coordinate
            joint_coord_series = joint_positions(:, joint, coord);
            
            % Pad the series at the boundaries to handle edge effects
            padded_series = padarray(joint_coord_series, half_window, 'replicate', 'both');
            
            % Convolve the series with the Gaussian kernel
            smoothed_series = conv(padded_series, gaussian_kernel, 'valid');
            
            % Store the smoothed series
            smoothed_joints(:, joint, coord) = smoothed_series;
        end
    end
end
