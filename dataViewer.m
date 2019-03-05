function dataViewer()
global plateFilename plateDir responses detailFilename defaultDir currentFile marker lineSize LineStyle;
global fittt histtt exporttt currentLevel STToggle seeTraceBtn exportAll selectionOptions; 
global exportAllChk openFilesBtn showButtons logX logY; 
global bgc
global seeWellBtn stimLstX stimLstY
global filterFieldLst lessMoreLst filterThresholdEdt markerSelectionBtn
global doFilterBtn HistBtn levelDownBtn levelUpBtn ExportBtn fitBtn
global lineSizeBtn LineStyleBtn logXChk logYChk wowChkBtn wow backgroundImageBtn backgroundImageSelection 
global addFileBtn

createButons();
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
            'Position', [5+50 (20) 50 20],...
            'Backgroundcolor',bgc,...
            'Callback', @addFile);
        
        doFilterBtn=[];
        filterThresholdEdt=[];
        filterFieldLst=[];
        lessMoreLst=[];
        
        javaFrame = get(f3,'JavaFrame');
        javaFrame.setFigureIcon(javax.swing.ImageIcon('PlateLayout_icon.png'));
        
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
        stimLstX = uicontrol('Style', 'popup', 'String', [{'fileName'}],...
            'Position', [10 60 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
            'Visible','off','CallBack',@updatePlot );     
        
%         stimLstY = uicontrol('Style', 'popup', 'String', [selectionOptions , {'fileName'}],...
%             'Position', [10 80 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
%             'Visible','off','CallBack',@updatePlot );
        stimLstY = uicontrol('Style', 'popup', 'String', [ {'fileName'}],...
            'Position', [10 80 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
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
        updatePlot(); 
    end


    function addFile(src, e)
        [plateFilename2, plateDir2] = uigetfile('*.txt',['Select data File'],[plateDir '\'],'MultiSelect','off');
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


global data;

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
                
                fn=strrep(plateFilename{1},'_PPSynapses','_synapses');
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
global wellAvg mask
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
        activeSynapse(synregio(synNbr).PixelIdxList)=1;
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

    function seeTrace(d,f,e)
        STToggle=~STToggle;
        while (STToggle)
            STToggle=0;
            set(seeTraceBtn, 'Backgroundcolor',[.65 0.15 0.15]);
            [x, y]=ginput(1);
            tmaxx =-inf;
            tminx=inf;
            
            tmaxy =-inf;
            tminy=inf;
            for (i=1:size(plateFilename,2))
                if strcmp(stimLstX.String(stimLstX.Value),'fileName')
                    currentDataX =i + pseudoRandom(length(data{i}.(stimLstY.Value)));%1:size(plateFilename,2);
                else
                    currentDataX =data{i}.(stimLstX.Value);
                end
                currentDataY =data{i}.(stimLstY.Value);
                tmaxx = max([tmaxx max(currentDataX)]);
                tminx = min([tminx min(currentDataX)]);
                
                tmaxy = max([tmaxy max(currentDataY)]);
                tminy = min([tminy min(currentDataY)]);
            end
            
            dx=tmaxx-tminx;
            dy=tmaxy-tminy;
            
            for (i=1:size(plateFilename,2))
                if strcmp(stimLstX.String(stimLstX.Value),'fileName')
                    currentDataX =i + pseudoRandom(length(data{i}.(stimLstY.Value)));%1:size(plateFilename,2);
                else
                    currentDataX =data{i}.(stimLstX.Value);
                end
                currentDataY =data{i}.(stimLstY.Value);
                try
                    [m(i), mi(i)]=min(sum([(x-currentDataX)/dx (y-currentDataY)/dy].^2,2));
                catch
                    m(i) = inf; mi(i)=inf;
                end
            end
            [~, fi]=min(m); %fi: file index
            
            currentFile = fi;
            tmi =mi(fi); %tmi: total minima index
            
            if any(strcmp('synapseNbr',fieldnames(data{fi})))  % check if well or plate level
                % At Synapse or AllSynapse level.
                
                syNbr = data{fi}.synapseNbr(tmi);
                if strcmp(stimLstX.String(stimLstX.Value),'fileName')
                    currentDataX =fi + pseudoRandom(length(data{fi}.(stimLstY.Value)));%1:size(plateFilename,2);
                else
                    currentDataX =data{fi}.(stimLstX.Value);
                end
                %           currentDataX =data{fi}.(stimLstX.Value);
                currentDataY =data{fi}.(stimLstY.Value);
                
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
                
                %%% Read the responses
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
                [tTempPlateFilename, relDirPath]= getFN(tempPlateFilename);
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


    function r=pseudoRandom(n)
        r = mod((1:n)*6.3,5)'/10;
    end
    function doOpenFiles(d,f,e)
        if ~exist('defaultDir','var')
            defaultDir='';
        end
        [plateFilename, plateDir] = uigetfile('*.txt',['Select data File'],[defaultDir '\'],'MultiSelect','on');
        defaultDir = plateDir;
        openFiles(plateFilename,plateDir);
        hideButtons();
    end
    function openFiles(plateFilename2,plateDir)
        currentFile = 1;
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
        data=[];
        for (i=1:size(plateFilename,2))
            hold off;
            data{i} = readtable([plateDir plateFilename{i}]);
        end
        %         for (i=1:size(plateFilename,2))
        %             x{i}(:)=data{i}.miASR;
        %             y{i}(:)=data{i}.peakAmp;
        %             subplot(1,2,2);
        %             plot(x{i},y{i},'.'), hold on;
        %         end
        
        selectionOptions=data{1}.Properties.VariableNames;
        for i=1:length(selectionOptions)
            selectionOptions{i}=OKname2text(selectionOptions{i});
        end
        
       
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
        filterField = filterFieldLst.String{filterFieldLst.Value};
        filterThreshold = str2num(filterThresholdEdt.String);
        for  i = 1:length(data)
            switch lessMoreLst.Value
                case 2
                selectionPoints = ((data{i}.(filterField))<filterThreshold);
                case 1
                selectionPoints = ((data{i}.(filterField))>filterThreshold);
                case 4  
                selectionPoints = ((data{i}.(filterField))==filterThreshold);
                case 3
                selectionPoints = ((data{i}.(filterField))~=filterThreshold);
            end
            disp([num2str(sum(selectionPoints)) ' points removed']);
            data{i}(selectionPoints,:)=[];
            if isempty(data{i})
            %    data{i}=[];
            end
        end
        updatePlot();
    end
global x y;
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
        for (i=1:size(plateFilename,2))
            if ~strcmp(stimLstX.String(stimLstX.Value),'fileName') 
                % Normal case
                if ~wow
                    x{i}(:)=data{i}.(stimLstX.Value);
                else
                    tempX=data{i}.(stimLstX.Value);
                    if exist('x','var')
                        try
                            x{i}(:)=tempX+animValue(af)*(x{i}(:)-tempX);
                        catch
                             
                             try
                                 x{i}=zeros(size(tempX));
                             catch
                                 x=[];
                                 warning('error in animation!');
                             end
                            x{i}(:)=tempX;
                        end
                    else
                        x{i}(:)=tempX;
                    end
                end
                xlabelText = stimLstX.String(stimLstX.Value);
            else %Special fileName Case
                %x{i}(:)=i + rand(length(data{i}.(stimLstY.Value)),1)*0.5;%1:size(plateFilename,2);
                 x=[];
                x{i}(:)=i + pseudoRandom(length(data{i}.(stimLstY.Value)));%1:size(plateFilename,2);
                xlabelText = 'File Name'; 
            end
            if ~wow
               
                y{i}(:)=data{i}.(stimLstY.Value);
            else
                tempY=data{i}.(stimLstY.Value);
                if exist('y','var')
                    try
                    y{i}(:)=tempY+animValue(af)*(y{i}(:)-tempY);
                    catch e
                        
                        try
                            y{i}=zeros(size(tempY));
                        catch
                            y=[];
                            warning('error in animation!');
                        end
                        warning(e.message);
                        y{i}(:)=tempY;
                    end
                else
                    y{i}(:)=tempY;
                end
            end
            
            barplot=0;
            if barplot
                bar(x{i},y{i});
            else
                xnoise=0;rand(size(x{i})).*0.2;
                
                plot(x{i}+xnoise,y{i},'Marker',marker,'LineWidth',lineSize,'LineStyle', LineStyle );
                if logX
                xnoise=rand(size(x{i}))*.2;
                plot(x{i}.*(1+xnoise),y{i},'Marker',marker,'LineWidth',lineSize,'LineStyle', LineStyle )
                end
                ,hold on;
                
              
                if (fittt==1) % Plot a piecewise fit
                    xcats=unique(x{i});
                    yy=y{i};
                    xx=x{i};
                    for i3=1:length(xcats)
                        sel =yy(xcats(i3)==xx);
                        msel=mean(sel);
                        msell(i3)=msel;
                        ssel=std(sel);
                        plot([xcats(i3),xcats(i3)],[msel-ssel,msel+ssel],'r','LineWidth',lineSize)
                    end
                   
                    plot(xcats,msell,'k','LineWidth',lineSize);            
                    %dx=max(x{i})-min(x{i});
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
                tt = array2table(t,'VariableNames',{xlabelText{1} ylabelText{1} 'color'});
            else
                tt = data{i};
            end
            [filename, pathname] = uiputfile('analysis_data.csv', 'Export to file ...');
                writetable(tt,[pathname filename]);
                exporttt=0;
        end
        if histtt
%             for i=1:size(y,2)
%                 updateHist(y{i},ca,i);
%                 hold on;
%             end
            updateHist(y{currentFile},ca,currentFile);
        else
            subplot(4,4,[4,8,12,16])
            cla;
            aa =gca();
            aa.Visible='off';
            subplot(4,4,[2:3,6:7,10:11,14:15]);
        end
        xlabel(OKname2text(xlabelText),'FontName','Helvetica','FontSize',18);
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
        histogram(hdata,100,'orientation','horizontal','BinLimits',[ca.YLim(1),ca.YLim(2)],'FaceColor',colors(mod(colorsNum-1,8)+1,:));
        aa = gca();
        cap = ca.Position;
        
        aa.Position(1) = cap(1)+cap(3);
        my = mean(hdata);
        stdy = std(hdata);
        hold on;
        
        plot([0 10],[my, my] ,'k','linewidth',6);
        text(10,my,num2str(my));
        plot([0 7],[my+stdy, my+stdy] ,'r','linewidth',1);
        plot([0 7],[my-stdy, my-stdy] ,'r','linewidth',1);
        text(8,my+stdy*.9,num2str(stdy),'Rotation',-90,'Color','red');
        %plot([0, 20] ,[0 10],'k','lineWidth',6);
        aa.YLim = ca.YLim;
        aa.Visible='off';
        subplot(4,4,[2:3,6:7,10:11,14:15]);
        
    end
end