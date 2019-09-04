function removeTifPlaceholders(mdir)
global defaultDir;
if nargin<1
    if defaultDir~=0
        mdir = uigetdir('defaultDir');
    else
        mdir = uigetdir();
    end
end
kk = dir ([mdir '\*.tif']);
for i=1:length(kk)
    if kk(i).bytes==10573
        delete([kk(i).folder '\' kk(i).name]);
        disp([kk(i).folder '\' kk(i).name ' deleted.'] );
    else
        disp([kk(i).folder '\' kk(i).name ' is not the right size for placeholder is not deleted.'] );
    end
end
end