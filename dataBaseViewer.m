global fr currentPath
% Read Filter
disp(' Read Filter')
if ~exist('dfp','var')
    dfp = chooseFilter(pwd);%'D:\my E drive\bckup\testSegV1');
   % dfp='default_Filter.pson';
end
    fid = fopen(dfp, 'r');
    c = fread(fid,inf,'uint8=>char')';
    fclose(fid);
    c2=strrep(c,'\','\\');
    c2=strrep(c2,'£','\'); % for json escape character or json \
    fr=jsondecode(c2); % The filter

    for i=1:length(fr.include)
        rrr{i}=dir(fr.include{i});
    end
    if isempty(rrr{1})
        disp('no files found, make sure HD or network is attached.')
    end
    rr=cat(1,rrr{:}); % Concatenate all dir content in one long list rr;
    
    errr=[];
     for i=1:length(fr.exclude)
       errr{i}=dir(fr.exclude{i});
     end
     if isempty(errr)
         err=[];
     else
         err=cat(1,errr{:}); % Concatenate all dir content in one long list rr;
     end
     
%rr= dir('D:\data\Rajiv\**\platelayout_*')
%rr= dir('Z:\**\platelayout_*')
%rr= dir('F:\work\UAntwerpen 2019\data\Z\Z\create\_Rajiv_HTS\Galenea\01-03-2019\**\platelayout_*');
%rr= dir('F:\work\UAntwerpen 2019\data\Z\Z\**\platelayout_*');

% Remove exclude dirs:
rr2 = rr;
for i=1:length(err)
    for j=length(rr2):-1:1
        if strcmp([rr2(j).folder '\' rr2(j).name] ,[err(i).folder '\' err(i).name])
            rr2(j)=[];
        end
    end
end


%%
rr=rr2;

%%
disp('Extracting compound names');
% Extract compound name:
rname=[];
for i=1:length(rr) 
    rname{i}=rr(i).name(length('platelayout_')+1:end-4);
end


% Find unique names:
urname= unique(rname);
for i=1:length(urname)
    urname2(i).name=urname{i};
    urname2(i).folder=urname{i};
end

% Sort names:
urname=sort(urname);

disp(' Remove empty entries:');
urname5=urname;
for i=1:length(urname)
    if isempty(urname{i})
        urname5(i)=[];
    end
end
 urname=urname5;
 
%%
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
disp('create compound structure')
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


%%
structViewer2(compounds,'compounds');


