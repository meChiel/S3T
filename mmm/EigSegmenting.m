%% load 
[Y, dirSrc]=loadTiff;
figure;imagesc(mean(Y,3));

%% Calculate SVD:
Y2=reshape(Y,[],size(Y,3));
%%
tic
[U, S, V] =svd(Y2,'econ');%,106);
toc

%% Create Mask:
eigIm2=reshape(U(:,2),512,512);
figure;imagesc(eigIm2);
sigma=std(eigIm2(:));

BW1 = (-eigIm2 >(3*sigma)); 
figure;imagesc(BW1);
%%
dilateBW = imdilate(BW1,strel('disk',4));
figure;imagesc(dilateBW);
mask=dilateBW;
save('mask006.mat','mask')
SM=sum(mask(:));

%% RegioProps:

    s  = regionprops(mask,'PixelList','PixelIdxList');
            for j=1:length(s)
                mask2=zeros(512,512);
                pixl=s(j).PixelList;
                pixlid=s(j).PixelIdxList;
                mask2(pixlid)=1;
                imagesc(mask2)
                %pause;
            end
            %%
             for iii=length(s):-1:1
                if (length(s(iii).PixelIdxList)>44)
                    s2(iii)=[];
                end;
            end
%% Control:
controlD=matfile('\\WPRDBES4CB5271\share\data\Rajiv\27-10-2017\plate 1\row B\NS_2017_20171027_110251_20171027_110525\NS_2017_20171027_110251_e0006.tif.mat');
controlD=matfile('\\WPRDBES4CB5271\share\data\Rajiv\17-10-2017\syGcamp1\NS_2017_120171017_133919_20171017_134155\NS_2017_120171017_133919_e0004.tif.mat');
dd=bsxfun(@times,controlD.frames,mask);
avgRespControl=squeeze(sum(sum(dd,1),2)/SM);
k=squeeze(mean(mean(controlD.frames,1),2));
figure;plot(dff(k'));
hold on;
plot(dff(avgRespControl'));
legend('pixel avg','synapse avg')

%% Compound 5min:
compound5min=matfile(...    %'\\WPRDBES4CB5271\share\data\Rajiv\27-10-2017\plate 1\row B\NS_2017_120171027_111557_20171027_111833\NS_2017_120171027_111557_e0006.tif.mat'...
    '\\WPRDBES4CB5271\share\data\Rajiv\17-10-2017\syGcamp1\NS_2017_220171017_135310_20171017_135609\NS_2017_220171017_135310_e0004.tif.mat'...
    );

dd=bsxfun(@times,compound5min.frames,mask);
avgRespC5=squeeze(sum(sum(dd,1),2)/SM);
figure;
plot(dff(squeeze(mean(mean(compound5min.frames,1),2))'));
hold on;
plot(dff(avgRespC5'));
legend('pixel avg','Synapse avg' )
%% Compare:
time=[1:400]/33;
figure;
plot(time,dff(avgRespControl'));
hold on;

plot(time,dff(avgRespC5'));
 legend('Control','Compound X' );
 ylabel('\Delta F/F')
 xlabel('Time (sec.)')
 

%% Compound 10min:
compound10min=matfile(...
    '\\WPRDBES4CB5271\share\data\Rajiv\27-10-2017\plate 1\row B\NS_2017_220171027_112118_20171027_112351\NS_2017_220171027_112118_e0006.tif.mat'...
    );

dd=bsxfun(@times,compound10min.frames,mask);
avgRespC10=squeeze(sum(sum(dd,1),2)/SM);
figure;
plot(dff(squeeze(mean(mean(compound10min.frames,1),2))'));
hold on;
plot(dff(avgRespC10'));
legend('pixel avg','Synapse avg' )

%% Compound 20min:
compound20min=matfile(...
    '\\WPRDBES4CB5271\share\data\Rajiv\27-10-2017\plate 1\row B\NS_2017_320171027_113107_20171027_113340\NS_2017_320171027_113107_e0005.tif.mat'...
    );

dd=bsxfun(@times,compound20min.frames,mask);
avgRespC20=squeeze(sum(sum(dd,1),2)/SM);
figure;
plot(squeeze(mean(mean(compound20min.frames,1),2)));
hold on;
plot(avgRespC20+25);
figure;plot(dff(avgRespC20));

