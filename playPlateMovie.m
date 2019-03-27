function playPlateMovie(dd,writeMovie)
if nargin<2
    writeMovie=0;
end
if nargin<1
    dd=uigetdir();
    answer = questdlg('Would you like to write the movie?', ...
        'Write Movie', ...
        'Yes','No','No');
    switch answer
        case 'Yes'
            writeMovie=1;
        case 'No'
            writeMovie=0;
    end
end
%% Some settings:
accuracy=2

%%
%dd='D:\data\Rajiv\9-11-2018\barcode 1400035\NS_1720181109_162332_20181109_164624'
%%
U=[];
S=[]
V=[];
tic
fname=dir([dd '\*.tif']);
nTifFiles=length(fname); %60

for i=1:nTifFiles
    disp(['fast loading: ' fname(i).name]);
    try
        [~, U(:,:,i), S(:,:,i), V(:,:,i)] = fastLoadTiff([fname(i).folder '\' fname(i).name] ,1,accuracy);
    catch
        U(:,:,i)=zeros(512*512,accuracy);
        S(:,:,i)=zeros(accuracy,accuracy);
        V(:,:,i)=zeros(size(V(:,:,i-1)));
        
    end
end
toc
%%
Ub=U;
%%
d=8; %Downsample
tic
U=[];
for i=1:nTifFiles
    for j=1:size(Ub,2)
        pp=imresize(reshape(Ub(:,j,i),512,512),1/d);
        U(:,j,i)=pp(:);
    end
end
toc


%%
poster=zeros(512*10/d,512*6/d);
poster1=zeros(512*10/d,512*6/d);
%% precalculate US
US=[];
for L=1:nTifFiles
    US(:,:,L)=U(:,:,L)*S(:,:,L);
end

%%
k=1
for L=1:6 % for all wells
    for M=1:10 % for all wells
        tic
        P1=US(:,:,k)*V(end,:,k)';
        poster1((M-1)*512/d+(1:512/d),(L-1)*512/d+(1:512/d))=reshape(P1,512/d,512/d);
        k=k+1;
    end
end

%%
if writeMovie
    vidObj = VideoWriter([dd '\overviewVideo_a' num2str(accuracy) '.avi']);
    
    %vidObj = VideoWriter('overviewVideo.avi','MPEG-4');
    % vidObj = VideoWriter('overviewVideo.avi','Motion JPEG 2000');
    %vidObj.CompressionRatio=1000;
    vidObj.Quality=80;
    open(vidObj);
end
%%
%f=figure;
%f=figure('units','normalized','outerposition',[-0.10 -0.10 1.5 1.5])
f=figure('units','normalized','outerposition',[0 0 1 1], 'keypressfcn',@keyPress,'Name',dd)


set(f,'MenuBar', 'none');
set(f,'toolBar', 'none');
set(f,'NumberTitle','off');

%set(gcf, 'Position', get(0, 'Screensize'));
set(f,'Color',[0 0 0]);
fig=gcf;
fig.Units='normalized';
fig.OuterPosition=[0 0 1 1];
maximizeFigure();
%


playMovie();
%%
    function keyPress(src, e)
        %disp(e.Key);
        switch e.Key
            case 'escape'
                disp('SeeTrace Disabled');
                STToggle = 0;
            case 's'
                seeTrace();
            case 'space'
                playMovie();
            case 'a'
                doOpenFiles();
        end
    end

%%
    function playMovie()
        %%
        tic
        for k=1:1:size(V,1) % Movie frames
            r=1;
            
            for L=1:6 % for all wells
                for M=1:10 % for all wells
                    P1=US(:,:,r)*V(k,:,r)';
                    poster((M-1)*512/d+(1:512/d),(L-1)*512/d+(1:512/d))=reshape(P1,512/d,512/d);
                    r=r+1;
                end
            end
            
            
            %%
            %P2=rot90(reshape(poster-poster1,512*1,512*2));
            currFrame =rot90(((poster-poster1)+1000)/128/64);
            currFrame(currFrame>1)=1;
            currFrame(currFrame<0)=0;
            imagesc(currFrame*128);%2(1:512,1:512)/10);
            %   currFrame = getframe(gcf);
            % currFrame = getframe(gca);
            %    writeVideo(vidObj,uint8(currFrame*64));
            %
            axis tight
            axis equal
            axis off
            
            colormap gray
            if writeMovie
                writeVideo(vidObj,currFrame);
                disp(['writing frame ' num2str(k) ' of ' num2str(size(V,1))]);
            end
            drawnow();
            
        end
        toc
    end
%%
if writeMovie
    disp(['created: ' dd '\overviewVideo.avi']);
    close(vidObj);
end
end