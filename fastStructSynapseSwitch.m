global slider U S V sizeA ax
if ~exist('defaultDir','var')
    defaultDir = 'c:\';
end
[mf, md ]=uigetfile('*.png',['Select mask:'],[defaultDir '\']);
maskk=loadMask([md mf]);
defaultDir =md;
dd = md;

%%


[fn, dn ]=uigetfile([mf(1:end-13) '*.tif'],['Select source:'],[defaultDir '\']);

accuracy=16;
[~,U,S,V,sizeA]=fastLoadTiff([dn fn],1,accuracy);





%%
% Animate move original to structured synapse view.
%%%
movWrite=1;
if movWrite
    
    %vidObj = VideoWriter([dd fn(1:end-13) '__synapseOverviewVideo_a' num2str(accuracy) '.avi']);
    vidObj = VideoWriter([fn(1:end-13) '__synapseOverviewVideo_a' num2str(accuracy) '.avi']);
    
    %vidObj = VideoWriter('overviewVideo.avi','MPEG-4');
    % vidObj = VideoWriter('overviewVideo.avi','Motion JPEG 2000');
    %vidObj.CompressionRatio=1000;
    vidObj.Quality=90;
    open(vidObj);
end

%
nX=16;nY=ceil(length(maskk)/nX);13;
elSize=76;
ix=0;iy=0;
ov=zeros(elSize*nX,elSize*nY);

f=figure('Name','Synapse Viewer','NumberTitle','off');
set(f,'color',[0 0 0],'toolbar','none');
imagesc(permute(ov,[2,1]));colormap gray;
axis equal

gg=gca;
gg.Color=[0 0 0];
axis tight
axis off
t=10; 
  cf=reshape(U(:,:)*S*V(t,:)',sizeA(1),sizeA(2)); %reconstruct the entire curent frame.
for i=1:1
  imagesc(cf);    
pause

ff2=imread([md mf]);

%imagesc(cf+double(ff)/1e2)
imagesc(cf+double(ff2)/1e2)

pause
end

%%
for t=1:size(V,1)
     cf=0*reshape(U(:,:)*S*V(t,:)',sizeA(1),sizeA(2)); %reconstruct the entire curent frame.
    % construct all synapses
    ovk=zeros(elSize,elSize,length(maskk));
    
    
    for i=1:length(maskk) % for all synapses
        
        mins = min(maskk(i).PixelList);
        maxs = max(maskk(i).PixelList);
        centrs=(maxs-mins)/2+mins;
        
        ff=maskk(i).PixelList+elSize/2-floor(centrs);
        for j=1:size(ff,1) % for all pixels of the current synapse
            ovk(ff(j,2),ff(j,1),i)=U(maskk(i).PixelIdxList(j),:)*S*V(t,:)';
        end
        
        lu(:,i)=floor(centrs)-elSize/2;
        if 0  % Plot surrounding pixels
            
            try
                ovk(:,:,i)=1*ovk(:,:,i)+2*cf(lu(1)+(1:elSize),lu(2)+(1:elSize));
            catch
            end
        end
    end
    %
    for ttttt=1:1
        axis off
        gg=gca;
        tSeq=0:100;
        if t==100
            tSeq=100:-1:0;
        else
            tSeq=0:1:100;
        end
        
        for at=max(0,min(t-200,100))%tSeq%length(V) %For all frames %(at) animation Time
            ix=0;iy=0;
            ov=zeros(elSize*(nX+4),elSize*(nY+4));
            %  cf=reshape(U(:,:)*S*V(t,:)',sizeA(1),sizeA(2)); %reconstruct the entire curent frame.
            for i=1:length(maskk) % for all synapses
                %%  ll=srcIm1(d(i).PixelIdxList);
                ix=ix+1;
                if ix>(nX-1)
                    iy=iy+1;
                    ix=0;
                end
                % Calculate pixel coordinate: interpolate between original
                % position and gallery view
                
                %ov((1:elSize)+elSize*ix,(1:elSize)+elSize*iy)=ovk(:,:);
                txi=floor((1:elSize)+(lu(2,i)+elSize/2)*(100-at)/100+(at)/100*elSize*ix);
                tyi=floor((1:elSize)+(lu(1,i)+elSize/2)*(100-at)/100+(at)/100*elSize*iy);
                
                % Saturate coordinates at border
                [Mx, My]=size(ov);
                txi=(1-(txi>Mx)).*txi+(txi>Mx)*Mx;
                tyi=(1-(tyi>My)).*tyi+(tyi>My)*My;
                
                ov(txi,tyi)=ov(txi,tyi)+((ovk(:,:,i)));
            end
           % ov(1:size(cf,2),1:size(cf,1))= 1*rot90(fliplr(cf))+6*ov(1:size(cf,2),1:size(cf,1));
            currFrame=permute(ov/2000*2,[2,1]);
            % Saturate
            currFrame(currFrame>1)=1;
            currFrame(currFrame<0)=0;
            %gg.XLim=[0 552+0.5*size(cf,1)/100*(at)];
            gg.XLim=[0 size(cf,1)+1.5*size(cf,1)/100*(at)];
            gg.YLim=[0 size(cf,2)+1.5*size(cf,2)/100*(at)];
            imh = imhandles(gcf()); %gets your image handle if you dont know it
            set(imh,'CData',currFrame*64);
            %image(currFrame*64);
            mp=colormap('gray');
            mp2=[mp(:,2) mp(:,1) mp(:,3)];
            colormap(mp2);
            %axis off
            ff= imresize(currFrame(1:floor(gg.YLim(2)),1:floor(gg.XLim(2))),[1024,1024]);
            ff(ff>1)=1;
            ff(ff<0)=0;
            imagesc(ff);
            disp(num2str(t));
            drawnow();
            if movWrite
                writeVideo(vidObj,ff);                
            end
        end
        %pause
    end
end
%
if movWrite
    close(vidObj);
    disp([dd '\' fn(1:end-10) '__synapseOverviewVideo_a' num2str(accuracy) '.avi'])
end

%% Show movie:
pp=uifigure;
ax=uiaxes(pp);
set(pp,'color',[0 0 0],'toolbar','none');
slider = uislider(pp);
slider1 = uislider(pp);
slider2 = uislider(pp);
slider3 = uislider(pp);
slider1.Orientation = 'vertical';
slider2.Orientation = 'vertical';
slider3.Orientation = 'vertical';

slider1.Position=[500, 50, 3, 164];
slider2.Position=[510, 50, 3, 164];
slider3.Position=[520, 50, 3, 164];

slider.Position=[10, 10, length(V),3];
slider.ValueChangedFcn = @doSetFrame;
%pp.KeyPressFcn;

for t=1:length(V)
    S2=ones(size(S));p1=2;p2=3;p3=4:4;
 %   subplot(1,2,1,'Parent',pp)
    cf1=reshape(U(:,:)*S*V(t,:)',sizeA(1),sizeA(2)); % Reconstruct the entire curent frame.
    cf1=cf1/5000;
    cf1(cf1>1)=1;
     cf1(cf1<0)=0; colormap('gray');
    %image(cf1*64);
    axis equal
    axis off
    ax.Visible='off';
    ax.BackgroundColor=[0 0 0];
     drawnow();
   % subplot(1,2,2,'Parent',pp)
   
     cf(:,:,1)=5e3*reshape(U(:,p1)*S2(p1,p1)*V(t,p1)',sizeA(1),sizeA(2)); %reconstruct the entire curent frame.
     cf(:,:,2)=0.5+1e3*reshape(U(:,p2)*S2(p2,p2)*V(t,p2)',sizeA(1),sizeA(2)); %reconstruct the entire curent frame.
     cf(:,:,3)=0.5+2e3*reshape(U(:,p3)*S2(p3,p3)*V(t,p3)',sizeA(1),sizeA(2)); %reconstruct the entire curent frame.
     cf=cf;
     cf(cf>1)=1;
     cf(cf<0)=0;
     image(cf*1,'Parent',ax) 
     axis equal
     axis off
    ax.Visible='off';
    ax.BackgroundColor=[0 0 0];
    
     drawnow();
     %pause;
end