%let's observe train sample
number_of_sv=10;
df=dir('../data/*.csv');
% maybe it is the best to create function which would take 1 file with
% multiple action sequences and work with it. Or maybe it would be better
% to go over all action sequences.
X_S_tryouts=[];
X_T_tryouts=[];
dim1=25;
dim2=25;
dim3=25;
target_frames=64;
K=500;
for k=33:33
    % go over all action sequences
    [X,L,tags]=load_file(strtok(df(k).name,'.')); 
    file_name=strtok(df(k).name,'.');
    fp = fopen(['../data/' file_name '.sep'], 'rt');
    if fp==-1
        continue
    end
    S = fscanf(fp, '%d', [2 Inf])';
    fclose(fp);

    for s=1:size(S,1) % go over all action sequences
        start_frame=S(s,1);
        end_frame=S(s,2);
        % now is the interpolating / downsampling to 64 frames
        sample=resample_frames(X(start_frame:end_frame,:),target_frames);
        %h=axes;
        %cla;
        %for ti=1:64
	    %    skel_vis(sample,ti,h);
	    %    drawnow;
	    %    pause(1/30);
	    %    cla;
        %end
        %cla;
        % now extract 2 types of features
        for i=1:target_frames
            skel=reshape(sample(i,:), 4, NUI_SKELETON_POSITION_COUNT);
            Y=skel(1:3,:);
            K_A = mod3d2(Y,dim1,dim2,dim3);
            % for each representation
            [K1,K2,K3]=unfold(K_A);
            U1_A=rsvd(K1,20); %dummy entry, nu 2
            U2_A=rsvd(K2,20);
            U3_A=rsvd(K3,20);
    
            %
            S_A = nmodeproduct(nmodeproduct(nmodeproduct(K_A, U1_A', 1),U2_A',2),U3_A',3);
            %
            a1 = squeeze(sqrt(sum(S_A.^2, [1 2])))' ;
        
            b1 = sqrt(sum(S_A.^2, [2 3]))';
        
            c1 = sqrt(sum(S_A.^2, [1 3]));
        
            a1=a1;
        
            b1=b1;
        
            c1=c1;
            drawnow;
            length(a1)
            plot(abs(a1))
            pause(1/30);
            cla;
        end
    end
end
%% Start of new section

