function [relPath1, relBaseFile, commonBasePath2, dotPath] = calcRelativePath(path1,basePath)
i=1;
while (i<=length(basePath)) && (i<=length(path1))  && path1(i)==basePath(i) 
    i=i+1;
end
i=i-1;
commonBasePath2=basePath(1:i);
BkPlace=strfind(commonBasePath2,'\');
r=BkPlace(end);
commonBasePath3=commonBasePath2(1:r);
rr=commonBasePath2(r+1:end);
relBaseFile=[rr basePath(i+1:end)];
relPath1=[rr path1(i+1:end)];
baseFileDepth=length(strfind(relBaseFile,'\'));
dotPath=[];
for i=1:baseFileDepth
    dotPath=[dotPath '..\'];
end
end
