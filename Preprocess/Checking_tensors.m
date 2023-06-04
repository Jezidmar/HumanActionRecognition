df=dir('../data/*.csv');
k=2
	[X,L,tags]=load_file(strtok(df(indices(k)).name,'.')); 
    file_name=strtok(df(indices(k) ).name,'.');

    Z=zeros(25,25,25);

    start_frame=125;
    end_frame=145; 
    for i=start_frame:end_frame
            skel(:,:,i-start_frame+1)=reshape(X(i,:), 4, NUI_SKELETON_POSITION_COUNT);
    	    skel=reshape(X(i,:), 4, NUI_SKELETON_POSITION_COUNT);
            Y=skel(1:3,:);
            K_A = mod3d2(Y,25,25,25);
            Z=mod3dTemp(Z,K_A);
    end
 
figure;
isosurface(Z, 0.5);
