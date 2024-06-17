
% Demo 1: Visualize a sequence.
%
% Author: Sebastian Nowozin <Sebastian.Nowozin@microsoft.com>

fileName = 'P1_1_1_p06'; %'P3_2_8_p29'
disp(['Visualizing sequence ' fileName]);

[X,Y,tagset]=load_file(strtok(df(indices(290)).name,'.'));
T=size(X,1);	% Length of sequence in frames
find(sum(Y,2))
% Animate sequence

fp = fopen(['../data/' fileName '.sep'], 'rt');
S = fscanf(fp, '%d', [2 Inf])';
fclose(fp);
    figure;
    h=axes;
    for ti = 1:T
        cla;
        skel_vis(X,ti,h);
        drawnow;
        pause(1/60);
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
