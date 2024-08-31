
%ekstraktiraj gesture broj:

str = tags(1).tagname;

% Extract the substring 'G1'
substr = extractBefore(str, ' ');

% Convert the substring to a numeric value
num = str2double(substr(2:end));