if ~exist('defaultDir','var')
    defaultDir = 'c:\';
end
[mf, md ]=uigetfile('*.png',['Select mask:'],[defaultDir '\']);
d=loadMask([md mf]);
defaultDir =md;
dd = md;
%%
% [df, dd ]=uigetfile([df(1:end-10) '*.png'],['Select source:'],[defaultDir '\']);
% srcIm1=imread([dd df]);
% 
% [df2, dd2 ]=uigetfile([df(1:end-10) '*.png'],['Select source:'],[defaultDir '\']);
% srcIm2=imread([dd2 df2]);
% 
% [df3, dd3 ]=uigetfile([df2(1:end-10) '*.png'],['Select source:'],[defaultDir '\']);
% srcIm3=imread([dd3 df3]);

%%

[fn, dn ]=uigetfile([mf(1:end-13) '*.tif'],['Select source:'],[defaultDir '\']);

accuracy=16;
[~,U,S,V,sizeA]=fastLoadTiff([dn fn],1,accuracy);


%% Static Viewer
if 0
ix=0;iy=0;
ov=zeros(50*16,50*9);
for i=1:length(d)
    mins = min(d(i).PixelList);
    maxs = max(d(i).PixelList);
    centrs=(maxs-mins)/2+mins;    
    ovk=zeros(50,50);
    ff=d(i).PixelList+25-floor(centrs);
    for j=1:length(ff)
        ovk(ff(j,1),ff(j,2))=srcIm1(d(i).PixelList(j,1),d(i).PixelList(j,2))-2^15;
    end
    
    ix=ix+1;
    if ix>15
        iy=iy+1;
        ix=0;
    end
    ov((1:50)+50*ix,(1:50)+50*iy)=ovk;
end
f=figure('Name','Synapse Viewer','NumberTitle','off');
set(f,'color',[0 0 0],'toolbar','none');imagesc(ov');colormap gray;
axis equal
axis off
gg=gca;
gg.Color=[0 0 0];
end

%% Static Color Viewer
if 0
ix=0;iy=0;
ov=zeros(50*16,50*9,3);
for i=1:length(d)
    ll=srcIm1(d(i).PixelIdxList);
    mins = min(d(i).PixelList);
    maxs = max(d(i).PixelList);
    centrs=(maxs-mins)/2+mins;    
    ovk=zeros(50,50);
    ff=d(i).PixelList+25-floor(centrs);
    for j=1:length(ff)
        ovk(ff(j,1),ff(j,2),1)=srcIm1(d(i).PixelList(j,1),d(i).PixelList(j,2))-2^15;
        ovk(ff(j,1),ff(j,2),2)=srcIm2(d(i).PixelList(j,1),d(i).PixelList(j,2))-2^15;
        ovk(ff(j,1),ff(j,2),3)=srcIm3(d(i).PixelList(j,1),d(i).PixelList(j,2))-2^15;
    end
    
    ix=ix+1;
    if ix>15
        iy=iy+1;
        ix=0;
    end
    ov((1:50)+50*ix,(1:50)+50*iy,:)=ovk(:,:,:);
end
f=figure('Name','Synapse Viewer','NumberTitle','off');
set(f,'color',[0 0 0],'toolbar','auto');imagesc(permute(ov,[2,1,3]));%colormap gray;
axis equal
axis off
axis tight
gg=gca;
gg.Color=[0 0 0];
end

%% Synapse player Viewer:


vidObj = VideoWriter([dd fn(1:end-13) '__synapseOverviewVideo_a' num2str(accuracy) '.avi']);

%vidObj = VideoWriter('overviewVideo.avi','MPEG-4');
% vidObj = VideoWriter('overviewVideo.avi','Motion JPEG 2000');
%vidObj.CompressionRatio=1000;
vidObj.Quality=90;
open(vidObj);

        
%
ix=0;iy=0;
ov=zeros(50*16,50*9);

f=figure('Name','Synapse Viewer','NumberTitle','off');
set(f,'color',[0 0 0],'toolbar','none');
imagesc(permute(ov,[2,1]));colormap gray;
axis equal

gg=gca;
gg.Color=[0 0 0];
axis tight
axis off


for t=1:length(V) %For all frames
    ix=0;iy=0;
    ov=zeros(50*16,50*9);
    
    
    cf=reshape(U(:,:)*S*V(t,:)',sizeA(1),sizeA(2)); %reconstruct the entire curent frame.
    for i=1:length(d) % for all synapses
        %ll=srcIm1(d(i).PixelIdxList);
        mins = min(d(i).PixelList);
        maxs = max(d(i).PixelList);
        centrs=(maxs-mins)/2+mins;
        ovk=zeros(50,50);
        ff=d(i).PixelList+25-floor(centrs);
        for j=1:length(ff) % for all pixels
            ovk(ff(j,1),ff(j,2))=U(d(i).PixelIdxList(j),:)*S*V(t,:)';
        end
        
        if 0  % Plot surrounding pixels
            lu=floor(centrs)-25;
            try
                ovk=5*ovk+cf(lu(1)+(1:50),lu(2)+(1:50));
            catch
            end
        end
        
        ix=ix+1;
        if ix>15
            iy=iy+1;
            ix=0;
        end
        ov((1:50)+50*ix,(1:50)+50*iy)=ovk(:,:);
    end
    
    ov(floor(1:size(ov,2)/length(V)*t),1)=ov(floor(1:size(ov,2)/length(V)*t),1)+2000;
    
    currFrame=permute(ov/2000,[2,1]);
    % Saturate
    currFrame(currFrame>1)=1;
    currFrame(currFrame<0)=0;
    
    image(currFrame*64);%colormap gray;
    axis off
    disp(num2str(t));
    drawnow();
    writeVideo(vidObj,currFrame);
end
%
     close(vidObj);
     disp([dd '\' fn(1:end-10) '__synapseOverviewVideo_a' num2str(accuracy) '.avi'])
     
%%
% Animate original to structured synapse view.
%%%

    
vidObj = VideoWriter([dd fn(1:end-13) '__synapseOverviewVideo_a' num2str(accuracy) '.avi']);

%vidObj = VideoWriter('overviewVideo.avi','MPEG-4');
% vidObj = VideoWriter('overviewVideo.avi','Motion JPEG 2000');
%vidObj.CompressionRatio=1000;
vidObj.Quality=90;
open(vidObj);

        
%
nX=16;nY=13;

ix=0;iy=0;
ov=zeros(50*nX,50*nY);

f=figure('Name','Synapse Viewer','NumberTitle','off');
set(f,'color',[0 0 0],'toolbar','none');
imagesc(permute(ov,[2,1]));colormap gray;
axis equal

gg=gca;
gg.Color=[0 0 0];
axis tight
axis off

ff=imread([md mf]);
image(ff)
pause

for t=100:-1:1%length(V) %For all frames
    ix=0;iy=0;
    ov=zeros(50*nX,50*nY);
    
    cf=reshape(U(:,:)*S*V(t,:)',sizeA(1),sizeA(2)); %reconstruct the entire curent frame.
    for i=1:length(d) % for all synapses
      %%  ll=srcIm1(d(i).PixelIdxList);
        mins = min(d(i).PixelList);
        maxs = max(d(i).PixelList);
        centrs=(maxs-mins)/2+mins;
        ovk=zeros(50,50);
        ff=d(i).PixelList+25-floor(centrs);
        for j=1:length(ff) % for all pixels
            ovk(ff(j,1),ff(j,2))=U(d(i).PixelIdxList(j),:)*S*V(t,:)';
        end
        
           lu=floor(centrs)-25;
        if 0  % Plot surrounding pixels
         
            try
                ovk=5*ovk+cf(lu(1)+(1:50),lu(2)+(1:50));
            catch
            end
        end
        
        ix=ix+1;
        if ix>15
            iy=iy+1;
            ix=0;
        end
        %ov((1:50)+50*ix,(1:50)+50*iy)=ovk(:,:);
        txi=floor((1:50)+(lu(2)+25)*(100-t)/100+(t)/100*50*ix); 
        tyi=floor((1:50)+(lu(1)+25)*(100-t)/100+(t)/100*50*iy);
        ov(txi,tyi)=ov(txi,tyi)+ovk(:,:);
        
        
    end
    currFrame=permute(ov/2000*1,[2,1]);
    % Saturate
    currFrame(currFrame>1)=1;
    currFrame(currFrame<0)=0;
    
    image(currFrame*64);%colormap gray;
    axis off

    disp(num2str(t));
    drawnow();
    writeVideo(vidObj,currFrame);
end
%
     close(vidObj);
     disp([dd '\' fn(1:end-10) '__synapseOverviewVideo_a' num2str(accuracy) '.avi'])

%% Static Color Viewer
if 1
ix=0;iy=0;
ov=zeros(50*16,50*9,3);
srcIm1=reshape(U(:,1),sizeA(1:2));
srcIm2=reshape(U(:,2),sizeA(1:2));
srcIm3=reshape(U(:,3),sizeA(1:2));

for i=1:length(d)
%    ll=srcIm1(d(i).PixelIdxList);
    mins = min(d(i).PixelList);
    maxs = max(d(i).PixelList);
    centrs=(maxs-mins)/2+mins;    
    ovk=zeros(50,50);
    ff=d(i).PixelList+25-floor(centrs);
    for j=1:length(ff)
        ovk(ff(j,1),ff(j,2),1)=srcIm1(d(i).PixelList(j,1),d(i).PixelList(j,2))-2^15;
        ovk(ff(j,1),ff(j,2),2)=srcIm2(d(i).PixelList(j,1),d(i).PixelList(j,2))-2^15;
        ovk(ff(j,1),ff(j,2),3)=srcIm3(d(i).PixelList(j,1),d(i).PixelList(j,2))-2^15;
    end
    
    ix=ix+1;
    if ix>15
        iy=iy+1;
        ix=0;
    end
    ov((1:50)+50*ix,(1:50)+50*iy,:)=ovk(:,:,:);
end
f=figure('Name','Synapse Viewer','NumberTitle','off');
set(f,'color',[0 0 0],'toolbar','auto');imagesc(permute(ov,[2,1,3]));%colormap gray;
axis equal
axis off
axis tight
gg=gca;
gg.Color=[0 0 0];
end
    