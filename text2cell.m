function preCommandCellArray = text2cell(preCommand)
% Convert text array to multiline cell Array
ss=strfind(preCommand,'ENTER');
if isempty(ss) %no ENTER found
    ss=[ss length(preCommand)];
else
    if ss(end)~=length(ss)
        ss=[ss length(preCommand)+1];
    end
end

preCommandCellArray{1}=preCommand(1:ss(1)-1);
for ii=1:(length(ss)-1)
    preCommandCellArray{ii+1}=preCommand(ss(ii)+5:ss(ii+1)-1);
end
preCommandCellArray{ii+1}=preCommand(ss(ii+1):end);
end