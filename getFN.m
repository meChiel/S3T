% Get File Name, returns the characters after the \
function [fn, relPath] = getFN(path)
ff=strfind(path,'\');
if length(ff)
    fn = path(ff(end)+1:end);
    relPath=path(1:ff(end));
else
    relPath=[];
    fn=relPath;
end

end