dirs={
    'E:\share\data\Rajiv\22_11_2017'
%  'E:\data\Rajiv\16-10-2017\NS_2017_1120171016_112208_20171016_112513'
%  'E:\data\Rajiv\16-10-2017\NS_2017_1220171016_151520_20171016_152720'
%  'E:\data\Rajiv\16-10-2017\NS_2017_1320171016_152901_20171016_153440'
%  'E:\data\Rajiv\16-10-2017\NS_2017_1420171016_154356_20171016_154930'
%  'E:\data\Rajiv\16-10-2017\NS_2017_1520171016_155047_20171016_155342'
%  'E:\data\Rajiv\16-10-2017\NS_2017_20171016_125846_20171016_131018'
%  'E:\data\Rajiv\16-10-2017\NS_2017_220171016_132047_20171016_132641'
%  'E:\data\Rajiv\16-10-2017\NS_2017_520171016_143620_20171016_144830'
    };
%%
    pdir = uigetdir();

d = dir([ pdir '/*.*']);
%for i=3:length(d)
%   startWorker('thumbnailCreator([inputDir inputFile])',[pdir '\' d(i).name '\' ]);
%end
%% search subdirectories
clear dirs;
k=0;
for i=3:length(d) % 1,2 is \. and \..
    if d(i).isdir
        k=k+1;
        dirs{k}=[pdir '\' d(i).name ];
    end
end
if k==0
   k=1; dirs{k}=[pdir];
end
%%

for i=1:length(dirs)
    inputDir=dirs{i};
    %%
    if 1
        
        if exist('inputDir','var')
            inputDir=inputDir;
        else
            inputDir= uigetdir();
            %inputDir = [inputDir '\'];
            %inputPath='L:\beerse\all\Public\Exchange\michiel\Rajiv\NS_20174220170912_143321_20170912_144604 - copy\';
        end
        
        %%
        %% convert tif to mat files
        if 0
            tiffilenames = dir ([inputDir '\*.tif']);
            nWells=length(tiffilenames);
            parfor wid=1:nWells
                % well{i}=matfile([inputDir '\' tiffilenames(wid).name]);
                
                % read the images
                fname=[inputDir '\' tiffilenames(wid).name]
                info = imfinfo(fname);
                num_images = numel(info);
                frames=zeros(info(1).Height,info(1).Width,num_images);
                for k = 1:num_images
                    frames(:,:,k) = imread(fname, k);
                end
                parsave([fname '.mat'],frames);
            end
        end
        
        %% Map mat files:
        tiffilenames = dir ([inputDir '\*.tif.mat']);
        nWells=length(tiffilenames);
        for wid=1:nWells,
            fname= [inputDir '\' tiffilenames(wid).name];
            wellSource{wid}=matfile(fname);
        end
        %% calculate changes:
        clear change
        clear meanImage
        clear frames
        parfor wid=1:nWells
            frames=wellSource{wid}.frames;
            [wx,wy,wz] = size(frames);
            ch=max(frames,[],3)-min(frames,[],3);
            change(:,:,wid)=ch;
            dch=double(ch);
            mi=mean(frames,3);
            meanImage(:,:,wid)=mi;
            Source = wellSource{wid}.Properties.Source;
            imwrite(dch/500,[Source     '_change.png'],'Bitdepth',16);
            imwrite(mi/500,[Source     '_mean.png'],'Bitdepth',16);
            imwrite((dch-min(dch(:)))/(max(dch(:))-min(dch(:))),[Source     '_changeAS.png'],'Bitdepth',16);
            imwrite((mi-min(mi(:)))/(max(mi(:))-min(mi(:))),[Source     '_meanAS.png'],'Bitdepth',16);
            averageSignal = squeeze(mean(mean(frames,1),2));
            fig=figure(1); plot(averageSignal);
            axis([0 wz 200 1000])
            saveas(fig,[Source '_averageSignal.png']);
            fig=figure(1); plot(dff(averageSignal'));
            axis([0 wz 0 .2])
            saveas(fig,[Source '_avDFF.png']);
        end
        
        %%
        for iii=[];%1:nWells
            
            wid=iii;
            frames=wellSource{wid}.frames;
            [wx,wy,wz] =size(frames);
            sourceName = wellSource{wid}.Properties.Source;
            swell=sort(frames,3);
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
                mask=zeros(wx,wy);
                pixl=s(j).PixelList;
                pixlid=s(j).PixelIdxList;
                mask(pixlid)=1;
                imagesc(mask)
                %pause;
            end
            
            %% calculate avg. signal
            synsignal=[];
            for j=1:length(s)
                mask=zeros(wx,wy);
                pixl=s(j).PixelList;
                rframes=reshape(frames,wx*wy,[]);
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
                mask=zeros(wx,wy);
                pixl=s2(j).PixelList;
                rframes=reshape(frames,wx*wy,[]);
                pixlid=s2(j).PixelIdxList;
                synsignal(:,j)=mean(rframes(pixlid,:),1);
            end
            fig=figure(1);plot(synsignal);
            legend show
            
            saveas(fig,[sourceName '_signalBigSyn.png'])
            
            clf
            
        end
        
        %%
        if 0
        delete(gcp)
        parpool(5)
        end
        %% calculate SVD:
        for i=[]%1:nWells
            
            %%
            frames=wellSource{i}.frames;
            [wx,wy,wz] = size(frames);
            sourceName = wellSource{i}.Properties.Source;
            tic,
   %         [U,S,V,FLAG] = svds(reshape(frames,wx*wy,[]),6);
            tic
            [U, S, V] =svd(reshape(frames,wx*wy,[]),'econ');%,106);
            toc
            %  fig=figure(1);imagesc(reshape(U(:,1),512,512));
            for iii=1:6
                imwrite((reshape(U(:,iii),wx,wy)-min(U(:,iii)))/(max(U(:,iii))-min(U(:,iii))+1e-8),[sourceName 'eigenNeuron_' num2str(iii) '.png'],'BitDepth',16);
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
    end
end

%%