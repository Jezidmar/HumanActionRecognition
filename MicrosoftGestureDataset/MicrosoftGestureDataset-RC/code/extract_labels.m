function [Y] = extract_labels()

df=dir('../data/*.csv');
Y=[]
for k=1:593
    % go over all action sequences
    [X,L,tags]=load_file(strtok(df(k).name,'.')); 
    file_name=strtok(df(k).name,'.');
    fp = fopen(['../data/' file_name '.sep'], 'rt');
    L=L;
    if fp==-1
        continue
    end
    S = fscanf(fp, '%d', [2 Inf])';
    fclose(fp);
    [maxValue, linearIndex] = max(L(:));

    % Convert the linear index to row and column indices
    [rowIndex, colIndex] = ind2sub(size(L), linearIndex);

    % Display the column index
    fprintf('The maximum value appears in column %d.\n', colIndex);
    for s=1:size(S,1)
        Y = [Y; colIndex];
    end
end