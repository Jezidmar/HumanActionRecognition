df=dir('../data/*.csv');



%okej sada znas kako ucitati svaki action sequence.



tic;

    
	[X,L,tags]=load_file(strtok(df(indices(1)).name,'.')); 
    file_name=strtok(df(indices(1) ).name,'.');

    fp = fopen(['../data/' file_name '.sep'], 'rt');
    S = fscanf(fp, '%d', [2 Inf])';
    fclose(fp);

    Y=[];
    action=find(sum(L,2));
    for s=1:2
        start_frame=S(s,1);
        end_frame=S(s,2);
     
        for i=start_frame:end_frame
            skel(:,:,i-start_frame+1)=reshape(X(i,:), 4, NUI_SKELETON_POSITION_COUNT);
            points=skel(1:3,:,i-start_frame+1);

            %x(s,i-start_frame+1,:)=points(1,:);
            %y(s,i-start_frame+1,:)=points(2,:);
            %z(s,i-start_frame+1,:)=points(3,:);
            if s==1
                Y(i-start_frame+1,:,:)=points(1:3,1:20);
            end

            if s==2
               K(i-start_frame+1,:,:)=points(1:3,1:20);
            end
        
        end

    end


m1 = S(1,2)-S(1,1); % number of moments in time series 1
m2 = S(2,2)-S(2,1); % number of moments in time series 2
n = 20; % number of points
x1 = Y;
x2 = K;


% Pad the shorter time series with extra moments to make the lengths equal
if m1 > m2
    x2 = [x2; zeros(m1-m2, 3, n)];
    m = m1;
else
    x1 = [x1; zeros(m2-m1, 3, n)];
    m = m2;
end

% Compute the Euclidean distances between the points for each moment
dists = zeros(m, n, n);
for i=1:m
    for j=1:n
        for k=1:n
            dists(i, j, k) = norm([x1(i,:,j) x2(i,:,j)] - [x1(i,:,k) x2(i,:,k)]);
        end
    end
end

% Pass the distances to the dtw function
dists = reshape(dists, [m*n, n]);



figure;
isosurface(Z, 0.001)
hold on











