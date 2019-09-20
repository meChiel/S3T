function b=isGreyedOut(tifPath,filter)
b=[];
if ~isempty(filter.greyOut)
    if iscell(tifPath) % check multiple files
        for j=1:length(tifPath)
            b(j)=singleCheck(tifPath{j},filter);
        end
    else % check individual file
        b=singleCheck(tifPath,filter);
    end
end
end

function b=singleCheck(tPath,filter)
b=0;
    for i=1:length(filter.greyOut)
        % Check if the filter contains one
        % of the filtered paths/keywords?
        if ~isempty(strfind(tPath,filter.greyOut{i})) %strcmp(tifPath, filter.exclude(i))
            b=1;
        end
    end
end