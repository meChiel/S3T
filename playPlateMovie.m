function playPlateMovie(dd,writeMovie,accuracy,headless,outputDownsampleFactor)
%% playPlateMovie(dir,writeMovie,accuracy)
%
% with dir, the dir, if not a dialog opens to specify.
%
% writeMovie: A flag 0 or 1, to specify if a movie is exported.
% accuracy: number between 1:16, to specify the accuracy of the
% reconstruction.
%
% example:
% 
% playPlateMovie()
% playPlateMovie('E:\someDir\2-03-19',1,2)
%
% goAllSubDir(@(x) playPlateMovie(x,1,2),'*.tif','E:\someDir\2-03-19')
%%

%%
if nargin<5
    outputDownsampleFactor = 8;%0  
end

d=outputDownsampleFactor ; %Downsample

if nargin<4
    headless = 0;%0
end

if nargin<3
    accuracy=16;
end

if nargin<2
    writeMovie=0;
end

if nargin<1 || isempty(dd)
    dd=uigetdir();
    if isemty(writeMovie)
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
end


%%
%dd='D:\data\Rajiv\9-11-2018\barcode 1400035\NS_1720181109_162332_20181109_164624'
%%
U=[];
S=[];
V=[];
tic
fname=dir([dd '\*.tif']);
fname=natsort(fname);
nTifFiles=length(fname); %60
if nTifFiles>9 && isdir([dd '\eigs'])%only create overview movie if there are at least 10 movies
    for i=1:nTifFiles
        disp(['fast loading: ' fname(i).name]);
        try
            [~, u, s, v, sizeA] = fastLoadTiff([fname(i).folder '\' fname(i).name] ,1,accuracy);
            if i==1
                movieLenght = size(v,1);
            end
            for rrr=1:accuracy % Fit the small movie in the 512,512 frame
                uu=reshape(u(:,rrr),sizeA(1),sizeA(2));
                uup=zeros(512,512);
                uup(1:sizeA(1),1:sizeA(2))=uu;                
                U(:,rrr,i)=uup(:);
            end
            S(:,:,i)=s;
            V(:,:,i)=zeros(movieLenght,accuracy);
            tt=min(movieLenght,size(v,1));
            V(1:tt,1:size(v,2),i)=v(1:tt,:);
            
        catch
            U(:,:,i)=zeros(512*512,accuracy);
            S(:,:,i)=zeros(accuracy,accuracy);
            if i==1
                V(:,:,i)=zeros(10,accuracy);    %Bad fail back system.
            else
                V(:,:,i)=zeros(size(V(:,:,i-1)));
            end
            
            
        end
    end
    toc
    %%
    Ub=U;
    %%
    
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
            if k<size(US,3)
                P1=US(:,:,k)*V(end,:,k)';
                poster1((M-1)*512/d+(1:512/d),(L-1)*512/d+(1:512/d))=reshape(P1,512/d,512/d);
            else
                P1=zeros(512/d*512/d,1);
                poster1((M-1)*512/d+(1:512/d),(L-1)*512/d+(1:512/d))=reshape(P1,512/d,512/d);
            end
            k=k+1;
        end
    end
    
    %%
    if writeMovie
        vidObj = VideoWriter([dd '\' fname(end).name '__overviewVideo_a' num2str(accuracy) '.avi']);
        
        %vidObj = VideoWriter('overviewVideo.avi','MPEG-4');
        % vidObj = VideoWriter('overviewVideo.avi','Motion JPEG 2000');
        %vidObj.CompressionRatio=1000;
        vidObj.Quality=90;
        open(vidObj);
    end
    %%
    if headless~=1
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
    end
    %
    
    
    playMovie();
    %%
    
    
    %%
    
    %%
    if writeMovie
        disp(['created: ' dd '\' fname(end).name '_overviewVideo.avi']);
        close(vidObj);
    end
end

    function playMovie()
        %%
        tic
        for k=1:1:size(V,1) % Movie frames
            r=1;
            
            for L=1:6 % for all wells
                for M=1:10 % for all wells
                    if r<size(US,3)
                        P1=US(:,:,r)*V(k,:,r)';
                        poster((M-1)*512/d+(1:512/d),(L-1)*512/d+(1:512/d))=reshape(P1,512/d,512/d);
                    else
                        P1=zeros(512/d*512/d,1);
                        poster((M-1)*512/d+(1:512/d),(L-1)*512/d+(1:512/d))=reshape(P1,512/d,512/d);
                    end
                    r=r+1;
                end
            end
            
            
            %%
            %P2=rot90(reshape(poster-poster1,512*1,512*2));
            currFrame =rot90(((poster-poster1)+1000)/128/64);
            currFrame(currFrame>1)=1;
            currFrame(currFrame<0)=0;
            if headless~=1
                imagesc(currFrame*128);%2(1:512,1:512)/10);
                
                %   currFrame = getframe(gcf);
                % currFrame = getframe(gca);
                %    writeVideo(vidObj,uint8(currFrame*64));
                %
                axis tight
                axis equal
                axis off
                
                colormap gray
            end
            
            if writeMovie
                writeVideo(vidObj,currFrame);
                disp(['writing frame ' num2str(k) ' of ' num2str(size(V,1))]);
            end
            if headless~=1
                drawnow();
            end
            
        end
        toc
    end


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
end