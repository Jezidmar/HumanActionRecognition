fileName = 'P3_2_10A_p02'; %'P3_2_8_p29'
% fileName = 'P2_2_1_p05'; % for snapshots for gesture 1
disp(['Visualizing sequence ' fileName]);

[X,Y,tagset]=load_file(fileName);
T=size(X,1);	% Length of sequence in frames

% Animate sequence

fp = fopen(['../data/sepinst/' fileName '.sep'], 'rt');
S = fscanf(fp, '%d', [2 Inf])';
fclose(fp);
for s = 1:size(S, 1)
    figure;
    h=axes;
    for ti = S(s, 1):S(s, 2)
        cla;
        skel_vis(X,ti,h);
        drawnow;
        pause(1/60);
    end
end

pause(2);
close all;

figure;
h=axes;
for ti=1:T
	skel_vis(X,ti,h);
	drawnow;
	pause(1/60);
    
    if any(Y(ti,:)),
        figure;
        h=axes;
    else
        cla;
    end
end