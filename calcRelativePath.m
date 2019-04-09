function [relPath1, relBaseFile, commonBasePath2, dotPath] = calcRelativePath(path1,basePath)
i=1;
while (i<=length(basePath)) && (i<=length(path1))  && path1(i)==basePath(i) 
    i=i+1;
end
i=i-1;
commonBasePath2=basePath(1:i);
BkPlace=strfind(commonBasePath2,'\');
if isempty(BkPlace) %experimental, when drive changes, relative paths = absolute path??
    relPath1=path1;
    commonBasePath2=[];
    f = errordlg('Sorry, but you can''t combine datasets between different drives, must be able to calculate relative paths. Please copy all data to the same drive and try again.', 'Multiple drive Error ', 'modal');
    error('Sorry, but you can''t combine datasets between different drives, must be able to calculate relative paths.      Copy all data to the same drive.', 'Multiple drive Error ', 'modal');
else
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
end
