function sparseTensor = mod3d2_v2(joints, dim1, dim2, dim3,referent_skeleton)
% Initialize sparse tensor
sparseTensor = zeros(dim1, dim2, dim3);

% Step 1: Center the skeleton
hip_center = joints(:, 1);  % NUI_SKELETON_POSITION_HIP_CENTER
centered_joints = joints - hip_center;
% Step 2: Scale based on length of referent skeleton
referent_lengths = calculate_bone_lengths(referent_skeleton);

normalized_joints = normalize_skeleton_by_referent_skeleton(centered_joints,referent_lengths);


% Step 3: Make joints rotation invariant 
target_vector = [1,0,0];
% left hip to right hip vector
vector_left_hip_to_right_hip=normalized_joints(:,17)-normalized_joints(:,13);
vector_ground = [vector_left_hip_to_right_hip(1); 0; vector_left_hip_to_right_hip(3)];
vector_ground = vector_ground / norm(vector_ground);
rotation_matrix = computeRotationMatrix(vector_ground, target_vector);
normalized_joints = (rotation_matrix * normalized_joints);
% Step 4: Scale to fit tensor dimensions
% Determine the bounding box of the normalized joints
min_coords = min(normalized_joints, [], 2);
max_coords = max(normalized_joints, [], 2);
range_coords = max_coords - min_coords;

% Compute scaling factors to fit within tensor dimensions
scale_factors = ([dim1; dim2; dim3] - 1) ./ range_coords;
scale = min(scale_factors);

% Apply scaling
scaled_joints = normalized_joints * scale;

% Translate to fit within tensor dimensions
min_coords_scaled = min(scaled_joints, [], 2);
offset = -min_coords_scaled + 1; % Ensure coordinates start at 1
scaled_joints = scaled_joints + offset;

% Step 5: Place joints in tensor
for i = 1:size(scaled_joints, 2)
    x = round(scaled_joints(1, i));
    y = round(scaled_joints(2, i));
    z = round(scaled_joints(3, i));
    
    % Ensure indices are within bounds
    x = max(1, min(x, dim1));
    y = max(1, min(y, dim2));
    z = max(1, min(z, dim3));
    
    sparseTensor(x, y, z) = 1;
end 
end

function R = computeRotationMatrix(v1, v2)
    % Calculate the rotation matrix to align v1 with v2
    v = cross(v1, v2);
    s = norm(v);
    c = dot(v1, v2);

    if s == 0
        R = eye(3);  % No rotation needed
    else
        vx = [0 -v(3) v(2); v(3) 0 -v(1); -v(2) v(1) 0];
        R = eye(3) + vx + vx^2 * ((1 - c) / s^2);
    end
end