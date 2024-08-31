function sample = normalizeSequenceZscore(sample)
NUI_SKELETON_POSITION_COUNT=20;
[num_frames,~]=size(sample);

sequence = zeros(3,20,num_frames);
left_out_sequence = zeros(1,20,num_frames);
for i=1:num_frames
    skel=reshape(sample(i,:), 4, NUI_SKELETON_POSITION_COUNT);
    Y=skel(1:3,:);
    left_out_sequence(:,:,i)= skel(4,:);
    sequence(:,:,i)=Y;
end

for j=1:NUI_SKELETON_POSITION_COUNT
    sequence(:,j,:)=zscore(sequence(:,j,:));
end

skel_remade = zeros(4,20);
for i=1:num_frames
    skel_remade(1:3,:) = sequence(:,:,i);
    skel_remade(4,:) = left_out_sequence(1,:,i);
    sample(i,:) = reshape(skel_remade,1,80); 
end


end