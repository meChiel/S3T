
%rr= dir('D:\data\Rajiv\**\platelayout_*')
rr= dir('Z:\**\platelayout_*')
%rr= dir('F:\work\UAntwerpen 2019\data\Z\Z\create\_Rajiv_HTS\Galenea\01-03-2019\**\platelayout_*');
%rr= dir('F:\work\UAntwerpen 2019\data\Z\Z\**\platelayout_*');

rname=[];
for i=1:length(rr)
    rname{i}=rr(i).name(length('platelayout_')+1:end-4);
end

%

urname= unique(rname);
for i=1:length(urname)
urname2(i).name=urname{i};
urname2(i).folder=urname{i};
end

urname=sort(urname);

%remove empty entries
urname5=urname;
for i=1:length(urname)
    if isempty(urname{i})
        urname5(i)=[];
    end
end
 urname=urname5;
% figure;
% plot(100,1:length(urname))
% hold on
% plot(0:100,0)
% for i=1:length(urname)
%     disp(urname{i});
%     text(10,1+i,OKname2text(urname{i}),'Interpreter','none');
% end
% axis off

%%
compounds=[];
for i=1:length(urname)
    try
        compounds.(text2OKname(urname{i}))=[];
    catch
        disp(urname{i})
    end
    idx=strcmp(urname{i},rname);
    lid=find(idx==1);
    for j=1:length(lid)
        ff=rr(lid(j)).folder;
        gg=strfind(ff,'\');
        compounds.(text2OKname(urname{i})).(text2OKname((ff(gg(end)+1:end))))=[];
        compounds.(text2OKname(urname{i})).(text2OKname((ff(gg(end)+1:end)))).Data=rr(lid(j)).folder;
    end
end

structViewer2(compounds,'compounds')
