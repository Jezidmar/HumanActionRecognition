df=dir('../data/*.csv');
for j=1:594
    if j==230
        continue
    end
	[X,Y,tags]=load_file(strtok(df(j).name,'.')); 


    str = tags(1).tagname;

    % Extract the substring 'G1'
    substr = extractBefore(str, ' ');

    % Convert the substring to a numeric value
    num(j) = str2double(substr(2:end));
    

    
    t(j)=size(X,1);
end

indices = find(t > 800 );
%hist(num(indices))

%dakle sve skupa 194 podatka koristis; iz skupa indeksa indices
