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
%%     
            [frames,  fname]= loadTiff('E:\share\data\Rajiv\27-10-2017\plate 1\row B\NS_120171027_105928_20171027_110118\NS_120171027_105928_e0007.tif.mat');
            [frames,  fname]= loadTiff('E:\share\data\Rajiv\27-10-2017\plate 1\row B\NS_120171027_105928_20171027_110118\NS_120171027_105928_e0007.tif.mat');
            
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