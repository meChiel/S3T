function b=isGreyedOut(tifPath,filter)
b=[];
if ~isempty(filter.greyOut)
    if iscell(tifPath) % multiple
        for j=1:length(tifPath)
            b(i)=singleCheck(tifPath{j},filter);
        end
    else
        b=singleCheck(tifPath,filter);
    end
end
end

function b=singleCheck(tPath,filter)
b=0;
    for i=1:length(filter.greyOut)
        if ~isempty(strfind(tPath,filter.greyOut{i})) %strcmp(tifPath, filter.exclude(i))
            b=1;
        end
    end
end