function binaryList = splitMSRC12Dataset(df,testSubjectID)
    % Load all data
    allData = loadAll();

    % Extract subject IDs from file names
    subjectIDs = cellfun(@getSubjectID, {allData.name});
    % Initialize binary list
    binaryList = zeros(size(subjectIDs));

    % Set binary values based on whether subject ID is divisible by 2
    binaryList(subjectIDs == testSubjectID) = 1;
    % now load the set of action sequences and just repeat by the amount of
    % them
    num_repeats=zeros(1,593);
    for k=1:593
        file_name=strtok(df(k).name,'.');
        fp = fopen(['../data/' file_name '.sep'], 'rt');
        if fp==-1
            continue
        end
        S = fscanf(fp, '%d', [2 Inf])';
        fclose(fp);
        num_repeats(k)=size(S,1);
        tf = strcmp( file_name , allData(k).name );
        if tf==0
            disp("Error")
        end
    end
    binaryList = repelem(binaryList, num_repeats);
    disp(sum(binaryList) )

end
function subjectID = getSubjectID(filename)
    % Check if filename is a string or character array
    if ~ischar(filename) && ~isstring(filename)
        error('Filename must be a string or character array');
    end
    
    % Extract subject ID from filename (e.g., 'P3_1_7_p14.csv' or 'P3_1_7_p14.tagstream')
    parts = strsplit(filename, '_');
    if length(parts) < 4
        error('Unexpected filename format');
    end
    lastPart = parts{end};
    % Remove file extension if present
    lastPart = strsplit(lastPart, '.');
    subjectIDStr = lastPart{1}(2:end);  % Remove the 'p' prefix
    subjectID = str2double(subjectIDStr);
    
    if isnan(subjectID)
        error('Unable to extract a valid subject ID from filename');
    end
end
