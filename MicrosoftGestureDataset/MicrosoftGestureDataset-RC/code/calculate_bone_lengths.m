function bone_lengths = calculate_bone_lengths(skeleton)
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
    
    bone_lengths = zeros(size(bones, 1), 1);
    for i = 1:size(bones, 1)
        start_joint = bones(i, 1);
        end_joint = bones(i, 2);
        bone_vector = skeleton(:, end_joint) - skeleton(:, start_joint);
        bone_lengths(i) = norm(bone_vector);
    end
end