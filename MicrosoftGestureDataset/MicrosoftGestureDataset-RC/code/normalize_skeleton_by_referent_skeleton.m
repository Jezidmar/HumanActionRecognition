function normalized_skeleton = normalize_skeleton_by_referent_skeleton(target_skeleton, reference_lengths)
    % MSRC-12 joint connections
    bones = [
        1, 2;   % Hip Center to Spine
        2, 3;   % Spine to Shoulder Center
        3, 4;   % Shoulder Center to Head
        3, 5;   % Shoulder Center to Left Shoulder
        5, 6;   % Left Shoulder to Left Elbow
        6, 7;   % Left Elbow to Left Wrist
        7, 8;   % Left Wrist to Left Hand
        3, 9;   % Shoulder Center to Right Shoulder
        9, 10;  % Right Shoulder to Right Elbow
        10, 11; % Right Elbow to Right Wrist
        11, 12; % Right Wrist to Right Hand
        1, 13;  % Hip Center to Left Hip
        13, 14; % Left Hip to Left Knee
        14, 15; % Left Knee to Left Ankle
        15, 16; % Left Ankle to Left Foot
        1, 17;  % Hip Center to Right Hip
        17, 18; % Right Hip to Right Knee
        18, 19; % Right Knee to Right Ankle
        19, 20  % Right Ankle to Right Foot
    ];
    
    % Initialize the normalized skeleton
    normalized_skeleton = target_skeleton;
    target_lengths = calculate_bone_lengths(target_skeleton);

    % Build adjacency list for bones
    num_joints = size(target_skeleton, 2);
    adj_list = cell(num_joints, 1);
    for i = 1:size(bones, 1)
        start_joint = bones(i, 1);
        end_joint = bones(i, 2);
        adj_list{start_joint} = [adj_list{start_joint}, end_joint];
    end

    % Start scaling from the root joint (Hip Center)
    root_joint = 1; % Assuming joint 1 is the Hip Center
    visited = false(1, num_joints);
    normalized_skeleton = recursive_scale(normalized_skeleton, reference_lengths, target_lengths, bones, adj_list, root_joint, visited);
end

function skeleton = recursive_scale(skeleton, reference_lengths, target_lengths, bones, adj_list, current_joint, visited)
    visited(current_joint) = true;
    child_joints = adj_list{current_joint};

    for child = child_joints
        % Find the bone index
        bone_idx = find((bones(:, 1) == current_joint) & (bones(:, 2) == child));
        if isempty(bone_idx)
            continue;
        end

        % Calculate scaling factor for the bone
        if target_lengths(bone_idx) > 0
            scaling_factor = reference_lengths(bone_idx) / target_lengths(bone_idx);
        else
            scaling_factor = 1;
        end

        % Scale the bone vector while preserving direction
        bone_vector = skeleton(:, child) - skeleton(:, current_joint);
        bone_vector_scaled = scaling_factor * bone_vector;
        skeleton(:, child) = skeleton(:, current_joint) + bone_vector_scaled;

        % Recursively scale child bones
        if ~visited(child)
            skeleton = recursive_scale(skeleton, reference_lengths, target_lengths, bones, adj_list, child, visited);
        end
    end
end
