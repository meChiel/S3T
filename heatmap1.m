 inputDir= uigetdir();
 %%
         %% Map mat files:
        tiffilenames = dir ([inputDir '\*.tif.mat']);
        nWells=length(tiffilenames);
        for i=1:nWells,
            fname= [inputDir '\' tiffilenames(i).name];
            wellSource{i}=matfile(fname);
        end
%%
iii=8;
 wid=iii;
            frames=wellSource{wid}.frames;
            sourceName = wellSource{wid}.Properties.Source;
            
            [frames,  fname]= loadTiff();
            
            [wx,wy,wz] =size(frames);
%%
            synsignal=[];
            for j=1:length(s2)
                mask=zeros(wx,wy);
                pixl=s2(j).PixelList;
                rframes=reshape(frames,wx*wy,[]);
                pixlid=s2(j).PixelIdxList;
                synsignal(:,j)=mean(rframes(pixlid,:),1);
            end
figure; imagesc(dff(smooth(synsignal,3)'));colormap('hot')