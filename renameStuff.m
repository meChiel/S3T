function renameStuff(dirNm)   
if exist('dirNm','var')
    if dirNm~=0
        dirNm = (dirNm);
    else
        dirNm = uigetdir();
    end
else
    dirNm = uigetdir();
end
%
dirctnt = dir(dirNm);

for i=3:length(dirctnt)
   newname = strrep(dirctnt(i).name,'PSD_','PSD_e000');
   if ~strcmp( newname,dirctnt(i).name)
    movefile([dirctnt(i).folder '\' dirctnt(i).name],[dirctnt(i).folder '\' newname])
   end
end