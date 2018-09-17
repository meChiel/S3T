function segGUIV1()
global data;
global fNmTxt dNmTxt prjTxt; % Text field in UI for file-name.
global synapseBW; % The BW figure with synapses=1, no-synapse=0
global fname pathname dirname; % Data location
global synRegio; % Regionprops return
global U S V; % eigv decomposition
global wx wy;
global synsignal;
global EVN;
global synProb; % Image before threshold for segmentation.
global TValue;
EVN = 2;

% For experiment:
global C1Data C1pathname C1fname C1dirname                                 % Control 1AP
global C10Data C10pathname C10fname C10dirname                             % Control 10AP
global M5Data M5pathname M5fname M5dirname                                 % 5min. after drug addition
global M10Data M10pathname M10fname M10dirname                             % 10min. after drug addition 
global M20Data M20pathname M20fname M20dirname                             % 20min. after drug addition 

global defaultDir
% Create a figure and axes
startUp();
    function startUp()
        f2 = figure('Visible','on','name','The Stimulated Synapse Segmenter',...
            'Color',[.95 .95 .95],...
            'NumberTitle','off');
        %set(f2,'Color',[.95 .95 .95]);
        set(f2,'MenuBar', 'figure');
        set(f2, 'ToolBar', 'auto');
        % set(f2,'color',[0.08104 0.01 0.08104]);
        pos = get(f2, 'Position'); %// gives x left, y bottom, width, height
        figWidth = pos(3);
        figHeight = pos(4);
        txt2 = uicontrol('Style', 'Text', 'String', 'M. Van Dyck(UAntw.)',...
            'Position', [figWidth-40 -5 200 20] );
        lstY=460;
        lst1 = uicontrol('Style', 'popup', 'String',  {'Spontanious','1 x 10AP','5 x 1AP','10 x 1AP'},...
            'Position', [0 lstY+40 250 25] );
        lst2 = uicontrol('Style', 'popup', 'String',  {'SyGCaMP','PSD','iGlSnFr','Artificial'},...
            'Position', [0 lstY+20 250 25] );
        lst3 = uicontrol('Style', 'popup', 'String',  {'Control','5 min','10 min','20 min'},...
            'Position', [0 lstY+0 250 25] );
        lst4 = uicontrol('Style', 'popup', 'String',  {'60X','40X','10X','100X'},...
            'Position', [0 lstY+60 250 25] );
        
        lst5 = uicontrol('Style', 'popup', 'String',  {'file ... ','NSaaa','NSaaa','NSaaa'},...
            'Position', [0 lstY+80 250 25] );
        javaFrame = get(f2,'JavaFrame');
        javaFrame.setFigureIcon(javax.swing.ImageIcon('my_icon.png'));
        
        % Create push button
        prjDir = uicontrol('Style', 'pushbutton', 'String', 'Project',...
            'Position', [5 390 50 20],...
            'Callback', @setPRJ);
        
          fig = uicontrol('Style', 'pushbutton', 'String', 'Project',...
            'Position', [1760 740 20 20],...
            'Callback', @popFig);
        
        prjTxt = uicontrol('Style', 'Text', 'String', 'no prj set',...
            'Position', [65 390 200 20] );
        
        
        btnDir = uicontrol('Style', 'pushbutton', 'String', 'Dir',...
            'Position', [5 370 50 20],...
            'Callback', @setDir);
        
        dNmTxt = uicontrol('Style', 'Text', 'String', 'no Dir set',...
            'Position', [65 370 200 20] );
        
        btn = uicontrol('Style', 'pushbutton', 'String', 'File',...
            'Position', [5 340 50 20],...
            'Callback', @loadTiff22);
        
        btn1b = uicontrol('Style', 'pushbutton', 'String', 'loadDefault!',...
            'Position', [45 340 10 20],...
            'Callback', @loadDefault);
        
        fNmTxt = uicontrol('Style', 'Text', 'String', 'no File loaded',...
            'Position', [65 335 200 20] );
        
        btn2 = uicontrol('Style', 'pushbutton', 'String', 'Segment!',...
            'Position', [5 320 50 20],...
            'Callback', @segment);
        
        btn3 = uicontrol('Style', 'pushbutton', 'String', 'Background!',...
            'Position', [5 300 50 20],...
            'Callback', @bg);
        
        % Create checkboxes:
        % Create Radio buttons:
        btn4 = uicontrol('Style', 'pushbutton', 'String', 'eigy!',...
            'Position', [20 280 50 20],...
            'Callback', @eigy);
        
        btn5 = uicontrol('Style', 'pushbutton', 'String', 'segment2!',...
            'Position', [20 260 50 20],...
            'Callback', @segment2);
        
        btn6 = uicontrol('Style', 'pushbutton', 'String', 'saveROIs!',...
            'Position', [5 220 50 20],...
            'Callback', @saveROIs);
        
        btn7 = uicontrol('Style', 'pushbutton', 'String', 'rmvBkGrnd!',...
            'Position', [20 240 50 20],...
            'Callback', @rmvBkGrnd);
        
        
        btn9 = uicontrol('Style', 'pushbutton', 'String', 'extractSignals!',...
            'Position', [5 180 50 20],...
            'Callback', @extractSignals);
        btn10 = uicontrol('Style', 'pushbutton', 'String', 'signalPlot!',...
            'Position', [5 160 50 20],...
            'Callback', @signalPlot);
        btn11 = uicontrol('Style', 'pushbutton', 'String', 'heatMeMap!',...
            'Position', [55 160 50 20],...
            'Callback', @heatMeMap);
        btn12 = uicontrol('Style', 'pushbutton', 'String', 'Peakfinder!',...
            'Position', [5 140 50 20],...
            'Callback', @peakfinder);
        btn13 = uicontrol('Style', 'pushbutton', 'String', 'Load Experiment',...
            'Position', [55 140 50 20],...
            'Callback', @experimentLoader);
        btn14 = uicontrol('Style', 'pushbutton', 'String', 'Batch Experiments',...
            'Position', [105 160 50 20],...
            'Callback', @batchExperiments);
        
         btn7 = uicontrol('Style', 'pushbutton', 'String', 'play',...
            'Position', [60 340 50 20],...
            'Callback', @playMov);
        
         btn28 = uicontrol('Style', 'pushbutton', 'String', 'NMF',...
            'Position', [70 260 50 20],...
            'Callback', @doNMF);
        
        goBtn = uicontrol('Style', 'pushbutton', 'String', 'Process...!',...
            'Position', [5 60 100 60],...
            'BackgroundColor',[.7 .5 .5],...
            'Callback', @go);
        
        maxProjectionBtn = uicontrol('Style', 'pushbutton', 'String', 'max Z',...
            'Position', [100 260 50 20],...
            'Callback', @maxZ);
        
        meanProjectionBtn = uicontrol('Style', 'pushbutton', 'String', 'mean Z',...
            'Position', [150 260 50 20],...
            'Callback', @meanZ);
        
        rbgCB = uicontrol('Style','checkbox','Value',1,...
                       'Position',[70 242.5 40 15],'String','');
        %cbx = uicheckbox(f2); 
        
        defaultDir  = 'E:\share\Data\Rajiv';
        
    end


    function meanZ(source,event,handles)
         synProb = mean(data,3);
    end

    function maxZ(source,event,handles)
         synProb = max(data,3);
    end

    function go(source,event,handles)
        if exist(dirname)
            if (dirname~=0)
            dataGo(dirname);
            else
                 dataGo()
            end
        else
            dataGo()
        end
    end
    function playMov(source,event,handles)
        maxData=max(data(:));
        pause(.5)
        for (i=1:size(data,3))
            image(data(:,:,i)/maxData*64*2);
            drawnow();
        end
    end
    function extractSignals(source,event,handles)
        s2=synRegio;
        synsignal=[];
        for j=1:length(s2)
            mask=zeros(wy,wx);
            pixl=s2(j).PixelList;
            rframes=reshape(data,wx*wy,[]);
            pixlid=s2(j).PixelIdxList;
            synsignal(:,j) = mean(rframes(pixlid,:),1);
        end
    end
    function heatMeMap(source,event,handles)
        pause(.5)
        imagesc(dff(smoothM(synsignal,3)'));colormap('hot')
    end
    function signalPlot(source,event,handles)
       pause(.5)
        plot(bsxfun(@plus,dff(synsignal')',1*(1:size(synsignal,2))));
    end

    function [ROIs] = saveROIs(source,event,handles)
        %% Mask van regioprops van s wordt ge-exporteerd in ROI subdir.
        synRegio  = regionprops(synapseBW(:,:),'PixelList','PixelIdxList');
        mkdir([dirname 'ROI']);
        for i=1:length(synRegio)
            pixlid=synRegio(i).PixelIdxList;
            ROI = zeros(wy,wx);
            ROI(pixlid)=1;
            imwrite(ROI, [dirname '\ROI\' fname '_M' num2str(i) '.png'],'bitdepth',2);
        end
    end
    function [data22, fname] = bg(source,event,handles)
        %% From first 5 and last 5 frames:
        % Select darkest 1/400 pixels
        % and average.
        [sortedData, bgIndx1]=sort(data(1:(wx*wy)*5));
        bg1 = mean(sortedData(1:floor(end/4)));                             % Background Intensity
        f1 = mean(sortedData(floor(end/10):end));                           % Foreground Intensity
        
        [i1, i2, i3] = ind2sub( [wy,wx,5], bgIndx1);
        li1 = length(i1); % Number of pixels in 5 frames
        li1o4 = floor(li1/5); % pixels/frames??
        D2=reshape(data,[],size(data,3));
        dxy=sub2ind([wy, wx],i1(1:li1o4/20),i2(1:li1o4/20)); % First 5000 pixels
        darkProfiles = (D2(dxy,1:size(data,3)));
        plot(mean(darkProfiles));hold off;
        [dx, dy]=ind2sub([wy,wx],dxy);
        hold on;plot(dx,dy,'r.');
        
        sortedData2=sort(data((end-(wy*wx)*5):end)); % Last frames
        bg2 = mean(sortedData2(1:floor(end/4))); % Take darkest ones
        f2 = mean(sortedData2(floor(end/10):end)); % Take brightest ones
        
        
        [bg, bgI] = mink(reshape(data,[],size(data,3)),floor(wy*wx*.04)); % Take 10% darkest pixels in each frame
        mbg = mean(bg);
        [fg, fgI] = maxk(reshape(data,[],size(data,3)),floor(wy*wx*.01)); % Take 10% darkest pixels in each frame
        mfg = mean(fg);
        bh=hist(bgI(:),1:(wy*wx));
        fh=hist(fgI(:),1:(wy*wx));
        figure;imagesc(reshape(fh,wy,wx));
        figure;imagesc(reshape(bh,wy,wx));
        
        avg = mean(reshape(data,[],size(data,3)));
        figure;
        plot(mbg);hold on
        plot(mfg,'r');
        plot(avg,'g');
        legend('Background','Foreground','Average');
    end

    function doNMF(source,event,handles)
        x = reshape(data,[],size(data,3))'; 
        opt = statset('maxiter',5000,'display','final');
         [w,h] = nnmf(x,5,'rep',10,'opt',opt,'alg','mult');
         opt = statset('maxiter',10000,'display','final');
         [w,h] = nnmf(x,5,'w0',w,'h0',h,'opt',opt,'alg','als');
        %[w,h] = nnmf(reshape(data,[],size(data,3)),6);
         U=h',V=w;
        
        imageEigen;
    end

    function segment2(source,event,handles)
        %global data;
        [U, S, V] = eigy(source,event);%,handles);
        synProb=reshape(U(:,EVN),[wy,wx]);
       % EVN=1; %Eigen vector number 
        synapseBW = reshape((-1*(sign(V(1,EVN))*U(:,EVN))>(std(U(:,EVN))*2)),wy,wx); % Assume first frame, the synapses do no peak. V(1,2) gives direction of 2nd U(:,2).
        subplot(4,4,16);imagesc(synapseBW);colormap('gray');
      %  s  = regionprops(synapseBW(:,:),'PixelList','PixelIdxList');
        
    end
    function rmvBkGrnd(source,event,handles)
        % Remove slow changing gradients over field of view
        % Typically a result from less lightning by the lens.
        
        sz=20; %%This should be based on picture width, pixel resolution
        st2x=wx-sz;
        st2y=wy-sz;
        %EVN=1;
        
        ffU2 = fft2(synProb);
        ffU2(1:sz,1:sz)=0;
        ffU2(st2y:wy,1:sz)=0;
        ffU2(st2y:wy,st2x:wx)=0;
        ffU2(1:sz,st2x:wx)=0;
        
        % Remove Noise, while we're at it.
        
        sz=50; %This should be based on picture width, pixel resolution
        %st2=512/2-sz;
        
        %         ffU2(sz:(512/2),sz:512/2)=0;
        %         ffU2(sz:(512/2),(512/2):(st2+512/2))=0;
        %         ffU2((512/2):(st2+512/2),(512/2):(st2+512/2))=0;
        %         ffU2((512/2):(st2+512/2),sz:(512/2))=0;
        
        ffU2(1:wy,sz:(wx-sz))=0;
        ffU2(sz:(wy-sz),1:wx)=0;
        
        U22=real(ifft2(ffU2));
        
       % imagesc(abs(ffU2));
        imagesc(U22);
       % synapseBW = U22<-2e-3;
       
        synProb = U22;
        synProb = (-1*(sign(V(1,EVN)).*synProb));
        Tvalue = (std(synProb(:))*3);
    end

    function setTvalue(tvalue)
        TValue = tvalue;
    end

    function threshold(Tvalue)
        synapseBW = synProb > (std(synProb(:))*3));
        pause(.5);
        imagesc(synapseBW);
    end

    function cleanBW()
        synapseBW = imerode(synapseBW,strel('disk',2));
        synapseBW = imdilate(synapseBW,strel('disk',2));
        pause(.5);
        imagesc(synapseBW);
    end

    function [Ub, Sb, Vb] = eigy(source, event, handles)
        [U, S, V] = svd(reshape(data,[],size(data,3)),'econ');
        Ub=U;
        Sb=S;
        Vb=V;
        imageEigen;
    end
    function imageEigen(source, event, handles)
        subplot(4,4,[2:3, 6:7]);
        imagesc(reshape(U(:,2),size(data,1),size(data,2)));colormap('gray');
        subplot(4,4,10);
        imagesc(reshape(U(:,1),size(data,1),size(data,2)));colormap('gray');
        title('eig 1')
        subplot(4,4,11);
        imagesc(reshape(U(:,2),size(data,1),size(data,2)));colormap('gray');
        title('eig 2')
        subplot(4,4,14);
        imagesc(reshape(U(:,3),size(data,1),size(data,2)));colormap('gray');
        title('eig 3')
        
        subplot(4,4,4);
        plot(V(:,1));
        title('eig 1')
        subplot(4,4,8);
        plot(V(:,2));
        title('eig 2')
        subplot(4,4,12);
        plot(V(:,3));
        title('eig 3')
    end
    function loadDefault(source,event,handles)
        pathname = 'E:\share\data\Rajiv\20171027\plate 1\row B\NS_120171027_105928_20171027_110118\NS_120171027_105928_e0006.tif';
        [data, pathname, fname, dirname] = loadTiff(pathname);
        wx = size(data,2); wy = size(data,1);
        fNmTxt.String=fname;
        subplot(1,2,1);
        imagesc(data(:,:,1));
        colormap('gray')
        axis equal;
        axis off;
        title(fname)
    end
    function loadTiff22(source,event,handles)
        %global data;
        %global fNmTxt;
        [data, pathname, fname, dirname] = loadTiff();
        wx = size(data,2); wy = size(data,1);
        fNmTxt.String=fname;
        subplot(1,2,1);
        imagesc(data(:,:,1));
        colormap('gray')
        axis equal;
        axis off;
        title(fname)
    end

    function setDir(source,event)
         [dirname] = uigetdir(defaultDir,'Select the dir to process');   
         dNmTxt.String = dirname;
    end
    function [data2, fname] = segment(source,event)
        %global data;
        
        subplot(4,4,[6:7,10:11]);
        mdata1=reshape(mean(linBleachCorrect(reshape(data,wx*wy,[])),2),[wy,wx]);
        mdata2=mean(data,3);
        
        %%% Show some data: Animate
        imagesc(mdata1);
        axis equal;
        axis off;
        title('Segmented')
        subplot(4,4,[8,12]);
        
        imagesc(mdata2);
        %imagesc(dff(mdata,3)));
        
        axis equal;
        axis off;
        title('Segmented')
    end
    function peakfinder(source,event)
        B=ordfilt2(reshape(U(:,1),wy,wx),9,ones(3,3)); % local max filter
        imagesc(B)
        %find()%waar maximum zit.
    end
    function processExperiment(source,event)
        processExperiment();
    end
    function batchLoader(source,event)
        B=ordfilt2(reshape(U(:,1),wy,wx),9,ones(3,3)); % local max filter
        imagesc(B)
        %find()%waar maximum zit.
    end
    function experimentLoader(source,event)
        global fNmTxt10APC fNmTxt1APC fNmTxt5M fNmTxt10M fNmTxt20M
        
        tmpDir =  defaultDir;
       f3 = figure('name','experiment Loader',...
               'NumberTitle','off');
        set(f3,'MenuBar', 'none'); % figure / none
        set(f3, 'ToolBar', 'auto');
         javaFrame = get(f3,'JavaFrame');
        javaFrame.setFigureIcon(javax.swing.ImageIcon('my_icon.png'));
        btn6 = uicontrol('Style', 'pushbutton', 'String', 'load 10AP Control',...
            'Position', [20 260 150 20],...
            'Callback', @load10APControl);
       fNmTxt10APC = uicontrol('Style', 'Text', 'String', 'no File loaded',...
            'Position', [175 260 200 20] );
        
       btn6b = uicontrol('Style', 'pushbutton', 'String', 'load 1AP Control',...
            'Position', [20 240 150 20],...
            'Callback', @load1APControl);
         fNmTxt1APC = uicontrol('Style', 'Text', 'String', 'no File loaded',...
            'Position', [175 240 200 20] );
        btn7 = uicontrol('Style', 'pushbutton', 'String', 'load 5min',...
            'Position', [20 220 150 20],...
            'Callback', @load5min);
         fNmTxt5M = uicontrol('Style', 'Text', 'String', 'no File loaded',...
            'Position', [175 220 200 20] );
        btn8 = uicontrol('Style', 'pushbutton', 'String', 'load 10min',...
            'Position', [20 200 150 20],...
            'Callback', @load10min);
         fNmTxt10M = uicontrol('Style', 'Text', 'String', 'no File loaded',...
            'Position', [175 200 200 20] );
        btn9 = uicontrol('Style', 'pushbutton', 'String', 'load 20min',...
            'Position', [20 180 150 20],...
            'Callback', @load20min);
         fNmTxt20M = uicontrol('Style', 'Text', 'String', 'no File loaded',...
            'Position', [175 180 200 20] );
        
        btn10 = uicontrol('Style', 'pushbutton', 'String', 'processExperiment',...
            'Position', [20 130 150 50],...
            'Callback', @processExperiment);
        
        
        %B=ordfilt2(reshape(U(:,1),512,512),9,ones(3,3)); % local max filter
        %imagesc(B)
        %find()%waar maximum zit.
        
        function load10APControl(source,event)
            [C10Data, C10pathname, C10fname, C10dirname] = loadTiff();
            fNmTxt10APC.String = C10fname; 
            defaultDir = C10dirname;
        end
      
       
        function load1APControl(source,event)
            [C1Data, C1pathname, C1fname, C1dirname] = loadTiff();
             fNmTxt1APC.String = C1fname; 
             defaultDir = C1dirname;
        end
        function load5min(source,event)
            [M5data, M5pathname, M5fname, M5dirname] = loadTiff();
             fNmTxt5M.String = M5fname; 
             defaultDir = M5dirname;
        end
        function load10min(source,event)
            [M10data, M10pathname, M10fname, M10dirname] = loadTiff();
             fNmTxt10M.String = M10fname; 
             defaultDir = M10dirname;
        end
        function load20min(source,event)
            [M20data, M20pathname, M20fname, M20dirname] = loadTiff();
             fNmTxt20M.String = M20fname; 
             defaultDir = M20dirname;
        end
        
        function processExperiment(source,event)
           % segment based on 10AP
           % extract signals from synpses
           % Extract control 1AP synsignals
           % Extract 5 min 1AP synsiglas
           % Extract 10 min 1AP synsignals
           % Extract 20 min 1AP synsignals
           
        end
    end    
end