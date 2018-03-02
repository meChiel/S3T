% dirs={ 
%  'E:\data\Rajiv\18-10-2017\NS_2017_2120171018_112944_20171018_113417'
%  'E:\data\Rajiv\18-10-2017\NS_2017_2420171018_115425_20171018_120002'
%  'E:\data\Rajiv\18-10-2017\NS_2017_2520171018_134403_20171018_134802'
%  'E:\data\Rajiv\18-10-2017\NS_2017_2720171018_135057_20171018_135615' 
%  };
%%
for kk=1:length(dirs)
%kk=1;
inputDir=dirs{kk}
%% map mat files:
tiffilenames = dir ([inputDir '\*.tif.mat']);
nWells=length(tiffilenames);
for i=1:nWells
    fname= [inputDir '\' tiffilenames(i).name];
    wellSource{i}=matfile(fname);
end
%% calculate changes:
parfor i=1:nWells
    ch=max(wellSource{i}.frames,[],3)-min(wellSource{i}.frames,[],3);
    change(:,:,i)=ch;
    dch=double(ch);
    mi=mean(wellSource{i}.frames,3);
    meanImage(:,:,i)=mi;
    imwrite(dch/500,[wellSource{i}.Properties.Source     '_change.png'],'Bitdepth',16);
    imwrite(mi/500,[wellSource{i}.Properties.Source     '_mean.png'],'Bitdepth',16); 
    imwrite((dch-min(dch(:)))/(max(dch(:))-min(dch(:))),[wellSource{i}.Properties.Source     '_changeAS.png'],'Bitdepth',16);
    imwrite((mi-min(mi(:)))/(max(mi(:))-min(mi(:))),[wellSource{i}.Properties.Source     '_meanAS.png'],'Bitdepth',16);    
    fig=figure(1); plot(squeeze(mean(mean(wellSource{i}.frames,1),2)));
    saveas(fig,[wellSource{i}.Properties.Source '_averageSignal.png']);
end

end