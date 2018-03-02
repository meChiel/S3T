function project = openPlateProject(filePath)
global defaultDir;
if nargin ==0
    [fn, path] = uigetfile('project.txt', defaultDir);
    filePath = [path fn];
end

dd= strfind(filePath,'\');
path = filePath(1:dd(end));
fid = fopen(filePath);
out = textscan(fid, '%s %s = %s', 'CollectOutput',1,'EmptyValue',NaN);
fclose(fid);
out = out{1};
% TODO check if it not a white line
for i=1:size(out,1)
    project.exp{i}.Stim = out{i,1};
    project.exp{i}.Compound = out{i,2};
    project.exp{i}.dir = [path out{i,3}];
end
end