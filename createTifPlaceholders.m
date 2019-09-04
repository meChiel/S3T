function createTifPlaceholders(mdir)
global defaultDir;
if nargin<1
    if defaultDir~=0
        mdir = uigetdir('defaultDir');
    else
        mdir = uigetdir();
    end
end
kk=dir([mdir '\*.tif_mask.png']);
for  i=1:length(kk)
    ntn = kk(i).name(1:end-length('_mask.png')); %New tif name
    if ~exist([kk(i).folder '\' ntn],'file')
        copyfile('tifPlaceholder.otif',  [kk(i).folder '\' ntn]);
        disp([kk(i).folder '\' ntn ' created.']);
    else
        disp([kk(i).folder '\' ntn ' already exists.']);
    end
end
end