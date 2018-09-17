dirs={ 
    %'E:\data\Rajiv\10-10-2017\NS_20171620171010_160217_20171010_162625',
    'E:\data\Rajiv\11-10-2017\NS_2017_20171011_131652_20171011_132155',
    'E:\data\Rajiv\11-10-2017\NS_2017_120171011_132239_20171011_133526',
    'E:\data\Rajiv\11-10-2017\NS_2017_220171011_133850_20171011_135545',
    'E:\data\Rajiv\10-10-2017\NS_20171220171010_151648_20171010_151928',
    'E:\data\Rajiv\10-10-2017\NS_20171320171010_152316_20171010_152557',
    'E:\data\Rajiv\10-10-2017\NS_20171420171010_152804_20171010_153310',
    'E:\data\Rajiv\10-10-2017\NS_20171520171010_153502_20171010_155513'
    %'E:\data\Rajiv\10-10-2017\NS_20171620171010_160217_20171010_162625'
    };


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
%% calculate svd:
parfor i=1:nWells
    frames=wellSource{i}.frames;
    sourceName = wellSource{i}.Properties.Source;
    tic,
    [U,S,V,FLAG] = svds(reshape(frames,512*512,[]),6);
  %  fig=figure(1);imagesc(reshape(U(:,1),512,512));
    for iii=1:6
        imwrite((reshape(U(:,iii),512,512)-min(U(:,iii)))/(max(U(:,iii))-min(U(:,iii))+1e-8),[sourceName 'eigenNeuron_' num2str(iii) '.png'],'BitDepth',16);
    end
    fig=figure(1);
    plot(V);
    saveas(fig,[sourceName 'PCA.png']);
    fig=figure(1);
    bar(diag(S));legend(num2str(diag(S)))
    saveas(fig,[sourceName 'sigVal.png']);
    toc
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