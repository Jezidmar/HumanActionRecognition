function sparseTensor = mod3d2(joints, dim1, dim2, dim3)
% Initialize sparse tensor
sparseTensor = zeros(dim1, dim2, dim3);

% Step 1: Center the skeleton
hip_center = joints(:, 1);  % NUI_SKELETON_POSITION_HIP_CENTER
centered_joints = joints - hip_center;
% Step 2: Scale based on spine length
spine_length = norm(centered_joints(:, 3) - centered_joints(:, 1));  % Shoulder center to hip center
normalized_joints = centered_joints / spine_length;


vector_hip_to_shoulder_center=centered_joints(:, 3) - centered_joints(:, 1);
vector_hip_to_shoulder_center=vector_hip_to_shoulder_center/norm(vector_hip_to_shoulder_center);
% Step 3: Make joints rotation invariant 
% If we suppose we want to align to Z axis
target_vector = [0, 0, 1];
% If we suppose we want to align to X axis
%target_vector = [1,0,0];

% left hip to right hip vector
%vector_left_hip_to_right_hip=normalized_joints(:,17)-normalized_joints(:,13);
%vector_left_hip_to_right_hip=vector_left_hip_to_right_hip/norm(vector_left_hip_to_right_hip);
rotation_matrix = computeRotationMatrix(vector_hip_to_shoulder_center, target_vector);
%rotation_matrix = computeRotationMatrix(vector_left_hip_to_right_hip, target_vector);
normalized_joints = (rotation_matrix * normalized_joints);
% Step 4: Scale to fit tensor dimensions
scale = min([dim1, dim2, dim3]) / 3;  % Use 1/3 of the smallest dimension to ensure fit
scaled_joints = normalized_joints * scale + [dim1/2; dim2/2; dim3/2];

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