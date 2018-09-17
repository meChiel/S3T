% Big data processing, the data is not loadded into RAM but read from the
% _result.mat files.
%inputDir ='E:\data\Rajiv\10-10-2017\NS_20171620171010_160217_20171010_162625';
%inputDir='L:\beerse\all\Public\Exchange\michiel\112017\NS_2017_220171011_133850_20171011_135545';
%inputDir='E:\data\Rajiv\11-10-2017\NS_2017_120171011_132239_20171011_133526'
% dirs={ 
%  %'E:\data\Rajiv\18-10-2017\NS_2017_2120171018_112944_20171018_113417'
%  %'E:\data\Rajiv\18-10-2017\NS_2017_2420171018_115425_20171018_120002'
%  %'E:\data\Rajiv\18-10-2017\NS_2017_2520171018_134403_20171018_134802'
%  %'E:\data\Rajiv\18-10-2017\NS_2017_2720171018_135057_20171018_135615'    
% };

for kk=1:length(dirs)
inputDir=dirs{kk}
%% set dir

if exist('inputDir','var')
    inputDir=inputDir;
else
    inputDir= uigetdir();    
    inputDir = [inputDir '\'];
    %inputPath='L:\beerse\all\Public\Exchange\michiel\Rajiv\NS_20174220170912_143321_20170912_144604 - copy\';
end

%% convert tif to mat files
tiffilenames = dir ([inputDir '\*.tif']);
nWells=length(tiffilenames);
parfor i=1:nWells
   % well{i}=matfile([inputDir '\' tiffilenames(i).name]);
    
    % read the images
    fname=[inputDir '\' tiffilenames(i).name]
info = imfinfo(fname);
num_images = numel(info);
frames=zeros(info(1).Height,info(1).Width,num_images);
for k = 1:num_images
    frames(:,:,k) = imread(fname, k);    
end
 parsave([fname '.mat'],frames);    
end


%% map mat files:
tiffilenames = dir ([inputDir '\*.tif.mat']);
nWells=length(tiffilenames);
for i=1:nWells
    fname= [inputDir '\' tiffilenames(i).name];
    wellSource{i}=matfile(fname);
end

%% calculate changes:
parfor i=1:nWells
    change(:,:,i)=max(wellSource{i}.frames,[],3)-min(wellSource{i}.frames,[],3);
    meanImage(:,:,i)=mean(wellSource{i}.frames,3);
    imwrite(double(change(:,:,i))/500,[wellSource{i}.Properties.Source     '_change.png'],'Bitdepth',16);
    imwrite(meanImage(:,:,i)/500,[wellSource{i}.Properties.Source     '_mean.png'],'Bitdepth',16);    
end
%%
if 0
parfor i=1:nWells
 
wid=i;
frames=wellSource{wid}.frames;
sourceName = wellSource{wid}.Properties.Source;
swell=sort(wellSource{wid}.frames,3);
df=(swell(:,:,end-10)-swell(:,:,10)./swell(:,:,10));

minf=squeeze(min(min(swell,[],1),[],2));
maxf=squeeze(max(max(swell,[],1),[],2));
meanf=squeeze(mean(mean(swell,1),2));
fig=figure(1); plot(minf);hold on; plot(maxf);plot(meanf);
saveas(fig,[sourceName '_extremes.png']);
clf
fig=figure(1);
hist(df(:),400);
saveas(fig,[sourceName '_hist.png'])
clf
mf=mean(df(:));
stdf=std(df(:));

synapse=(df>(mf+6*stdf));
fig=figure(1);imagesc(synapse);
saveas(fig,[sourceName '_syn1.png'])
clf

%%
s  = regionprops(synapse,'PixelList','PixelIdxList');
for j=1:length(s)
    mask=zeros(512,512);
    pixl=s(j).PixelList;
    pixlid=s(j).PixelIdxList;
    mask(pixlid)=1;
    imagesc(mask)
    %pause;
end

%% calculate avg. signal
for j=1:length(s)
    mask=zeros(512,512);
    pixl=s(j).PixelList;
    rframes=reshape(frames,512*512,[]);
    pixlid=s(j).PixelIdxList;
    synsignal(:,j)=mean(rframes(pixlid,:),1);    
end
fig=figure(1);plot(synsignal);legend show
saveas(fig,[sourceName '_signal.png'])
clf
%% Do some time averaging
fig=figure(1);plot(conv2(synsignal,ones(35,1)/35,'valid'));
saveas(fig,[sourceName '_signaltempSmooth.png'])
clf
%%
s2=s;

%% remove based on size

for iii=length(s):-1:1
    if (length(s(iii).PixelIdxList)<14)
        s2(iii)=[];
    end;
end

%% calculate avg. signal
synsignal=[];
for j=1:length(s2)
    mask=zeros(512,512);
    pixl=s2(j).PixelList;
    rframes=reshape(frames,512*512,[]);
    pixlid=s2(j).PixelIdxList;
    synsignal(:,j)=mean(rframes(pixlid,:),1);    
end
fig=figure(1);plot(synsignal);
legend show

saveas(fig,[sourceName '_signalBigSyn.png'])

clf

end
end

end



    
