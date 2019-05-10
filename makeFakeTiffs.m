function makeFakeTiffs(eigdir)
if nargin==0
    eigdir=uigetdir([],'Select the eig subdir:');
end

ff=dir([eigdir '\*eigS1.csv']);

for i=1:length(ff)
bp=strfind(ff(i).name,'_');
fpath=[ff(i).folder(1:end-5) '\' ff(i).name(1:(bp(end)-1))];
copyfile('tifPlaceholder.tif',fpath);
disp(['Generating: ' fpath]);
end