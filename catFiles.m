function tt=catFiles()
global dp
if ~exist('dp','var')
   dp='e:';
end
if dp==0, dp='~';end
%
[f, dp]=uigetfile(['*.*'],'Select files to concatenate',dp,'MultiSelect','on');
%
fs= ','; %File separator
tt=[];
fid=fopen([dp f{1}]);
tt=fscanf(fid,'%s');
fclose(fid);
for i=2:length(f)
    fid=fopen([dp f{i}]);
    d=fscanf(fid,'%s');
    fclose(fid);
    tt=[tt fs d];
end

fopen([dp 'cat_' f{1}],'w');
fwrite(fid,tt);
fclose(fid);
end
