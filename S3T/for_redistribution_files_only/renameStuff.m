dirNm = uigetdir(dirNm);
dirctnt = dir(dirNm);

for i=3:length(dirctnt)
   newname = strrep(dirctnt(i).name,'txt','csv');
   if ~strcmp( newname,dirctnt(i).name)
   movefile([dirctnt(i).folder '\' dirctnt(i).name],[dirctnt(i).folder '\' newname])
   end
end