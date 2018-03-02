function segGUIV1()
global controlResponse
global data;
global fNmTxt dNmTxt prjTxt thresTxt; % Text field in UI for file-name.
global synapseBW; % The BW figure with synapses=1, no-synapse=0
global fname pathname dirname; % Data location
global synRegio; % Regionprops return
global U S V; % eigv decomposition
global wx wy wt;
global synsignal;
global EVN;
global synProb; % Image before threshold for segmentation.
global TValue;  % Threshold value
global dt fps fpsTxt;
global maskRegio;
global stimulationStartTime;
global stimFreq NOS OnOffset; 
global stimFreqtxt NOStxt OnOffsettxt;
global reuseMask reuseMaskChkButton;

stimFreq = 0.125;
NOS=3;
OnOffset=50;
EVN = 2;
fps= 33;
dt= 1/fps;
% For experiment:
global C1Data C1pathname C1fname C1dirname                                 % Control 1AP
global C10Data C10pathname C10fname C10dirname                             % Control 10AP
global M5Data M5pathname M5fname M5dirname                                 % 5min. after drug addition
global M10Data M10pathname M10fname M10dirname                             % 10min. after drug addition
global M20Data M20pathname M20fname M20dirname                             % 20min. after drug addition
global M30Data M30pathname M30fname M30dirname                             % 20min. after drug addition
global ASR mASR miASR
global defaultDir
global sliderBtn synSliderBtn

% Create a figure and axes
startUp();
    function startUp()
        bgc=[.35 .35 .38];
        %bgc=[.95 .95 .95];
        f2 = figure('Visible','on','name','S3: The Stimulated Synapse Segmenter',...
            'Color',bgc,...
            'NumberTitle','off');
        set(f2,'MenuBar', 'figure');
        %set(f2,'MenuBar', 'none');
        %set(f2, 'ToolBar', 'auto');
         set(f2, 'ToolBar', 'none');
        createListArray();
        function createListArray()
            lstY=460;
            lst1 = uicontrol('Style', 'popup', 'String',  {'Spontanious','1 x 10AP','5 x 1AP','10 x 1AP'},...
                'Position', [0 lstY+40 250 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08] );
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
        end
        createPushButtons();
        function createPushButtons
            
            
            ffig = uicontrol('Style', 'pushbutton', 'String', 'popFig',...
                'Position', [1760 740 20 20],...
                'Callback', @popFig);
             exportMaskBtn = uicontrol('Style', 'pushbutton', 'String', 'exp. Mask',...
                'Position', [105 by(10) 50 20],...
                'Callback', @exportMask);
            
            dirProcessBtn = uicontrol('Style', 'pushbutton', 'String', 'Proc. Dir',...
                'Position', [305 by(4) 50 10],...
                'Callback', @processDir);
            
            
            loadMaskBtn = uicontrol('Style', 'pushbutton', 'String', 'load Mask',...
                'Position', [155 by(10) 50 20],...
                'Callback', @doloadMask);
            
            thresholdBtn = uicontrol('Style', 'pushbutton', 'String', 'threshold',...
                'Position', [20 by(8) 50 20],...
                'Callback', @threshold);
            thresholdBtn = uicontrol('Style', 'pushbutton', 'String', '3sig',...
                'Position', [170 by(8) 50 20],...
                'Callback', @threeSigThreshold);
            
            thresTxt = uicontrol('Style', 'Edit', 'String', 'no threshold set',...
                'Position', [70 by(8) 50 20]);
            
             fpsTxt = uicontrol('Style', 'Edit', 'String', num2str(fps),...
                'Position', [270 by(3) 50 20]);
            
            setFPSBtn = uicontrol('Style', 'pushbutton', 'String', 'set fps',...
                'Position', [270+50 by(3) 50 20],...
                'Callback', @setFPS);
            
            btn = uicontrol('Style', 'pushbutton', 'String', 'File',...
                'Position', [5 by(1) 50 20],...
                'Callback', @loadTiff22);
            
            btn1b = uicontrol('Style', 'pushbutton', 'String', 'loadDefault!',...
        'Backgroundcolor',bgc,...        
        'Position', [45 by(1) 10 20],...
                'Callback', @loadDefault);
            
            fNmTxt = uicontrol('Style', 'Text', 'String', 'no File loaded',...
                'Position', [65 by(1)-5 200 20] ); % file name
            
            btnDir = uicontrol('Style', 'pushbutton', 'String', 'Dir',...
        'Backgroundcolor',bgc,...        
        'Position', [5 by(2) 50 20],...
                'Callback', @setDir);
            
            dNmTxt = uicontrol('Style', 'Text', 'String', 'no Dir set',...
                'Position', [65 by(2) 200 20] ); % Dir Name
            
            prjDir = uicontrol('Style', 'pushbutton', 'String', 'Project',...
                'Position', [5 by(3) 50 20],...
                'Backgroundcolor',bgc,...
                'Callback', @setPRJ);
            
            prjTxt = uicontrol('Style', 'Text', 'String', 'no prj set',...
        'Backgroundcolor',bgc,...        
        'Position', [65 by(3) 200 20] );
            btn2 = uicontrol('Style', 'pushbutton', 'String', 'Segment!',...
                'Position', [5 by(4) 50 20],...
                'Backgroundcolor',bgc,...
                'Callback', @segment);
            
            btn3 = uicontrol('Style', 'pushbutton', 'String', 'Background!',...
                'Position', [5 by(5) 50 20],...
                'Backgroundcolor',bgc,...
                'Callback', @bg);
            
            btn4 = uicontrol('Style', 'pushbutton', 'String', 'eigy!',...
                'Position', [20 by(6) 50 20],...
                'Backgroundcolor',bgc,...
                'Callback', @eigy);
            
            btn6 = uicontrol('Style', 'pushbutton', 'String', 'rmvBkGrnd!',...
                'Position', [20 by(9) 50 20],...
                'Backgroundcolor',bgc,...
                'Callback', @rmvBkGrnd);
            
            btn7 = uicontrol('Style', 'pushbutton', 'String', 'saveROIs!',...
                'Position', [5+50 by(10) 50 20],...
                'Backgroundcolor',bgc,...
                'Callback', @saveROIs);
            
            cleanBtn = uicontrol('Style', 'pushbutton', 'String', 'clean',...
                'Position', [70+50 by(8) 50 20],...
                'Backgroundcolor',bgc,...
                'Callback', @cleanBW);
            
            btn9 = uicontrol('Style', 'pushbutton', 'String', 'extractSignals!',...
                'Position', [5 by(11) 50 20],...
                'Backgroundcolor',bgc,...
                'Callback', @extractSignals);
            btn10 = uicontrol('Style', 'pushbutton', 'String', 'signalPlot!',...
                'Position', [5 by(12) 50 20],...
                'Backgroundcolor',bgc,...
                'Callback', @signalPlot);
            btn11 = uicontrol('Style', 'pushbutton', 'String', 'heatMeMap!',...
                'Position', [55 by(12) 50 20],...
                'Callback', @heatMeMap);
            btn12 = uicontrol('Style', 'pushbutton', 'String', 'Peakfinder!',...
                'Position', [5 by(17) 50 20],...
                'Callback', @peakfinder);
            btn13 = uicontrol('Style', 'pushbutton', 'String', 'Load Experiment',...
                'Position', [55 by(17) 50 20],...
                'Callback', @experimentLoader);
            btn14 = uicontrol('Style', 'pushbutton', 'String', 'Batch Experiments',...
                'Position', [105 by(17) 50 20],...
                'Callback', @batchExperiments);
            
            btnAnal = uicontrol('Style', 'pushbutton', 'String', 'Analyze AVG',...
                'Position', [150 by(13) 50 20],...
                'Callback', @analyseAvgReponse);
            btnFold = uicontrol('Style', 'pushbutton', 'String', 'fold spikes',...
                'Position', [150 by(12) 50 20],...
                'Callback', @doMultiResponseto1);
            
            btn7 = uicontrol('Style', 'pushbutton', 'String', 'play',...
                'Position', [60 by(3) 50 20],...
                'Callback', @playMov);
            
            
            createProjectionButtons()
            function createProjectionButtons
                
                btn5 = uicontrol('Style', 'pushbutton', 'String', 'segment2!',...
                    'Position', [20 by(7) 50 20],...
                    'Callback', @segment2);
                
                btn28 = uicontrol('Style', 'pushbutton', 'String', 'NMF',...
                    'Position', [70 by(7) 50 20],...
                    'Callback', @doNMF);
                btn29 = uicontrol('Style', 'pushbutton', 'String', 'change',...
                    'Position', [170+50 by(7) 50 20],...
                    'Callback', @changeZ);
                
                maxProjectionBtn = uicontrol('Style', 'pushbutton', 'String', 'max Z',...
                    'Position', [70+50 by(7) 50 20],...
                    'Callback', @maxZ);
                
                meanProjectionBtn = uicontrol('Style', 'pushbutton', 'String', 'mean Z',...
                    'Position', [170 by(7) 50 20],...
                    'Callback', @meanZ);
                
                
            end
            
            avgSynBtn = uicontrol('Style', 'pushbutton', 'String', 'avg Synapse Response',...
                'Position', [100 by(12) 50 20],...
                'Callback', @avgSynapseResponse);
            
            
            goBtn = uicontrol('Style', 'pushbutton', 'String', 'Process...!',...
                'Position', [5 by(15) 100 60],...
                'BackgroundColor',[.7 .5 .5],...
                'Callback', @go);
            
            sliderBtn = uicontrol('Style', 'slider', 'String', 'Process...!',...
                'Position', [200 by(15) 100 10],...
                'BackgroundColor',[.7 .5 .5],...
                'Callback', @slide);
            
            synSliderBtn = uicontrol('Style', 'slider', 'String', 'Process...!',...
                'Position', [200 by(16) 100 10],...
                'BackgroundColor',[.7 .5 .5],...
                'Callback', @synSlider);
            
            freqfilter2DBtn = uicontrol('Style', 'pushbutton', 'String', '2D freq filter',...
                'Position', [170+50 by(8) 50 20],...
                'Callback', @freqfilter2D);
            
            detectIslandsBtn = uicontrol('Style', 'pushbutton', 'String', 'detect Islands',...
                'Position', [5 by(10) 50 20],...
                'Callback', @detectIslands);
            doseResponseBtn = uicontrol('Style', 'pushbutton', 'String', 'dose ResponseBtn',...
                'Position', [5 by(16) 50 20],...
                'Callback', @doseResponse);
            plateLayoutBtn = uicontrol('Style', 'pushbutton', 'String', 'plate Layout',...
                'Position', [5 by(18) 50 20],...
                'Callback', @PlateLayout2);
                        
            fijimeBtn = uicontrol('Style', 'pushbutton', 'String', 'ImageJ',...
                'Position', [60 by(1) 50 20],...
                'Callback', @fijime);
            
            foldButtons()
            function foldButtons()
                
                NOStxt = uicontrol('Style', 'Edit', 'String', num2str(NOS),...
                    'Position', [220 by(12) 50 20],...
                    'Callback', @setNOS);
                uicontrol('Style', 'text', 'String', 'Number of Stim.',...
                    'Position', [270 by(12) 100 20]);
                
                stimFreqtxt = uicontrol('Style', 'Edit', 'String', num2str(stimFreq),...
                    'Position', [220 by(13) 50 20],...
                    'Callback', @setStimFreq);
                uicontrol('Style', 'text', 'String', 'Stim. freq.',...
                    'Position', [270 by(13) 100 20]);
                OnOffsettxt = uicontrol('Style', 'Edit', 'String', num2str(OnOffset),...
                    'Position', [220 by(14) 50 20],...
                    'Callback', @setOnOffset);
                uicontrol('Style', 'text', 'String', 'Stim. delay',...
                    'Position', [270 by(14) 100 20]);
            end
            
        end
        author();
        function author()
            pos = get(f2, 'Position'); %// gives x left, y bottom, width, height
            figWidth = pos(3);
            figHeight = pos(4);
            txt2 = uicontrol('Style', 'Text', 'String', 'M. Van Dyck (UAntwerpen)',...
                'Position', [-30 -5 200 20],'Backgroundcolor',bgc); %[figWidth-40 -5 200 20] 
        end
        function y = by(k) % calculate y coordinate of button
            nBtnsY = 19; % Number of buttons
            yoff = 30; % Offset bottom
            y = 20*nBtnsY-k*20+yoff;
        end
        createCheckBoxes();
        function createCheckBoxes()
            rbgCB = uicontrol('Style','checkbox','Value',1,...
                'Position',[70 by(9)+2.5 40 15],'String','');
            
            pauseCB = uicontrol('Style','checkbox','Value',0,...
                'Position',[170 by(19)+2.5 60 15],'String','Pause');
            
            reuseMaskChkButton = uicontrol('Style','checkbox','Value',0,...
                'Position',[170 by(3)+2.5 60 15],'String','reuse Mask');
            
            
        end
        defaultDir  = 'E:\share\Data\Rajiv';
    end
    function setOnOffset(s,e,h)
        OnOffset= str2double(OnOffsettxt.String);
    end
    function setStimFreq(s,e,h)
        stimFreq= str2double(stimFreqtxt.String);
    end
    function setNOS(s,e,h)
        NOS = str2double(NOStxt.String);
    end
    function setFPS(s,e,h)
        fps= str2double(fpsTxt.String);
        dt=1/fps;
    end
    function slide(s,e)
        imagesc(data(:,:,floor(sliderBtn.Value*size(data,3))+1));
    end
    function threeSigThreshold(source,event,handles)
        threesigma = mean(synProb(:))+3*std(synProb(:));
        setTvalue(threesigma);
        threshold();
    end
    function changeZ(source,event,handles)
        synProb = mean(abs(bsxfun(@min,data,mean(data,3))),3);
        pause(.5);
        imagesc(synProb);
    end
    function meanZ(source,event,handles)  
        synProb = mean(data,3);
        pause(.5);
        imagesc(synProb);
    end
    function maxZ(source,event,handles) 
        synProb = max(data,[],3);
        pause(.5);
        imagesc(synProb);
    end
    function go(source,event,handles)
        if exist(dirname)
            if (dirname~=0)
                arg.pdir = dirname;
                dataGo(arg);
            else
                dataGo();
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
           % pixl=s2(j).PixelList;
            rframes=reshape(data,wx*wy,[]);
            pixlid=s2(j).PixelIdxList;
            synsignal(:,j) = mean(rframes(pixlid,:),1);
        end
        if length(s2)==0
            disp('No synapses found');
        end
    end
    function synSlider(s,e)
        % Should be a slider to browse trough different synapse scahpe and
        % responses.
        
    end
    function heatMeMap(source,event,handles) 
        pause(.5)
        imagesc(dff(smoothM(synsignal,3)'));colormap('hot')
    end
    function signalPlot(source,event,handles)
        pause(.5)
        subplot(4,4,16);
        plot(bsxfun(@plus,4*dff(synsignal')',1*(1:size(synsignal,2))));
        %plot(bsxfun(@plus,(synsignal')',1000*(1:size(synsignal,2))));
    end
    function detectIslands(s,e)
        synRegio  = regionprops(synapseBW(:,:),'PixelList','PixelIdxList');
    end
    function [ROIs] = saveROIs(source,event,handles)
        %% Mask van regioprops van s wordt ge-exporteerd in ROI subdir.
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
        %figure;
        imagesc(reshape(fh,wy,wx));
        figure;imagesc(reshape(bh,wy,wx));
        
        avg = mean(reshape(data,[],size(data,3)));
        %figure;
        subplot(4,4,12);
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
        [U, S, V] = eigy();%source,event);%,handles);
        %% mirror eigen for + stimulation
        for ii=1:6
            nBlack = sum(U(:,ii)<mean(U(:,ii)));
            nWhite = sum(U(:,ii)>mean(U(:,ii)));
            if (nBlack<nWhite)
                thesign = -1;
            else
                thesign = 1;
            end
            U(:,ii) = thesign .*U(:,ii);
            V(:,ii) = thesign .*V(:,ii);
            %synProb = (-1*(sign(V(1,EVN)).*synProb));
        end
        synProb=reshape(U(:,EVN),[wy,wx]);
        % EVN=1; %Eigen vector number
        synapseBW = reshape(((U(:,EVN))>(std(U(:,EVN))*3)),wy,wx); % Assume first frame, the synapses do no peak. V(1,2) gives direction of 2nd U(:,2).
        subplot(4,4,16);imagesc(synapseBW);colormap('gray');
        %  s  = regionprops(synapseBW(:,:),'PixelList','PixelIdxList');
        
    end
    function rmvBkGrnd(source,event,handles)  
        subplot(4,4,16);
        freqfilter2D();
        
        setTvalue((std(synProb(:))*3));
        threshold(TValue);
        cleanBW();
        %savesubplot(4,4,16,[pathname '_mask']);
        imwrite(synapseBW,[pathname '_mask.png']);
        subplot(4,4,4);
    end
    function setTvalue(tvalue)
        TValue = tvalue;
        thresTxt.String = num2str(TValue);
    end
    function threshold(source,event,handles) 
        TValue = str2double(thresTxt.String);
        synapseBW = synProb > TValue;
        pause(.5);
        imagesc(synapseBW);
    end
    function cleanBW(source,event,handles)
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
        hold off;
        plot(V(:,1));
        title('eig 1')
        subplot(4,4,8);
        hold off;
        plot(V(:,2));
        title('eig 2')
        subplot(4,4,12);
        hold off;
        plot(V(:,3));
        title('eig 3')
    end
    function loadDefault(source,event,handles) 
        pathname = 'E:\share\data\Rajiv\20171027\plate 1\row B\NS_120171027_105928_20171027_110118\NS_120171027_105928_e0006.tif';
        [data, pathname, fname, dirname] = loadTiff(pathname);
        wx = size(data,2); wy = size(data,1); wt = size(data,3);
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
        
        title('loading')
        [data, pathname, fname, dirname] = loadTiff();
        wx = size(data,2); wy = size(data,1);wt = size(data,3);
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
    function avgSynapseResponse(source,ev) 
        hold off
        if ~isempty(synsignal)
            ASR = mean(dff(synsignal'),1); % Average over all synapses
        else
            ASR=zeros(1,wt);
            invalidate();
        end
       end
    function analyseAvgReponse(s,e)
        % Amplitude
        [mASR, miASR] = max(ASR); % Average Synaptic Response 
        
        stimulationStartTime = 1.0;
        stimulationStartFrame = floor(stimulationStartTime /dt);
        
        pause(.5);
        subplot(4,4,8)
        cla
        plot(dt*(((1:length(ASR))-1)), ASR);
        xlabel(['Time(s) (' num2str(fps) 'fps)'])
        ylabel('\Delta F/F0');
        title('Analysis')
        text(miASR/fps,mASR*1.05 ,['max: ' num2str(mASR)],'HorizontalAlignment','center');
        % Area under the curve
        text(miASR/fps,mASR*0.7 ,{'AUC:', num2str(sum(ASR))},'HorizontalAlignment','center');
        
        
        upframes = miASR-stimulationStartFrame;
        upResponse = ASR(stimulationStartFrame:miASR);
        
        expdata.x = (0:(length(upResponse)-1))*dt;
        expdata.y = upResponse;
        %[expEqUp, fitCurve1] = curveFitV1(expdata,[.22 100 0 2 -1 2]);
        if length(expdata.x(:))<=4
            expEqUp =[0 0 0 0] ;
            disp(['No up kinetcis fit for: ' fname]);
        else
            [fitCurve1] = fit(expdata.x(:),expdata.y(:),'exp2');%[.22 100 0 2 -1 2]);
            expEqUp = coeffvalues(fitCurve1);
            hold on;
       %temp.     plot(expdata.x+stimulationStartTime, fitCurve1(expdata.x));
        end
        %downResponse = ASR(miASR:miASR+floor(3.0/dt));
        downResponse = ASR(miASR:end);
         expdata.x = (0:(length(downResponse)-1))*dt;
         expdata.y = downResponse;
         %[expEqDown, fitCurve2] = curveFitV1(expdata,[0 1 0 2 1 2]);
         if length(expdata.x(:))<=4
             expEqDown =[0 0 0 0] ;
             disp(['No down kinetics fit for: ' fname]);
         else
             [fitCurve2] = fit(expdata.x(:),expdata.y(:),'exp2');
             expEqDown = coeffvalues(fitCurve2);
             hold on;
          %temp.   plot(miASR*dt+expdata.x, fitCurve2(expdata.x));
         end

         %% First order exponentials
        
   
        % Kinetics:
        % UP
        upIC50 = find(ASR>(mASR/2),1,'first');
        if length(upIC50)~=1 % Detect problems when no spike is detected.
           UpHalfTime=nan;
           upFrames=nan;
           upIC50=nan;
           upIC50=nan;
           
        else
        if upIC50<2 % Detect spike in first frame.
            upIC50=2;
            upIC50 = 15+find(ASR(15:end)>(mASR/2),1,'first');
            warning(['spontanious activity in: ' fname ' de-stabilised UP Spike Rate detection'])
        end
        framePart = (mASR/2-ASR(upIC50-1)) / (ASR(upIC50)-ASR(upIC50-1)) * 1; % Lin. interpolat betwen frames
        upFrames = upIC50 -1 +framePart -1;
        UpHalfTime = upFrames * dt;
        % text(UpHalfTime,mASR*0.5 ,['UP_{50}: ' num2str(UpHalfTime)],'HorizontalAlignment','right');
        if length(UpHalfTime)~=1
            disp('something weird is happenning');
         %   dbstop;
        end
        %text(UpHalfTime,0.0 ,{'UP_{50}: ', [num2str(UpHalfTime) 's']},'HorizontalAlignment','Left','VerticalAlignment','Top','FontSize',8,'Rotation',-45);
        text(UpHalfTime,0.0 ,{[num2str(UpHalfTime) 's']},'HorizontalAlignment','Left','VerticalAlignment','Top','FontSize',8,'Rotation',-45);
        
        end
        
        % Down
        downIC50 = find(ASR>(mASR/2),1,'last');
        if length(downIC50) == 0
            miASR=nan;
            DownHalfTime=nan;
            downFrames=nan;
            framePart=nan;
        else
            if downIC50 == length(ASR)
                downIC50 = downIC50 -1;
                disp(['Down slope in:' fname ' is not finished before end.' ] )
            end
            framePart = (mASR/2-ASR(downIC50+1)) / (ASR(downIC50)-ASR(downIC50+1)) * 1; % Lin. interpolat betwen frames
            downFrames = downIC50 + 1 - framePart -1;
            DownHalfTime = downFrames * dt;
            %text(DownHalfTime,mASR*0.5 ,['DOWN_{50}: ' num2str(DownHalfTime)],'HorizontalAlignment','left');
            %text(DownHalfTime,0.0 ,{'DOWN_{50}: ', [num2str(DownHalfTime) 's']},'HorizontalAlignment','left','VerticalAlignment','Top','FontSize',8,'Rotation',-45);
            text(DownHalfTime,0.0 ,{ ['    ' num2str(DownHalfTime) 's']},'HorizontalAlignment','left','VerticalAlignment','Bottom','FontSize',8,'Rotation',-45);
            
            %text(miASR*dt,0.0 ,{'T_{max}: ', [num2str(miASR*dt) 's']},'HorizontalAlignment','left','VerticalAlignment','Top','FontSize',8,'Rotation',-45);
            text(miASR*dt,0.0 ,{ [num2str(miASR*dt) 's']},'HorizontalAlignment','left','VerticalAlignment','Top','FontSize',8,'Rotation',-45);
        end
        
        % Lines
        
        hold on;
        plot([UpHalfTime DownHalfTime],[mASR mASR],'color',0.3*[1 1 1]); % Top line
        plot([UpHalfTime UpHalfTime ],[mASR 0],'color',0.3*[1 1 1]); % Up line
        plot([DownHalfTime DownHalfTime],[mASR 0],'color',0.3*[1 1 1]); % Down line
        plot([(miASR-1)/fps (miASR-1)/fps],[mASR 0],'color',0.3*[1 1 1]); % Max vert line
        plot([0 (length(ASR)-1)/fps],[0 0],'color',0.0*[1 1 1]); % X axis
        
        
        %% Fit exponentials:
        if 0
            % Down: Goes to 0 and take 50% point.
            plot(miASR*dt+(0:100)*dt,mASR*exp(-(0:100)*dt/DownHalfTime/exp(-.5)/.5),'r');
            
            % Up: Use 50% and total amplitude point.
            %plot(1+(0:100)*dt,mASR*1.3*(1-exp(-(0:100)*dt/UpHalfTime/.606*2)),'r');
            % Find exp amplitude term
            UpHalfTime/exp(-.5)/.5;
            % plot(1+(0:100)*dt, mASR*(1-exp(-(0:100)*dt/UpHalfTime/exp(-.5)/.5)),'r');
            ampSS = (1-exp(-miASR*dt/UpHalfTime/exp(-.5)/.5));
            %  plot(1+(0:100)*dt, ampSS*(1-exp(-(0:100)*dt/UpHalfTime/exp(-.5)/.5)),'r');
            
            
            tau1 = -(UpHalfTime-1)/log(-mASR/2 /ampSS +1);
            % plot(1+(0:100)*dt,ampSS*(1-exp(-(0:100)*dt/tau1)),'k');
            
            ampSS = mASR/(1-exp(-((miASR-1)*dt-1)/tau1)) ;
            %plot(1+(0:100)*dt,ampSS*(1-exp(-(0:100)*dt/tau1)),'c');
            
            for i=1:100 %OK, this is stupid slow implementation, but it works.
                tau1 = -(UpHalfTime-1)/log(-mASR/2 /ampSS +1) ;
                ampSS = mASR/(1-exp(-((miASR-1)*dt-1)/tau1)) ;
            end
            nCurvePoints=(2*(miASR-upIC50));
            % Subplot(4,4,15)
            plot(stimulationStartTime + (0:nCurvePoints)*dt,ampSS*(1-exp(-(0:nCurvePoints)*dt/tau1)),'m');
            % Tau1
            text(4,ampSS ,{'( \tau_1, A_{SS} )', [ '(' num2str(tau1) 's, ' num2str(ampSS) ')' ]},'HorizontalAlignment','center','VerticalAlignment','Middle','FontSize',12,'Rotation',90);
            
        end
        
        savesubplot(4,4,8,[pathname '_analysis']);
        error =0;
        t =array2table([mASR miASR fps UpHalfTime DownHalfTime expEqUp expEqDown error ],'VariableNAmes',{'mASR', 'miASR', 'fps', 'UpHalfTime', 'downHalfTime', 'expEqy0', 'upA1', 'upx0', 'upT1', 'expEqdwny0', 'dwnA1', 'dwnx0', 'dwnT1','error'});
        %t =array2table([mASR miASR fps UpHalfTime DownHalfTime expEqUp expEqDown ],'VariableNAmes',{'mASR', 'miASR', 'fps', 'UpHalfTime', 'downHalfTime', 'expEqy0', 'upA1', 'upx0', 'upT1', 'upA2', 'upT2', 'expEqdwny0', 'dwnA1', 'dwnx0', 'dwnT1', 'dwnA2', 'dwnT2'});

        mkdir ([dirname 'output\']);
        writetable(t,[dirname 'output\' fname(1:end-4) '_analysis']);
        disp([dirname 'output\' fname(1:end-4) '_analysis.csv']);disp([ 'created']);
        subplot(4,4,15)
        
    end
    function freqfilter2D(s,e)
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
        
           GG = fftshift(ffU2);
        beta = 4; % roughly equivalent to Hann
        w = kaiser(size(GG,1),beta);
        % wKspLR = w .* kspLR;  % may work directly if you have R2016b or later.
        GG = bsxfun(@times, w, GG);
        
        w = kaiser(size(GG,2),beta);
        % wKspLR = w .* kspLR;  % may work directly if you have R2016b or later.
        GG = bsxfun(@times, w, GG');
        GG = GG';
        ffU2 = ifftshift(GG);
        
        
        U22=real(ifft2(ffU2));
        
        % imagesc(abs(ffU2));
        imagesc(U22);
        % synapseBW = U22<-2e-3;
        
        synProb = U22;
        %    synProb = (-1*(sign(V(1,EVN)).*synProb));
    end
    function processDir(s,e,h)
        [C10dirname] = uigetdir(defaultDir,'Select control 10AP dir:');
        defaultDir =  [C10dirname '\..'];
        experiments = dir([C10dirname '\*.tif']);
        for ii = 1:length(experiments )
            %ee = num2str(100+experiments(ii));ee = ee(2:3); % To make 01,02, 03, .. 10, 11
            C10expnm{ii} = dir ([C10dirname '\' experiments(ii).name]);
        end
        
        
%         experiments = 0:60;
%         % Create absolute Paths
%         for ii = 1:length(experiments )
%             ee = num2str(100+experiments(ii));ee = ee(2:3); % To make 01,02, 03, .. 10, 11
%             C10expnm{ii} = dir ([C10dirname '\*e00' ee '.tif']);
%            % C10expnm{ii} = dir ([C10dirname '\*iGlu_' num2str(ii) '.tif']);
%         end
        
            for iii = 1:length(experiments)
            % Load exp 1:10AP
            
            % Visualise we do new experiment.
            
            
            % Load the data
            [data, pathname, fname, dirname] = loadTiff([C10expnm{iii}.folder '\' C10expnm{iii}.name]);
            defaultDir =  dirname;
            wx = size(data,2); wy = size(data,1);
            fNmTxt.String=fname;
            
            if (reuseMaskChkButton.Value==1)
                loadMask([pathname(1:end) '_mask.png']);
            else
            segment2();
            rmvBkGrnd();
            detectIslands();
            extractSignals();
            %loadTiff22();
            exportMask();
            setMask();
            end
            
            % GetSignal
            synRegio = maskRegio;
            if length(synRegio) ~=0
                extractSignals();
                % GetAmplitude
                avgSynapseResponse();
                
                doMultiResponseto1(); warning('% !! Only Hack for proc of 3 spike data !!');
                
                analyseAvgReponse();
                AP10Response(iii) = mASR;
            else
                % Invalidate:
                invalidate();
                
            end
            end
             
              
    end

    function invalidate() 
    % Write some files to output standard results when experiment is
    % invalid.
    subplot(4,4,8);
    hold off;plot(0);
    savesubplot(4,4,8,[pathname '_analysis']);
    mASR=0; miASR=0; fps=fps; UpHalfTime=0; DownHalfTime=0; expEqUp=0; expEqDown=0; error=1;
    t =array2table([mASR miASR fps UpHalfTime DownHalfTime expEqUp expEqDown error],'VariableNAmes',{'mASR', 'miASR', 'fps', 'UpHalfTime', 'downHalfTime', 'expEqy0', 'upA1', 'upx0', 'upT1', 'expEqdwny0', 'dwnA1', 'dwnx0', 'dwnT1', 'invalid'});
    %t =array2table([mASR miASR fps UpHalfTime DownHalfTime expEqUp expEqDown ],'VariableNAmes',{'mASR', 'miASR', 'fps', 'UpHalfTime', 'downHalfTime', 'expEqy0', 'upA1', 'upx0', 'upT1', 'upA2', 'upT2', 'expEqdwny0', 'dwnA1', 'dwnx0', 'dwnT1', 'dwnA2', 'dwnT2'});
    mkdir ([dirname 'output\']);
    writetable(t,[dirname 'output\' fname(1:end-4) '_analysis']);
    end
    function doseResponse(s,e,h) 
        
        % Select Data dirs
        
        
        if 1
            project = openPlateProject();%filePath);
            C10dirname = getProjDir(project,'10AP Control');
%            C1dirname = getProjDir(project,'1AP Control');
          %  M5dirname = getProjDir(project,'1AP 5min');
           % M10dirname = getProjDir(project,'1AP 10min');
           % M20dirname = getProjDir(project,'1AP 20min');
           % M30dirname = getProjDir(project,'1AP 30min');
            
            [plateFilename, plateDir] = uigetfile('*.csv',['Select Plate Layout File'],[defaultDir '\']);
        else
            if 0
                C10dirname =  'D:\data\Rajiv\20171017\syGcamp1\NS_2017_20171017_133534_20171017_133729';
                C1dirname =  'D:\data\Rajiv\20171017\syGcamp1\NS_2017_120171017_133919_20171017_134155';
                M5dirname =     'D:\data\Rajiv\20171017\syGcamp1\NS_2017_220171017_135310_20171017_135609'
                M10dirname =     'D:\data\Rajiv\20171017\syGcamp1\NS_2017_320171017_135815_20171017_140054'
                M20dirname=     'D:\data\Rajiv\20171017\syGcamp1\NS_2017_420171017_140224_20171017_140422'
                
            else
                [C10dirname] = uigetdir(defaultDir,'Select control 10AP dir:');
                defaultDir =  [C10dirname '\..'];
                [C1dirname]  = uigetdir(defaultDir,'Select control 1AP dir:');
                defaultDir =  [C1dirname '\..'];
                [M5dirname]  = uigetdir(defaultDir,'Select 5min. Compound 1AP dir:');
                defaultDir =  [M5dirname '\..'];
                [M10dirname] = uigetdir(defaultDir,'Select 10min. Compound 1AP dir:');
                defaultDir =  [M10dirname '\..'];
                [M20dirname] = uigetdir(defaultDir,'Select 20min. Compound 1AP dir:');
                defaultDir =  [M20dirname '\..'];
            end
        end
        
        % Define experiments to process
        experiments = 1:28;
        % Create absolute Paths
        for ii = 1:length(experiments )
            ee = num2str(100+experiments(ii));ee = ee(2:3); % To make 01,02, 03, .. 10, 11
            %C10expnm{ii} = dir ([C10dirname '\*e00' ee '.tif']);
            C10expnm{ii} = dir ([C10dirname '\*iGlu_' num2str(ii) '.tif']);
        end
        if isempty(C1dirname)
            C1expnm{ii}=[];
        else
        for ii = 1:length(experiments )
            ee = num2str(100+experiments(ii));ee = ee(2:3); % To make 01,02, 03, .. 10, 11
            C1expnm{ii} = dir ([C1dirname '\*e00' ee '.tif']);
        end
        end
%         for ii = 1:length(experiments )
%             M5expnm{ii} = dir ([M5dirname '\*e000' num2str(experiments(ii) ) '.tif']);
%         end
%         for ii = 1:length(experiments )
%             M10expnm{ii} = dir ([M10dirname '\*e000' num2str(experiments(ii) ) '.tif']);
%         end
%         for ii = 1:length(experiments )
%             M20expnm{ii} = dir ([M20dirname '\*e000' num2str(experiments(ii) ) '.tif']);
%         end
%         for ii = 1:length(experiments )
%             M30expnm{ii} = dir ([M30dirname '\*e000' num2str(experiments(ii) ) '.tif']);
%         end
        
        %% Find and set Meta Data
        % Select Plate Layout
        if 0
            filenm =    'plateLayout_Concentration.csv'
            plateDir =    'D:\data\Rajiv\20171017\syGcamp1\'
        else
            if ~plateDir
                [plateFilename, plateDir] = uigetfile('*.csv',['Select Plate Layout File'],[defaultDir '\']);
            end
        end
        defaultDir =  plateDir;
        plateValues = csvread([plateDir '\' plateFilename ]);
        id = strfind(plateFilename,'_');
        plateQuantity = plateFilename(id+1:end-4);
        
        % Load Andor file
        tttt = dir([C10dirname '\NS_*.txt']);
        if length(tttt)==0
            tttt = dir([C10dirname '\Protocol*.txt']);
        end
        andorfilename = [tttt.folder '\' tttt.name];
        exp2wellNr = readAndorFile(andorfilename);
        
        plate.plateValues = plateValues;
        plate.expwells = exp2wellNr;
        wellQty = getPlateValue(plate,experiments);
        
        
        %%
        for iii = 1:length(experiments)
            % Load exp 1:10AP
            
            % Visualise we do new experiment.
            
            
            % Load the data
            [data, pathname, fname, dirname] = loadTiff([C10expnm{iii}.folder '\' C10expnm{iii}.name]);
            defaultDir =  dirname;
            wx = size(data,2); wy = size(data,1);
            fNmTxt.String=fname;
            
            
            segment2();
            rmvBkGrnd();
            detectIslands();
            extractSignals();
            %loadTiff22();
            exportMask();
            setMask();
            % GetSignal
            synRegio = maskRegio;
            if length(synRegio) ~=0
                extractSignals();
                % GetAmplitude
                avgSynapseResponse();
                
                doMultiResponseto1(); warning('% !! Only Hack for proc of 3 spike data !!');
                
                analyseAvgReponse();
                AP10Response(iii) = mASR;
                
                % Load exp 2: control
                
                %loadTiff22();
                try C1expnm{ii};
                [data, pathname, fname, dirname] = loadTiff([C1expnm{iii}.folder '\' C1expnm{iii}.name]);
                wx = size(data,2); wy = size(data,1);
                fNmTxt.String=fname;
                newmask =1;
                if newmask % Create new mask, use 10AP mask.
                    segment2();
                    rmvBkGrnd();
                    detectIslands();
                else
                    synRegio=maskRegio;
                end
                if length(synRegio) ~=0
                    extractSignals();
                    % GetAmplitude
                    avgSynapseResponse();
                    ASR=multiResponseto1(ASR);
                    
                    analyseAvgReponse();
                    subplot(4,4,12)
                    
                    controlResponse(iii) = mASR;
                else
                    disp(['No synapses identified in: ' fname])
                    controlResponse(iii)=nan;
                end
                catch 
                    disp(['No control data for' fname])
                end
          if 0  
                % Load exp 3: 5min 1AP
                %loadTiff22();
                [data, pathname, fname, dirname] = loadTiff([M5expnm{iii}.folder '\' M5expnm{iii}.name]);
                wx = size(data,2); wy = size(data,1);
                fNmTxt.String=fname;
                if newmask % Create new mask, use 10AP mask.
                    segment2();
                    rmvBkGrnd();
                    detectIslands();
                else
                    synRegio=maskRegio;
                end
                
                if length(synRegio) ~=0
                    extractSignals();
                    % GetAmplitude
                    avgSynapseResponse();
                    hold on
                    plot(ASR,'k','LineWidth',2)
                    hold off
                    savesubplot(4,4,12,[pathname '_response'])
                    ASR=multiResponseto1(ASR);
                    analyseAvgReponse();
                    min5Response(iii) = mASR;
                else
                    disp(['No synapses identified in: ' fname])
                    mASR=nan;
                    min5Response(iii) = mASR;
                end
            
                % Load exp 4: 10 min 1AP
                %loadTiff22();
                [data, pathname, fname, dirname] = loadTiff([M10expnm{iii}.folder '\' M10expnm{iii}.name]);
                wx = size(data,2); wy = size(data,1);
                fNmTxt.String=fname;
                if newmask % Create new mask, use 10AP mask.
                    segment2();
                    rmvBkGrnd();
                    detectIslands();
                else
                    synRegio=maskRegio;
                end
                if length(synRegio) ~=0
                    extractSignals();
                    % GetAmplitude
                    avgSynapseResponse();
                    signalPlot();
                    hold on
                    plot(ASR,'k','LineWidth',2)
                    hold off
                    %figure
                    subplot(4,4,8);
                    ASR=multiResponseto1(ASR);
                    analyseAvgReponse();
                    min10Response(iii) = mASR;
                else
                    disp(['No synapses identified in: ' fname])
                    mASR=nan;
                    min10Response(iii) = mASR;
                end
                
                
                
                % Load exp 5: 20 min 1AP
                %loadTiff22();
                [data, pathname, fname, dirname] = loadTiff([M20expnm{iii}.folder '\' M20expnm{iii}.name]);
                wx = size(data,2); wy = size(data,1);
                fNmTxt.String=fname;
                
                if newmask % Create new mask, use 10AP mask.
                    segment2();
                    rmvBkGrnd();
                    detectIslands();
                else
                    synRegio=maskRegio;
                end
                if length(synRegio) ~=0
                    extractSignals();
                    % GetAmplitude
                    avgSynapseResponse();
                    ASR=multiResponseto1(ASR);
                    
                    analyseAvgReponse();
                    min20Response(iii) = mASR;
                else
                    disp(['No synapses identified in: ' fname])
                    mASR=nan;
                    min20Response(iii) = mASR;
                end
                
                
                % Load exp 6: 30 min 1AP
                %loadTiff22();
                [data, pathname, fname, dirname] = loadTiff([M30expnm{iii}.folder '\' M30expnm{iii}.name]);
                wx = size(data,2); wy = size(data,1);
                fNmTxt.String=fname;
                
                if newmask % Create new mask, use 10AP mask.
                    segment2();
                    rmvBkGrnd();
                    detectIslands();
                else
                    synRegio=maskRegio;
                end
                if length(synRegio) ~=0
                    extractSignals();
                    % GetAmplitude
                    avgSynapseResponse();
                    ASR=multiResponseto1(ASR);
                    
                    analyseAvgReponse();
                    min30Response(iii) = mASR;
                else
                    disp(['No synapses identified in: ' fname])
                    mASR=nan;
                    min30Response(iii) = mASR;
                end
              end
                
            else
                disp(['No synapses identified in: ' fname])
                mASR=nan;
                min10Response(iii) = mASR;
                AP10Response(iii) = nan;
                controlResponse(iii) = nan;
                min5Response(iii) = nan;
                min20Response(iii) = nan;
                min30Response(iii) = nan;
                
            end
            
            hold off;
            subplot(4,4,14);
            plot([0 ]  , [controlResponse(iii)]);% min5Response(iii)]);
            %plot([0 5 10 20 30] , [controlResponse(iii) min5Response(iii) min10Response(iii) min20Response(iii) min30Response(iii)]);
            savesubplot(4,4,14,[dirname 'responses']);
        end
        %% save the result:
        save ('controlResponse.mat', 'controlResponse')
        
        %% Plot the results
        %figure;
        subplot(4,4,[2:4,6:8,10:12]);
        cla
        pause(.5);
        
        %  plot(wellQty , AP10Response);
        hold on
        plot(wellQty , controlResponse,'o');%./controlResponse,'o');
        
        plot(wellQty , min5Response./controlResponse,'*');
%        plot(wellQty , min10Response./controlResponse,'x');
%        plot(wellQty , min20Response./controlResponse,'o');
        mR = mean([controlResponse],1);% min10Response./controlResponse; min20Response./controlResponse]);
        e = std( [controlResponse],[],1);% min10Response./controlResponse; min20Response./controlResponse]);
      

        %mR = mean([min5Response./controlResponse; min10Response./controlResponse; min20Response./controlResponse]);
        %e = std( [min5Response./controlResponse; min10Response./controlResponse; min20Response./controlResponse]);

        wellSelection1 = (wellQty==1);
        mC1 = sum((wellSelection1).*controlResponse)/sum((wellSelection1));
        sC1 = sqrt(sum((wellSelection1).*(controlResponse-mC1).^2))/sqrt(sum((wellSelection1)));
        
        wellSelection0 = (wellQty==0);
        mC2 = sum(wellSelection0.*controlResponse)/sum(wellSelection0);
        sC2 = sqrt(sum(wellSelection0.*(controlResponse-mC2).^2))/sqrt(sum(wellSelection0));
        
        sum((wellQty==1).*controlResponse)
        errorbar(wellQty, mR,e)
        xlabel(plateQuantity);
        ylabel('Amp. / A_{control}');
        legend('10AP Control','1AP Control', '1AP 5min', '1AP 10min', '10AP 12min')
        savesubplot(4,4,[2:4,6:8,10:12],[pathname '_doseResponse.png'])
        
    end

    function ok = exportMask(s,e,h)
                s2=synRegio;
        synsignal=[];
        mask=uint16 (zeros(wy,wx));
        for j=1:length(s2)
            %pixl=s2(j).PixelList;
            pixlid=s2(j).PixelIdxList;
            mask(pixlid)=(2^16-j);
        end
        if length(s2)==0
            mask=zeros(wy,wx);
        end
       imwrite(mask,[pathname '_mask.png'],'bitdepth',16);
    end
    function meanData = mR1(data)  
        meanData = multiResponseto1(data);
    end
    function doMultiResponseto1(s,e,h)
     ASR = multiResponseto1(ASR);
    end
    function meanData = multiResponseto1(data)
        
        % stimFreq = 0.125;%Hz
        % Number of Stimuli
        % NOS = 3; % Number of Stimuli        
        interStimPeriod = floor(1/stimFreq*fps);
        iSP = interStimPeriod;
        part=zeros(iSP,NOS);
        for iii = 1:NOS
            part(:,iii)=data(OnOffset+(iii-1)*iSP+(1:iSP));
        end
%         part(:,2)=data(OnOffset+1*iSP+(1:iSP));
%         part(:,3)=data(OnOffset+2*iSP+(1:iSP));
%         part(:,4)=data(OnOffset+3*iSP+(1:iSP));
%         part(:,5)=data(OnOffset+4*iSP+(1:iSP));
        %figure;
        subplot(4,4,12)
        [spart,~,~,level]=linBleachCorrect(part');
        part = (spart-level)'; %Using expansion
        plot(part);
        hold on
        
        meanData=mean(part,2);
        
        
        [meanData,~, ~,baseLevel] = linBleachCorrect(meanData'); % To set the bottom back to zero,
        meanData = meanData'-baseLevel;
        plot(meanData,'k','LineWidth',3);
        hold off
        savesubplot(4,4,12,[pathname '_align']);
        
    
        % ASR = meanData;
    end

    function fijime(d1,d2,d3)
    
        %!C:\Users\mvandyc5\Downloads\fiji-win64\Fiji.app\ImageJ-win64.exe C:\Users\mvandyc5\Desktop\Protocol13220180124_132350_e0007.tif
        fijipath  = 'C:\Users\mvandyc5\Downloads\fiji-win64\Fiji.app\ImageJ-win64.exe';
        eval(['!START ' fijipath ' ' pathname]);
        
    
    end
    function ml=maxLength(parts)
        ml=0;
        for iii=1:length(part)
            ml =max(ml, length(part{iii}));
        end
    end
    function setMask()
        maskRegio = synRegio;
    end
    function ok = doloadMask(s,e,h)
        ok = loadMask(maskFilePath);
    end
    function ok = loadMask(maskFilePath)
        if (nargin==0)
            [maskFilename, maskDir] = uigetfile('*.png',['Select mask:'],[defaultDir '\']);
            maskFilePath = [maskDir '\' maskFilename];
        else
            maskFilePath;
        end
           mask = imread(maskFilePath);
           synRegio=[];
           sortedValues = sort(mask(:));
           [lowestNZValueID] = find(0<sortedValues,1);
           lowestNZValue = sortedValues(lowestNZValueID);
           maxValue = max(mask(:));
           ids = maxValue:-1:lowestNZValue;
           imagesc(mask);
           for i=1:length(ids)
               %synRegio{i}.PixelIdxList = find(mask==ids(i));
               synRegio{i}= find(mask==ids(i));
           end
           synRegio=cell2struct(synRegio,'PixelIdxList');
           setMask();
    end
end

 