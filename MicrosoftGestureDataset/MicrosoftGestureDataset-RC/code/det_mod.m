% let's try to extract modality type.

%determine_modality('P1_2_10A_p06')
df=dir('../data/*.csv');
Modalities_for_seq = [""];
% Now iterate over all files and find modality for each sequence.

for k=1:593
    % go over all action sequences
    [X,L,tags]=load_file(strtok(df(k).name,'.')); 
    file_name=strtok(df(k).name,'.');
    fp = fopen(['../data/' file_name '.sep'], 'rt');
    if fp==-1
        disp('Sample:');
        disp(file_name)
        continue
    end
    S = fscanf(fp, '%d', [2 Inf])';
    fclose(fp);
    disp('Sample:');
    disp(k);
    mod = determine_modality(file_name);
    for s=1:size(S,1) % go over all action sequences
        Modalities_for_seq =  Modalities_for_seq + "_" + mod;
    end
end