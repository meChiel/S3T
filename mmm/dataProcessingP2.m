%dirs={      };
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
end

%%
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

synapse=(df>(mf+3*stdf));
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
synsignal=[];
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