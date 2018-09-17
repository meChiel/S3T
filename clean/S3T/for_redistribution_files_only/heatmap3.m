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
            [frames,  fname]= loadTiff('E:\share\data\Francisco\cs1\SyG_2.tif');
%%            
            [wx,wy,wz] =size(frames);
%%
mframe=mean(frames,3);
figure;imagesc(mframe);
change=bsxfun(@min, frames,mframe);
hist(change(:),400);
sigma = mean(sqrt(change.^2),3);
msigma = mean(sigma(:));
synapse = (msigma*2)<sigma;
figure;imagesc(synapse);
%%
%%
clear s;

    s  = regionprops(synapse(:,:),'PixelList','PixelIdxList');



%%

%%
s2=s;
%% remove based on size
for iii=length(s):-1:1
    if (length(s(iii).PixelIdxList)<14)
        s2(iii)=[];
    end;
end
%%
synsignal=[];
for j=1:length(s2)
    mask=zeros(wy,wx);
    pixl=s2(j).PixelList;
    rframes=reshape(frames,wx*wy,[]);
    pixlid=s2(j).PixelIdxList;
    synsignal(:,j) = mean(rframes(pixlid,:),1);
end
figure; imagesc(dff(smoothM(synsignal,3)'));colormap('hot')