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