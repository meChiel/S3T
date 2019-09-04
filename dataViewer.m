function dataViewer(inputFile)
global plateFilename plateDir responses detailFilename defaultDir currentFile marker lineSize LineStyle;
global fittt histtt exporttt currentLevel STToggle seeTraceBtn exportAll selectionOptions AddDataCommandBtn AddDataCommandEdt dirTxt; 
global exportAllChk openFilesBtn showButtons logX logY; 
global bgc
global seeWellBtn stimLstX stimLstY Xtxt Ytxt
global filterFieldLst lessMoreLst filterThresholdEdt markerSelectionBtn
global doFilterBtn HistBtn levelDownBtn levelUpBtn ExportBtn fitBtn
global lineSizeBtn LineStyleBtn logXChk logYChk wowChkBtn wow backgroundImageBtn backgroundImageSelection
global useXlabelChk jitterChk  
global addFileBtn
global data;
global wellAvg mask
createButons();
if nargin>0
    g=strfind(inputFile,'\');
    plateFilename2 = inputFile((g(end)+1):end);
    plateDir=(inputFile(1:g(end)));
    openFiles(plateFilename2,plateDir)
    pause(1);
    hideButtons();%
end


    function createButons()
        bgc=[0.5 0.5 0.5];
        STToggle=0;
        backgroundImageSelection='none';
        exportAll=0;
        f3 = figure('Visible','on','name','S3T: Data Viewer',...
            'Color',bgc,...
            'NumberTitle','off',...
            'KeyPressFcn', @keyPress);
        openFilesBtn = uicontrol('Style', 'pushbutton', 'String', '(a)Open File!',...
            'Position', [5+50 (20) 50 20],...
            'Backgroundcolor',bgc,...
            'Callback', @doOpenFiles);
        
        markerSelectionBtn = uicontrol('Visible','off','Style', 'popup', 'String', {'.','O','+','x','d','s','p','h','none','<','>','^','v'},...
            'Position', [5+50 900-(30) 50 20],...
            'Backgroundcolor',bgc,...
            'Callback', @setmarker);
        
        seeTraceBtn = uicontrol('Visible','off','Style', 'pushbutton', 'String', '(S)ee Trace',...
            'Position', [5+50+50 20 50 20],...
            'Backgroundcolor',bgc,...
            'Callback', @seeTrace);
        
        dirTxt = uicontrol('Style', 'Text', 'String', 'no files loaded',...
            'Position', [10 930 800 25] , 'HorizontalAlignment','left','BackgroundColor',bgc...%, 'ForegroundColor',[.05 .05 .08]...
            );

        AddDataCommandEdt = uicontrol('Visible','off','Style', 'edit', 'String', 'data{1}=[data{1} array2table(data{1}.(1)./data{1}.(2), ''VariableNames'' ,{''div''})]',...
            'Position', [5+50+500+700 930 500 20],...
            'Backgroundcolor',bgc)
        
        AddDataCommandBtn = uicontrol('Visible','off','Style', 'pushbutton', 'String', 'Do',...
            'Position', [5+50+500+500+700 930 50 20],...
            'Backgroundcolor',bgc,...
            'Callback', @doAddDataCommand);
        
        
        lineSizeBtn = uicontrol('Visible','off','Style', 'popup', 'String', {'0.5','1','2','3','4','5','6'},...
            'Position', [5+50 (900) 50 20],...
            'Backgroundcolor',bgc,...
            'Callback', @setLineSize);
        LineStyleBtn = uicontrol('Visible','off','Style', 'popup', 'String', {'-',':','--','-.','none'},...
            'Position', [5+50 (900-60) 50 20],...
            'Backgroundcolor',bgc,...
            'Callback', @setLineStyle);
        
        backgroundImageBtn = uicontrol('Visible','off','Style', 'popup', 'String', {'none','avg','mask'},...
            'Position', [5+50 (900-90) 50 20],...
            'Backgroundcolor',bgc,...
            'Callback', @setBackgroundImage);
        
        addFileBtn = uicontrol('Visible','off','Style', 'pushbutton', 'String', {'add file'},...
            'Position', [5+50 (0) 50 20],...
            'Backgroundcolor',bgc,...
            'Callback', @addFile);
        
        doFilterBtn=[];
        filterThresholdEdt=[];
        filterFieldLst=[];
        lessMoreLst=[];
        
        javaFrame = get(f3,'JavaFrame');
        %
		try
        	javaFrame.setFigureIcon(javax.swing.ImageIcon([ctfroot '\S3T\PlateLayout_icon.png']));
   		catch
			javaFrame.setFigureIcon(javax.swing.ImageIcon('PlateLayout_icon.png'));
		end     
        LineStyle='-';
        marker = '.';
        lineSize = 1;
        currentFile = 1;
        fittt=0;
        histtt=0;
        exporttt=0;
        logX=0;
        logY=0;
        wow=0;
       
        logYChk = uicontrol('Visible','off','Style', 'checkbox', 'String','Log Y',...
            'Position', [10 320 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
            'CallBack',@logYToggle);
        
        logXChk = uicontrol('Visible','off','Style', 'checkbox', 'String','Log X',...
            'Position', [10 300 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
            'CallBack',@logXToggle);
        
        wowChkBtn = uicontrol('Visible','off','Style', 'checkbox', 'String','WOW',...
            'Position', [10 280 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
            'CallBack',@wowToggle);
        
%         stimLstX = uicontrol('Style', 'popup', 'String', [selectionOptions, {'fileName'}],...
%             'Position', [10 60 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
%             'Visible','off','CallBack',@updatePlot );      

        useXlabelChk = uicontrol('Visible','off','Style', 'checkbox', 'String','selection = X Label',...
            'Position', [10 380 150 25], 'BackgroundColor',bgc, 'ForegroundColor',[.05 .05 .08],...
            'CallBack',@useXlabelToggle);
        
        jitterChk = uicontrol('Visible','off','Style', 'checkbox', 'String','Jitter',...
            'Position', [10 360 150 25], 'BackgroundColor',bgc, 'ForegroundColor',[.05 .05 .08],...
            'CallBack',@jitterToggle);
        
        Xtxt = uicontrol('Style', 'text','String', 'X',...
            'Position', [10 415 150 175],...
            'BackgroundColor',bgc,...%[.35 .35 .38],... 
            'ForegroundColor',[.15 .05 .08],...
            'Visible','off');     
        
        stimLstX = uicontrol('Style', 'list','Max',10,'Min',1, 'String', [{'fileName'}],...
            'Position', [10 400 150 175], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
            'Visible','off','CallBack',@updatePlot );     
        
        Ytxt = uicontrol('Style', 'text','String', 'Y',...
            'Position', [10 615 150 175],...
            'BackgroundColor',bgc,...%[.35 .35 .38],... 
            'ForegroundColor',[.15 .05 .08],...
            'Visible','off');     
        
%         stimLstY = uicontrol('Style', 'popup', 'String', [selectionOptions , {'fileName'}],...
%             'Position', [10 80 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
%             'Visible','off','CallBack',@updatePlot );
        stimLstY = uicontrol('Style', 'list', 'Max',10,'Min',1,'String', [ {'fileName'}],...
            'Position', [10 600 150 175], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
            'Visible','off','CallBack',@updatePlot );
        
%         filterFieldLst = uicontrol('Visible','off','Style', 'popup', 'String', [selectionOptions , {'fileName'}],...
%             'Position', [10 200 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
%             'CallBack',@updatePlot );
        filterFieldLst = uicontrol('Visible','off','Style', 'popup', 'String', [ {'fileName'}],...
            'Position', [10 200 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
            'CallBack',@updatePlot );
        
        lessMoreLst = uicontrol('Visible','off','Style', 'popup', 'String', [{'is LESS than'} , {'is MORE than'}, {'EQUALS'}, {'EQUALS NOT'} ],...
            'Position', [10 180 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08]);
        
        filterThresholdEdt = uicontrol('Visible','off','Style', 'edit', 'String', ' ',...
            'Position', [10 160 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08]);
        
        doFilterBtn = uicontrol('Visible','off','Style', 'pushbutton', 'String', 'Filter',...
            'Position', [10 140 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
            'CallBack',@filterData);
        
        fitBtn = uicontrol('Visible','off','Style', 'pushbutton', 'String', 'Fit',...
            'Position', [5+50+50+50+50 20 50 20],...
            'Backgroundcolor',bgc,...
            'Callback', @fitt);
        
        HistBtn = uicontrol('Visible','off','Style', 'pushbutton', 'String', 'Hist',...
            'Position', [5+50+50+50+50+50 20 50 20],...
            'Backgroundcolor',bgc,...
            'Callback', @histt);
        
        ExportBtn = uicontrol('Visible','off','Style', 'pushbutton', 'String', 'Export',...
            'Position', [5+50+50+50+50+50+50 20 50 20],...
            'Backgroundcolor',bgc,...
            'Callback', @export);
        
        exportAllChk = uicontrol('Visible','off','Style', 'checkbox', 'String','Export All',...
            'Position', [355 20 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
            'CallBack',@exportAllToggle);
        
        levelUpBtn = uicontrol('Visible','off','Style', 'pushbutton', 'String', 'Up',...
            'Position', [5+50+50+50 20+20 50 20],...
            'Backgroundcolor',bgc,...
            'Callback', @levelUp);
        levelDownBtn = uicontrol('Visible','off','Style', 'pushbutton', 'String', 'Down',...
            'Position', [5+50+50+50 20-20 50 20],...
            'Backgroundcolor',bgc,...
            'Callback', @levelDown);
        
        seeWellBtn = uicontrol('Visible','off','Style', 'pushbutton', 'String', 'See Well',...
            'Position', [5+50+50+50 20 50 20],...
            'Backgroundcolor',bgc,...
            'Callback', @getWell);
        
    end

    function keyPress(src, e)
        %disp(e.Key);
        switch e.Key
            case 'escape'
                disp('SeeTrace Disabled');
                STToggle = 0;
            case 's'
                seeTrace();
            case 'h'
                hideButtons();
            case 'a'
                doOpenFiles();
        end
    end

    function setBackgroundImage(src, e)
        backgroundImageSelection = backgroundImageBtn.String{...
            backgroundImageBtn.Value};
        
        % Load the mask
        gg=strfind(plateFilename2,'_');
        dd2=[plateFilename2(1:gg(end)-1)];
        mask = imread([plateDir '..\..\' dd2 '.tif_mask.png']);
        
        
        % Load the avg
        try
            wellAvg = imread([plateDir '..\..\..\commonOutput\avg\' dd2 '.tif_avg.png']);
        catch
            warning(['No average projection found in: ' plateDir dd2]);
            %text(['No average projection found in: ' plateDir dd2]);
        end
        updatePlot(); 
    end

    function doAddDataCommand(f,r,e)
        eval(AddDataCommandEdt.String);
          selectionOptions=data{1}.Properties.VariableNames;
        for i=1:length(selectionOptions)
            selectionOptions{i}=OKname2text(selectionOptions{i});
        end
            stimLstX.String=[selectionOptions, {'fileName'}];
            stimLstY.String=[selectionOptions, {'fileName'}];
            filterFieldLst.String=[selectionOptions, {'fileName'}];
    end

    function addFile(src, e)
        [plateFilename2, plateDir2] = uigetfile('*.txt',['Select data File'],[plateDir '\'],'MultiSelect','off');
        if plateFilename2~=0 % When you press cancel
        defaultDir = plateDir;
        [relPath1, relBaseFile, commonBasePath2, dotPath] = ...
            calcRelativePath([plateDir2 plateFilename2],plateDir);
        
        if  1 % Prepend relatve path to new file
            plateFilename{end+1}=[dotPath relPath1];
        else % Change all paths to common path base
            plateDir=commonBasePath2;
            for i=1:length(plateFilename)
                plateFilename{i}=[plateFilename{i} relBaseFile];
            end
            plateFilename{end+1}=[relPath1];
        end
        
        openFiles(plateFilename,plateDir);
        end
    end

showButtons=1;
    function hideButtons(T)
        if exist('T','var')
            showButtons=T;
        else
            showButtons=~showButtons;
        end
        if showButtons
            visTExt = 'off';
            disp('Press h to unhide buttons.')
        else
             visTExt = 'on';
        end
        logXChk.Visible=visTExt;
        logYChk.Visible=visTExt;
        markerSelectionBtn.Visible=visTExt; 
        seeTraceBtn.Visible=visTExt; 
        AddDataCommandEdt.Visible=visTExt; 
        AddDataCommandBtn.Visible=visTExt; 
        lineSizeBtn.Visible=visTExt; 
        LineStyleBtn.Visible=visTExt;
        backgroundImageBtn.Visible=visTExt;
        
        openFilesBtn.Visible=visTExt;
         
        stimLstX.Visible=visTExt; 
        stimLstY.Visible=visTExt; 
        filterFieldLst.Visible=visTExt; 
        lessMoreLst.Visible=visTExt; 
        filterThresholdEdt.Visible=visTExt; 
        filterThresholdEdt.Visible=visTExt;
        doFilterBtn.Visible=visTExt; 
        HistBtn.Visible=visTExt; 
        levelDownBtn.Visible=visTExt; 
        levelUpBtn.Visible=visTExt; 
        exportAllChk.Visible=visTExt;
        ExportBtn.Visible=visTExt;  
        fitBtn.Visible=visTExt; 
        seeWellBtn.Visible=visTExt; 
        wowChkBtn.Visible=visTExt;
        addFileBtn.Visible = visTExt; 
        Xtxt.Visible = visTExt; 
        Ytxt.Visible = visTExt; 
        useXlabelChk.Visible = visTExt;
        jitterChk.Visible = visTExt;
        
    end
    function wowToggle(e,d,r)
        wow=wowChkBtn.Value;
    end
    function logXToggle(e,d,r)
        logX=logXChk.Value;
        if logX==1
            dd=gca();
            set(dd,'XSCale','Log');
        else
            dd=gca();
            set(dd,'XSCale','Linear');
        end
        updatePlot();
    end
    function useXlabelToggle(e,d,r)
        useXlabels=useXlabelChk.Value;
        updatePlot();
    end
function jitterToggle(e,d,r)
        addJitter=jitterChk.Value;
        updatePlot();
    end

    function logYToggle(e,d,r)
        logY=logYChk.Value;
        if logY==1
            dd=gca();
            set(dd,'YSCale','Log');
        else
            dd=gca();
            set(dd,'YSCale','Linear');
        end
        updatePlot();
    end

    function levelDown(d,f,e)
         switch currentLevel
            case 'synapseLevel'
                % Open Well data
                
                disp('This is the bottom Level')
                currentLevel='synapseLevel';
            case 'wellLevel'
                % Open a specific well of the plate, show synapses
                %Do the magic function:
                getWell();
%                 k=strfind(plateDir,'\'); %find parent directory
%                 plateDir=plateDir(1:k(end-1));
%                 fn = [plateFilename{1}(1:end-13) '_analysis.txt' ];
%                 openFiles(fn,plateDir);
                
                currentLevel='synapseLevel';
            case 'plateLevel'
                % Open all individual wells
                 tt = dir([plateDir '*_analysis.txt']);
                openFiles({tt.name},plateDir);
                currentLevel='wellLevel';
            case 'experimentLevel'
                % Open a specific plate of the experiment
                openFiles({'AllWells.txt'},plateDir);
                currentLevel='plateLevel';
             case 'multi-experimentLevel'
                 currentLevel='experimentLevel'
        end
    
     
 end
    function levelUp(d,f,e)
        switch currentLevel
            case 'synapseLevel'
                % Open Well data
                k=strfind(plateDir,'SynapseDetails\'); %find parent directory
                plateDir=plateDir(1:(k(1)-1));
                
                fn=strrep(plateFilename{1},'_PPsynapses','_synapses');
                fn = [fn(1:end-13) '_analysis.txt' ];
               
                openFiles(fn,plateDir);
                currentLevel='wellLevel';
            case 'wellLevel'
                % Open all wells of the plate
                tt = dir([plateDir '*_analysis.txt']);
                openFiles({tt.name},plateDir)
                currentLevel='plateLevel';
            case 'plateLevel'
                % Open summary of the plate
                openFiles({'AllWells.txt'},plateDir);
                currentLevel='experimentLevel';
            case 'experimentLevel'
                % Open summary of the experiment
                
                currentLevel='multi-experimentLevel';
            case 'multi-experimentLevel'
                disp('This is the top level for now')
                currentLevel='multi-experimentLevel';
        end
        
     
        
    end
    function getWell(d,f,e)
        dd=detailFilename;
        dd = [dd(1:end-12) 'synapses.txt'];
        
        plateDir = [plateDir 'SynapseDetails\'];
        openFiles(dd,plateDir);
        
        plateFilename=[];
        plateFilename{1} = dd;
        
        %updatePlot();
    end
    function setmarker(d,f,e)
        marker = markerSelectionBtn.String{markerSelectionBtn.Value};
        updatePlot();
    end
    function setLineSize(d,f,e)
        lineSize = str2num(lineSizeBtn.String{lineSizeBtn.Value});
        updatePlot();
    end
    function setLineStyle(d,f,e)
        LineStyle = LineStyleBtn.String{LineStyleBtn.Value};
        updatePlot();
    end

    function seeWell(relPath,synNbr)
        % relPath to _synapses or _PPsynapes file
        subplot(4,4,1)
        relPath=strrep(relPath,'_PPsynapses','_synapses');
        [tempFFn, tempDirFn]=getFN(relPath);
            
        dd2 = [tempDirFn '..\..\' tempFFn(1:end-13) '.tif_mask.png'];
        if ~exist([plateDir dd2],'file')
            dd2 = [tempDirFn '..\' tempFFn(1:end-13) '.tif_mask.png'];
        end
        
        mask = imread([plateDir dd2]);
        [wy, wx] = size(mask);
        synregio = loadMask([plateDir dd2]);
        activeSynapse=zeros(wy,wx);
        if ~isempty(synregio)
            activeSynapse(synregio(synNbr).PixelIdxList)=1;
        end
        
        mask=double(mask)+activeSynapse*100000;
        imagesc(mask);
        title(dd2,'Interpreter','none')
        axis('off');axis ('equal');colormap('hot');
        
        subplot(4,4,[9,13]);  
         dd2 = [tempDirFn '..\..\' tempFFn(1:end-13) '.tif_avg.png'];
        if ~exist([plateDir dd2],'file')
            dd2 = [tempDirFn '..\' tempFFn(1:end-13) '.tif_avg.png'];
        end
        if ~exist([plateDir dd2],'file')
            dd2 = [tempDirFn '..\..\output\avg\' tempFFn(1:end-13) '.tif_avg.png'];
        end
        if ~exist([plateDir dd2],'file')
            dd2 = [tempDirFn '..\..\..\output\avg\' tempFFn(1:end-13) '.tif_avg.png'];
        end

        wellAvg = 200*ones(512);
        try
            wellAvg = imread([plateDir dd2]);
        catch
            warning(['No average projection found in: ' plateDir dd2]);
            %text(['No average projection found in: ' plateDir dd2]);
        end

        imagesc(double(wellAvg)+activeSynapse*100);
        axis('off');axis ('equal');colormap('hot');
        %avgAx=gca();
        %avgAx.Position=avgAx.Position + [-.10 -0.15 .15 .15];
        
    end
    function  [currentDataX,currentDataY] = makeRenderData(i)
        animValue=0; af=0; oldX=0; oldY=0;
        lwow=0; %local wow
        [currentDataX, currentDataY,~,~]=makeRenderData2(i,animValue,af,oldX, oldY, lwow);
        
%         
%         if strcmp(stimLstX.String(stimLstX.Value),'fileName') % Special case: selection of fileName.
%             currentDataX = i + pseudoRandom(length(data{i}.(text2OKname(stimLstY.String{stimLstY.Value}))));%1:size(plateFilename,2);
%         else
%             if length(stimLstX.Value)==1
%                 currentDataX = data{i}.(text2OKname(stimLstX.String{stimLstX.Value}));
%             else % Multiple select
%                 for ms=1:length(stimLstX.Value)
%                     currentDataX(:,ms) = data{i}.(text2OKname(stimLstX.String{stimLstX.Value(ms)}));
%                 end
%             end
%         end
%         
%         if length(stimLstY.Value)==1
%             currentDataY =data{i}.(text2OKname(stimLstY.String{stimLstY.Value}));
%         else % Multiple select
%             for ms=1:length(stimLstY.Value)
%                 currentDataY(:,ms) = data{i}.(text2OKname(stimLstY.String{stimLstY.Value(ms)}));
%             end
%         end
    end

    function [currentDataX, currentDataY,xlabelText,XTL]=makeRenderData2(i,animValue,af,oldX, oldY, lwow)
    % OLD code: y{i}=currentDataY; x{i}=currentDataX
        if ~strcmp(stimLstX.String(stimLstX.Value),'fileName')
            if ~lwow % Normal case/ geen animatie
                if length(stimLstX.Value)==1 % Single selection
                    ppp=data{i}.(text2OKname(stimLstX.String{stimLstX.Value}));
                    currentDataX=ppp(:); % To make sure this is a collumn
                    XTL=(text2OKname(stimLstX.String{stimLstX.Value}));
                else % Multiple select
                    XTL=[]; % Multiple selection: X Tick Labels
                    for ms=1:length(stimLstX.Value)
                        if useXlabels
                            currentDataX(:,ms)=(ms-1)+0*data{i}.(text2OKname(stimLstX.String{stimLstX.Value(ms)}));
                            XTL{ms}=text2OKname(stimLstX.String{stimLstX.Value(ms)});
                        else % Use x values for correlations
                            currentDataX(:,ms)=data{i}.(text2OKname(stimLstX.String{stimLstX.Value(ms)}));
                        end
                    end
                    
                end
            else % Animation case
                XTL=[];%temp hack, to supress error
                % tempX=data{i}.(stimLstX.Value);
                tempX=data{i}.(text2OKname(stimLstX.String{stimLstX.Value}));
                if exist('oldX','var')
                    try
                        ppp=tempX+animValue(af)*(oldX{i}(:)-tempX);
                        currentDataX=ppp(:);
                    catch
                        
                        try
                            currentDataX=zeros(size(tempX));
                        catch
                            x=[];
                            warning('error in animation!');
                        end
                        currentDataX=tempX(:);
                    end
                else
                    currentDataX=tempX(:);
                end
            end
            xlabelText = stimLstX.String(stimLstX.Value);
        else % Special selection: fileName
            %x{i}(:)=i + rand(length(data{i}.(stimLstY.Value)),1)*0.5;%1:size(plateFilename,2);
            x=[];
            ppp=i + pseudoRandom(length(data{i}.(text2OKname(stimLstY.String{stimLstY.Value}))));%1:size(plateFilename,2);
            currentDataX=ppp(:);
            xlabelText = 'File Name';
        end
        if ~lwow
            if length(stimLstY.Value)==1
                %y{i}(:)=data{i}.(stimLstY.Value);
                ppp=data{i}.(text2OKname(stimLstY.String{stimLstY.Value}));
                currentDataY=ppp(:);
            else %multiple things selected
                for ms=1:length(stimLstY.Value)
                    %y{i}(:,ms)=data{i}.(stimLstY.Value(ms));
                    currentDataY(:,ms)=data{i}.(text2OKname(stimLstY.String{stimLstY.Value(ms)}));
               end
            end
            
        else % Animation
            tempY=data{i}.(text2OKname(stimLstY.String{stimLstY.Value}));
            if exist('oldY','var')
                try
                    ppp=tempY+animValue(af)*(oldY{i}(:)-tempY);
                    currentDataY=ppp(:);
                catch e
                    try
                        currentDataY=zeros(size(tempY));
                    catch
                        y=[];
                        warning('error in animation!');
                    end
                    warning(e.message);
                    currentDataY=tempY(:);
                end
            else
                currentDataY=tempY(:);
            end
        end
    end

    function seeTrace(d,f,e)
        STToggle=~STToggle;
        while (STToggle) %See Trace Toggle
            STToggle=0;
            set(seeTraceBtn, 'Backgroundcolor',[.65 0.15 0.15]);
            [x, y]=ginput(1); % get mouse coordinates
            tmaxx =-inf;
            tminx=inf;
            
            tmaxy =-inf;
            tminy=inf;
            %% Find the synapse:
            %% Find the outer limits
            for (i=1:size(plateFilename,2)) % For all loaded files
                [currentDataX,currentDataY]=makeRenderData(i);
                
                % Find overall max and min.
                tmaxx = max([tmaxx max(currentDataX)]);
                tminx = min([tminx min(currentDataX)]);
                
                tmaxy = max([tmaxy max(currentDataY)]);
                tminy = min([tminy min(currentDataY)]);
            end
            
            dx=tmaxx-tminx;
            dy=tmaxy-tminy;
            
            %% Find the File, synapseNumber, ... closest to the mouse cursor:
            for (i=1:size(plateFilename,2)) % For all loaded files
                   [currentDataX,currentDataY]=makeRenderData(i);
                 try
                    distances=(((x-currentDataX)/dx).^2 + ((y-currentDataY)/dy).^2); %distance matrix: horizontal=multiple selections, vertical = multiple files
                    if size(distances,2)>1 % when multiple selections, rows are from the same file, so search for min distance of each file 
                        distances=min(distances,[],2);
                    end
                    [m(i), mi(i)]=min(distances);
                catch
                    m(i) = inf; mi(i)=inf;
                end
            end
            [~, fi]=min(m); %fi: file index
            
            currentFile = fi;
            tmi =mi(fi); %tmi: total minima index
            
            if any(strcmp('synapseNbr',fieldnames(data{fi})))  % check if well or plate level
                %% At Synapse or AllSynapse level.
                
                % showSynapse
                
                syNbr = data{fi}.synapseNbr(tmi);
                [currentDataX,currentDataY]=makeRenderData(i);
                   
%                     currentDataX =data{fi}.(stimLstX.Value);
%                 end
                %           currentDataX =data{fi}.(stimLstX.Value);
%                 currentDataY =data{fi}.(stimLstY.Value);
                
                %[responseFile, responsePath]=uigetfile('*.csv');
                %responses = csvread([responsePath responseFile]);
                
                tempPlateFilename = plateFilename{fi};
                [tTempPlateFilename, relDirPath]= getFN(tempPlateFilename);
                if strcmp(tTempPlateFilename,'AllSynapses.txt')
                    % Find the appropriate _synTraces.csv file
                    
                    tPlateDir=[plateDir relDirPath];
                    
                    tempFilenb=data{fi}.FileNumber(tmi);
                    
                    analysisList= dir([tPlateDir 'SynapseDetails\*_PPsynapses.*']);
                    fileNumbers=extractNumber({analysisList.name});
                    [a]=find(tempFilenb==fileNumbers);
                    if length(a)~=1
                        disp(['problem tempFilenb: ' num2str(tempFilenb)]);
                        error('more or no files with same id number, please rename files to _e0001 numbering system');
                        
                    end
                    tempPlateFilename=[relDirPath 'SynapseDetails\' analysisList(a).name];
                end
                
                tempTraceFilename=strrep(tempPlateFilename,'_PPsynapses','_synapses'); % To work for _PPsynapses as well.
                tempTraceFilename=strrep(tempTraceFilename,'_synapses','_synTraces'); % To work with _synapes.txt and _synapes.csv 
                tempTraceFilename = [ tempTraceFilename(1:end-3) 'csv'];
                
                %% Read the responses
                try
                    responses = table2array(readtable([plateDir tempTraceFilename]));
                catch % Legacy 2018
                    warning('using _synapses.csv files is old file naming, please rename files to _synTraces.csv');
                    tFn = [tempTraceFilename(1:end-13) 'synapses.csv'];
                    responses = table2array(readtable([plateDir tFn]));
                end
                time=responses (:,1);
                responses =responses (:,2:end)';
                
                hold on; plot(currentDataX(tmi),currentDataY(tmi),'*r'); % Show red marker on data point.
                subplot(4,4,5)
                hold off;
                plot(time,responses (syNbr,:)); % Plot the synapse response
                
            else % We are at well level.
                %wellNbr = data{fi}.FileNumber(tmi);
                detailFilename =plateFilename{fi};
                dd=plateFilename{fi};
                [tTempPlateFilename, relDirPath]= getFN(dd);
                tPlateDir=[plateDir relDirPath];
               
            
                if strcmp(tTempPlateFilename,'AllWells.txt')
                    tempFilenb=data{fi}.FileNumber(tmi);
                    analysisList= dir([tPlateDir '*_Analysis.*']);
                    fileNumbers=extractNumber({analysisList.name});
                    [a]=find(tempFilenb==fileNumbers);
                    if length(a)~=1
                        error('more files with same id number, please rename files to _e0001 numbering system');
                    end
                    tempPlateFilename=[analysisList(a).name];
                    dd=tempPlateFilename;
                end
               
                dd = [dd(1:end-12) 'synTraces.csv'];
                try
                    responses = table2array(readtable([tPlateDir 'synapseDetails\'  dd]));
                catch
                    warning('No synTraces.csv file found, trying _synapses.csv.');
                    warning('using _synapses.csv files is old file naming, please rename files to _synTraces.csv');
                    dd = [dd(1:end-13) 'synapses.csv'];
                    responses = table2array(readtable([tPlateDir 'synapseDetails\'  dd]));
                end
                time=responses (:,1);
                responses =responses (:,2:end)';
                
                %    responses = csvread([plateDir dd]);
                subplot(4,4,5)
                hold off;
                plot(time,responses (:,:)','Color',[0.5 0.5 0.5]);
                hold on;
                plot(time,mean(responses (:,:)),'k','LineWidth',4);
                syNbr=1;
                
                
            end
            
            xlabel('time'); ylabel('\Delta f/f')
            
            %% Call seeWell
            if (contains(plateFilename{fi},'AllSynapses.txt'))
                seeWell(tempPlateFilename,syNbr);
            else
                if (strcmp(plateFilename{fi},'AllWells.txt'))
                    seeWell(tempPlateFilename,syNbr);
                else
                    try
                        seeWell(plateFilename{fi},syNbr);
                    catch
                        disp(['problem with ' plateFilename{fi}]);
                        seeWell(plateFilename{fi},syNbr);
                    end
                end
            end
            updatePlot();
        end
        set(seeTraceBtn, 'Backgroundcolor',bgc); %Color SeeTrace Button
    end


    function r=pseudoRandom(n,m)
        if nargin >1
        r = repmat(mod((1:n)*6.3,5)'/10,1,m);
        else
        r = mod((1:n)*6.3,5)'/10;
        end
    end
    function doOpenFiles(d,f,e)
       
        [plateFilename, plateDir] = uigetfile({'*.txt', 'Analysis File';...
            '*.csv', 'Trace File' ...
            ;'*_traces.csv' 'Well Avg Trace';...
            '**_synTraces.csv' 'Synapse Trace';...
            '*_RawSynTraces.csv' 'Raw Synapse Traces';...
            '*.*' '(*.*) All files'...
            },['Select data File'],[defaultDir '\'],'MultiSelect','on');
      
        openFiles(plateFilename,plateDir);
        hideButtons();%
    end
    function openFiles(plateFilename2,plateDir)
         if ~exist('defaultDir','var')
            defaultDir='';
         end
        defaultDir = plateDir;
        currentFile = 1;
        eigData=0;
        dirTxt.String=[plateDir plateFilename2];
        if ~iscell(plateFilename2)
            a=plateFilename2;
            plateFilename=[];
            plateFilename{1}=a;
        else
            plateFilename = plateFilename2;
        end
        
        if (length(plateFilename{1})>13)
            if strcmp(plateFilename{1}(end-12:end),'_synapses.txt')
                currentLevel='synapseLevel';
            end
            if strcmp(plateFilename{1}(end-14:end),'_PPsynapses.txt')
                currentLevel='synapseLevel';
            end
            if strcmp(plateFilename{1}(end-12:end),'_analysis.txt')
                currentLevel='wellLevel';
            end
        end
        if strcmp(plateFilename{1}(1:end),'AllWells.txt')
            currentLevel='plateLevel';
        end
        if strcmp(plateFilename{1}(1:end),'AllSynapses.txt')
            currentLevel='plateLevel';
        end
        if length(plateFilename{1})>10
            if (~isempty(strfind(plateFilename{1}(end-10:end),'_eig'))) && (strcmp(plateFilename{1}(end-3:end),'.csv'))
                currentLevel='wellLevel';
                eigData = 1;
            end
        end
        
        if ~eigData
            data=[];
            for (i=1:size(plateFilename,2))
                hold off;
                data{i} = readtable([plateDir plateFilename{i}]);
            end
        else %is eigdata
            data=[];
            selectionOptions=[];
            for (i=1:size(plateFilename,2))
                hold off;
                r(:,i) = csvread([plateDir plateFilename{i}]);
                selectionOptions{i}=text2OKname(plateFilename{i});
            end
            data{1} = array2table([(1:size(r,1))' r],'VariableNames',{ 'sampleNR', selectionOptions{:}});
            t= plateFilename{1};% Make 1 platefilename of selection of files.
            plateFilename=[];
            plateFilename{1}=t; % Make 1 platefilename of selection of files.
            
        end
                
        selectionOptions=data{1}.Properties.VariableNames;
        for i=1:length(selectionOptions)
            selectionOptions{i}=OKname2text(selectionOptions{i});
        end
        
        stimLstX.Value=1;
        stimLstY.Value=1;
        filterFieldLst.Value=1;
        stimLstX.String=[selectionOptions, {'fileName'}];
        stimLstY.String=[selectionOptions, {'fileName'}];
        filterFieldLst.String=[selectionOptions, {'fileName'}];
    end

    function export(d,f,e)
        exporttt=~exporttt;
        updatePlot();
    end
    function exportAllToggle(d,f,e)
        exportAll = exportAllChk.Value;
    end

    function filterData(d,f,e)
        filterField = text2OKname(filterFieldLst.String{filterFieldLst.Value});
        filterThreshold = str2num(filterThresholdEdt.String);
        for  i = 1:length(data)
            switch lessMoreLst.Value
                case 1 %Is LESS Than
                removeSelection = ((data{i}.(filterField))>filterThreshold);
                case 2
                removeSelection = ((data{i}.(filterField))<filterThreshold);
                case 3 % Equals
                    if isnan(filterThreshold)
                        removeSelection = ~isnan(((data{i}.(filterField))));
                    else
                        removeSelection = ((data{i}.(filterField))~=filterThreshold);
                    end
                case 4 % Equals Not
                    if isnan(filterThreshold)
                        removeSelection = isnan(((data{i}.(filterField))));
                    else
                    removeSelection = ((data{i}.(filterField))==filterThreshold);
                    end
                    
                    
            end
            disp([num2str(sum(removeSelection)) ' points removed']);
            data{i}(removeSelection,:)=[];
            if isempty(data{i})
            %    data{i}=[];
            end
        end
        updatePlot();
    end
global x y useXlabels addJitter;
useXlabels = 0;
addJitter = 0;
    function updatePlot(e,g,h)
        
        subplot(4,4,[2:3,6:7,10:11,14:15])
        if wow
            animationNumber=50;
            animValue=[1:50]/animationNumber;
            animValue=[(tanh(linspace(-pi,pi,animationNumber))+1)/2];
            animValue=1-animValue;
            oab=axis();
        else
            animationNumber=1;
            animValue=0;
        end
        for af=1:animationNumber
            hold off;
            switch backgroundImageSelection
                case 'none'
                case 'avg'
                    imagesc(wellAvg);colormap('gray');
                    hold on;
                case 'mask'
                    imagesc(mask);colormap('gray');
                    hold on;
            end
            
            if ~wow
                x=[];y=[];
            end
            %[xd, yd] =  makeRenderData(i);
            
            for (i=1:size(plateFilename,2))
                
                [currentDataX, currentDataY, xlabelText,XTL]=makeRenderData2(i,animValue,af,x, y, wow);
                x{i}=currentDataX;
                y{i}=currentDataY;
                
                barplot=0;
                if barplot
                    bar(x{i},y{i});
                else % No barPlot
                    xnoise=0;rand(size(x{i})).*0.2-0.1;
                    %  plot(x{i}+xnoise,y{i},'Marker',marker,'LineWidth',lineSize,'LineStyle', LineStyle );
                    
                    if logX
                        if useXlabels
                            L=(i-1)*.3; %Shift between files
                        else
                            L=0;
                        end
                        if addJitter
                            xnoise=pseudoRandom(size(x{i}))*.10-0.05;
                        else % No jitter
                            xnoise=pseudoRandom(size(x{i}))*0;
                        end
                        plot(x{i}.*(1+xnoise+L),y{i},'Marker',marker,'LineWidth',lineSize,'LineStyle', LineStyle )
                    else
                        if addJitter
                            xnoise=pseudoRandom(size(x{i},1),size(x{i},2))*0.09;
                        else % No jitter
                            xnoise=pseudoRandom(size(x{i},1),size(x{i},2))*0;
                        end
                        % The real plot command:
                        plot(x{i}+xnoise,y{i},'Marker',marker,'LineWidth',lineSize,'LineStyle', LineStyle );
                    end
                    hold on;
                    if useXlabels
                        xticklabels(XTL);
                        xticks(0:(length(XTL)-1))
                    end
                    
                    %% Plot a piecewise fit.
                    if (fittt==1)
                        pp=x{i};
                        pp(isnan(x{i}))=[]; %remove NaN
                        xcats=unique(pp);
                        yy=y{i};
                        xx=x{i};
                        dx=max(max(x{i}))-min(min(x{i}));
                        if dx==0
                            dx=3;
                        end
                        
                        for i3=1:length(xcats) % For all unique X values
                            if useXlabels
                                sel = yy(~isnan(xx(:,i3)));
                            else
                                sel = yy(xcats(i3)==xx);
                            end
                            msel=mean(sel);
                            msell(i3)=msel;
                            P95=0;% Show P95% S.E.M.
                            if P95
                                ssel=std(sel)/sqrt(length(sel))*1.96;
                            else % Show STD
                                ssel=std(sel);%
                            end
                            if logX
                                h=plot([xcats(i3)*(1-1/dx+L),xcats(i3)*(1-1/dx+L),xcats(i3)*(1+1/dx+L),xcats(i3)*(1+1/dx+L),xcats(i3)*(1+1/dx+L),xcats(i3)*(1-1/dx+L)],[msel-ssel,msel+ssel,msel+ssel,msel-ssel,msel-ssel,msel-ssel],'b','LineWidth',lineSize)
                                set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
                                h=plot([xcats(i3)*(1-1/dx+L),xcats(i3)*(1+1/dx+L)],[msel,msel],'r','LineWidth',lineSize);
                                set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
                                if P95
                                    text(xcats(i3)*(1-1/dx+L),msel+ssel*1.3,'SEM:95%');
                                else
                                    % text(xcats(i3)*(1-1/dx+L),msel+ssel*1.3,'St.Dev.');
                                end
                            else % linear X, not logX
                                plot([xcats(i3)-1/dx,xcats(i3)-1/dx,xcats(i3)+1/dx,xcats(i3)+1/dx,xcats(i3)+1/dx,xcats(i3)-1/dx],...
                                    [msel-ssel,msel+ssel,msel+ssel,msel-ssel,msel-ssel,msel-ssel]...
                                    ,'b','LineWidth',lineSize); %Draw box
                                plot([xcats(i3)-1/dx,xcats(i3)+1/dx],[msel,msel],'r','LineWidth',lineSize); %Draw mean line
                                if P95
                                    text(xcats(i3)-1/dx,msel+ssel*1.3,'SEM:95%');
                                else
                                    %text(xcats(i3)-1/dx,msel+ssel*1.3,'St.Dev.');
                                end
                            end
                            %plot([xcats(i3),xcats(i3)],[msel-ssel,msel+ssel],'r','LineWidth',lineSize)
                            %     boxplot([xcats(i3),xcats(i3)],[msel-ssel,msel+ssel]);%,'r','LineWidth',lineSize)
                        end
                        % boxplot(xx,yy);%,'r','LineWidth',lineSize)
                        h= plot(xcats,msell,'k','LineWidth',lineSize); %Draw black connection line
                        set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
                    end
                end
            end
            
            ca=gca();
            
            ylabelText = stimLstY.String(stimLstY.Value);
            if exporttt
                t=[];
                for (i=1:size(plateFilename,2))
                    t= [t;x{i}(:) y{i}(:) ones(length(y{i}(:)),1)*i];
                end
                if (~exportAll)
                    tt = array2table(t,'VariableNames',{text2OKname(xlabelText{1}) text2OKname(ylabelText{1}) 'color'});
                else
                    tt = data{i};
                end
                
                [filename, pathname] = uiputfile([plateDir 'analysis_data.csv'], 'Export to file ...');
                exporttt = 0;
                writetable(tt,[pathname filename]);
                
            end
            if histtt
                updateHist(y{currentFile},ca,currentFile);
            else % No Histogram/ clear histogram
                subplot(4,4,[4,8,12,16])
                cla;
                aa =gca();
                aa.Visible='off';
                subplot(4,4,[2:3,6:7,10:11,14:15]);
            end
            if ~useXlabels
                xlabel(OKname2text(xlabelText),'FontName','Helvetica','FontSize',18);
            end
            ylabel(OKname2text(ylabelText),'FontName','Helvetica','FontSize',18);
            if logX==1
                set(ca,'XSCale','Log');
            end
            if logY==1
                set(ca,'YSCale','Log');
            end
            if (ca.XLim ==[0 1])
                ca.XLim =[-0.2 1.2];
            end
            if wow
                axis(oab); %
                drawnow();
                %disp(af);
                pause(.05);
            end
            %        for i=1:length()
            %leg{}=leg{};
            %        end
            
            legend(plateFilename);
        end
    end

    function fitt(f,e,g)
        fittt=~fittt;
        updatePlot();
        
    end
    function histt(f,e,g)
        histtt=~histtt;
        updatePlot();
    end

    function updateHist(hdata,ca,colorsNum)
        % Plots 1 or more histograms on the right side of the plot area.
        subplot(4,4,[4,8,12,16])
        
        %histogram(y{i},100,min(x{i})+(1:100)*dx/100,'orientation','horizontal');
        colors = [...
            0       0.45	0.74;...
            0.85	0.33	0.1;...
            0.93	0.69	0.13;...
            0.49    0.18    0.59;...
            0.47    0.67    0.19;...
            0.3     0.75    0.93;...
            0.64    0.08    0.18;...
            0       0.45    0.74
            ];
        if size(hdata,1)==1
            histogram(hdata,100,'orientation','horizontal','BinLimits',[ca.YLim(1),ca.YLim(2)],'FaceColor',colors(mod(colorsNum-1,8)+1,:));
        else
            for i=1:size(hdata,2)
                histogram(hdata(:,i),100,'orientation','horizontal','BinLimits',[ca.YLim(1),ca.YLim(2)],'FaceColor',colors(mod(colorsNum-1+i-1,8)+1,:));
                hold on;
            end
        end
    
        aa = gca();
        cap = ca.Position;
        
        aa.Position(1) = cap(1)+cap(3);
        my = mean(hdata);
        stdy = std(hdata);
        hold on;
        
        for jj=1:length(my) %For all selections
            plot([0 10],[my(jj), my(jj)] ,'k','linewidth',6);
            text(10,my(jj),num2str(my(jj)));
            plot([0 7],[my(jj)+stdy(jj), my(jj)+stdy(jj)] ,'r','linewidth',1);
            plot([0 7],[my(jj)-stdy(jj), my(jj)-stdy(jj)] ,'r','linewidth',1);
            text(8,my(jj)+stdy(jj)*.9,num2str(stdy(jj)),'Rotation',-90,'Color','red');
        end
        %plot([0, 20] ,[0 10],'k','lineWidth',6);
        aa.YLim = ca.YLim;
        aa.Visible='off';
        subplot(4,4,[2:3,6:7,10:11,14:15]);
        
    end
end