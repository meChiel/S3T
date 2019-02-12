function dataViewer()
global plateFilename plateDir responses detailFilename defaultDir currentFile marker lineSize LineStyle;
global fittt histtt exporttt currentLevel STToggle seeTraceBtn exportAll selectionOptions; 
global exportAllChk openFilesBtn showButtons logX logY; 
global bgc
global seeWellBtn stimLstX stimLstY
global filterFieldLst lessMoreLst filterThresholdEdt markerSelectionBtn
global doFilterBtn HistBtn levelDownBtn levelUpBtn ExportBtn fitBtn
global lineSizeBtn LineStyleBtn logXChk logYChk 

createButons();
    function createButons()
        bgc=[0.5 0.5 0.5];
        STToggle=0;
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
        
        
        logYChk = uicontrol('Visible','off','Style', 'checkbox', 'String','Log Y',...
            'Position', [10 320 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
            'CallBack',@logYToggle);
        
        logXChk = uicontrol('Visible','off','Style', 'checkbox', 'String','Log X',...
            'Position', [10 300 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
            'CallBack',@logXToggle);
        
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
    function seeWell(tempFn,synNbr)
        subplot(4,4,1)
        tempFn=strrep(tempFn,'_PPsynapses','_synapses');
        dd2 = ['..\..\' tempFn(1:end-13) '.tif_mask.png'];
        if ~exist([plateDir dd2],'file')
            dd2 = ['..\' tempFn(1:end-13) '.tif_mask.png'];
        end
     
        mask = imread([plateDir dd2]);
        [wy, wx] = size(mask);
        synregio = loadMask([plateDir dd2]);
        activeSynapse=zeros(wy,wx);
        activeSynapse(synregio(synNbr).PixelIdxList)=1;
        mask=double(mask)+activeSynapse*100000;
        imagesc(mask);
        title(dd2)
        axis('off');axis ('equal');colormap('hot');
        
        subplot(4,4,[9,13]);  
         dd2 = ['..\..\' tempFn(1:end-13) '.tif_avg.png'];
        if ~exist([plateDir dd2],'file')
            dd2 = ['..\' tempFn(1:end-13) '.tif_avg.png'];
        end
        if ~exist([plateDir dd2],'file')
            dd2 = ['..\..\output\avg\' tempFn(1:end-13) '.tif_avg.png'];
        end
        if ~exist([plateDir dd2],'file')
            dd2 = ['..\..\..\output\avg\' tempFn(1:end-13) '.tif_avg.png'];
        end

        wellAvg = 200*ones(512);
        try
            wellAvg = imread([plateDir dd2]);
        catch
            disp(['No average projection found in: ' plateDir dd2]);
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
            set(seeTraceBtn, 'Backgroundcolor',bgc+[.2 -0.5 -0.5]);   
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
        if any(strcmp('synapseNbr',fieldnames(data{fi}))) % check if well or plate level
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
            %dd = ['../' dd(1:end-3) 'csv'];
          
         
if strcmp(tempPlateFilename,'AllSynapses.txt')
         tempFilenb=data{fi}.FileNumber(tmi);
         analysisList= dir([plateDir 'SynapseDetails\*_PPsynapses.*']);
         fileNumbers=extractNumber({analysisList.name});
         [a]=find(tempFilenb==fileNumbers);
         if length(a)~=1
             error('more files with same id number, please rename files to _e0001 numbering system');
         end
       tempPlateFilename=['SynapseDetails\' analysisList(a).name];
end
            tempFilename=strrep(tempPlateFilename,'_PPsynapses','_synapses');
            tempFilename=strrep(tempFilename,'_synapses','_synTraces');
            tempFilename = [ tempFilename(1:end-3) 'csv'];
            try
                responses = table2array(readtable([plateDir tempFilename]));
            catch
                warning('using _synapses.csv files is old file naming, please rename files to _synTraces.csv');
                tempFilename = [tempFilename(1:end-13) 'synapses.csv'];
                responses = table2array(readtable([plateDir tempFilename]));
            end
            time=responses (:,1);
            responses =responses (:,2:end)';
            
            hold on; plot(currentDataX(tmi),currentDataY(tmi),'*r')
            subplot(4,4,5)
            hold off;
            plot(time,responses (syNbr,:))
            
        else % We are at well level.
            %wellNbr = data{fi}.FileNumber(tmi);
            detailFilename =plateFilename{fi};
            dd=plateFilename{fi};
            
                     
if strcmp(dd,'AllWells.txt')
         tempFilenb=data{fi}.FileNumber(tmi);
         analysisList= dir([plateDir '*_Analysis.*']);
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
                responses = table2array(readtable([plateDir 'synapseDetails\'  dd]));
            catch
                warning('No synTraces.csv file found, trying _synapses.csv.');
                warning('using _synapses.csv files is old file naming, please rename files to _synTraces.csv');
                dd = [dd(1:end-13) 'synapses.csv'];
                responses = table2array(readtable([plateDir 'synapseDetails\'  dd]));
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
            
            
            seeWellBtn = uicontrol('Style', 'pushbutton', 'String', 'See Well',...
                'Position', [5+50+50+50 20 50 20],...
                'Backgroundcolor',bgc,...
                'Callback', @getWell);
             
        end
        xlabel('time'); ylabel('\Delta f/f')
      
            
        if (strcmp(plateFilename{fi},'AllSynapses.txt'))
            seeWell(tempPlateFilename(16:end),syNbr);
        else
            if (strcmp(plateFilename{fi},'AllWells.txt'))
                seeWell(tempPlateFilename,syNbr);
            else
                seeWell(plateFilename{fi},syNbr);
            end
        end
        updatePlot();
        end
        set(seeTraceBtn, 'Backgroundcolor',bgc);
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
    function updatePlot(e,g,h)
        subplot(4,4,[2:3,6:7,10:11,14:15])
        hold off;
        
        for (i=1:size(plateFilename,2))
            if ~strcmp(stimLstX.String(stimLstX.Value),'fileName')
                x{i}(:)=data{i}.(stimLstX.Value);
                xlabelText = stimLstX.String(stimLstX.Value);
            else
                %x{i}(:)=i + rand(length(data{i}.(stimLstY.Value)),1)*0.5;%1:size(plateFilename,2);
                x{i}(:)=i + pseudoRandom(length(data{i}.(stimLstY.Value)));%1:size(plateFilename,2);
                xlabelText = 'File Name'; 
            end
            y{i}(:)=data{i}.(stimLstY.Value);
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
                
              
                if (fittt==1)
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
            0.93	0.69	0.13...
            ];
        histogram(hdata,100,'orientation','horizontal','BinLimits',[ca.YLim(1),ca.YLim(2)],'FaceColor',colors(colorsNum,:));
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