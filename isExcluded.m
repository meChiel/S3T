function b=isExcluded(tifPath,filter)
b=[];
if ~isempty(filter.exclude)
if iscell(tifPath) % multiple 
    for j=1:length(tifPath)
        b(i)=singleCheck(tifPath{j},filter);
    end
else
    b=singleCheck(tifPath,filter);
end
else
    b=0;
end
end

function b=singleCheck(tPath,filter)
 b=0;
 disp(tPath)
    for i=1:length(filter.exclude)
        if ~isempty(strfind(tPath,filter.exclude{i})) %strcmp(tifPath, filter.exclude(i))
            b=1;
        end
    end
end