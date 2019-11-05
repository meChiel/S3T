function [t,rootNode]=structViewer2(s,rootName,f,rootDir,uia,t,rootNode)
% The structviewer for the databaseViewer
% s =struct to view
% rootName: Name of the rootNode
% f is the uifigure handle, if not, a new figure will be created.
% If a dir is shown, the rootDir;
% t is an existing tree, if not a new tree is created
%
persistent currentPath
global tifViewMode2 currentAnalysis2 analysisLst2
tifViewMode2='mask';
currentAnalysis2  = 1;
global displayNodeFct2;
global isPlaying2;
global fr;
displayNodeFct2 = @displayNode;
currentNode = 0;


[fhandles]=segGUIV1([],1);
foldData = fhandles.foldData;


if nargin<3 % Create the uifigure.
      f = uifigure;
      openBtn = uibutton(f,'push','text','Open','Position',[468 130 100 20],'ButtonPushedFcn', @openDir);%(btn,event) refresh(btn,ax));
      excludeBtn = uibutton(f,'push','text','grey out','Position',[268 130 100 20],'ButtonPushedFcn', @greyOut);%(btn,event) refresh(btn,ax));
      unexcludeBtn = uibutton(f,'push','text','un-grey out','Position',[268 100 100 20],'ButtonPushedFcn', @ungreyOut);
 end
% try
%     disp(ctfroot);
% catch
%     disp(pwd);
% end
if nargin<2
    rootName='struct';
end
if nargin<6
    t = uitree(f,'Position',[20 150 550 550],'Multiselect','on');
    rootNode = uitreenode(t,'Text',rootName,'NodeData',[]);
else
    t = t;
    rootNode=rootNode;
end

try
    set(rootNode,'Icon',[ctfroot '\S3T\my_icon.png']);
catch
    set(rootNode,'Icon',['my_icon.png']);
end
if length(s)~=1
    s3=s;
    for pk=1:length(s3)
        s=s3(pk);
        rNode2{pk} = uitreenode(rootNode,'Text',[ OKname2text(rootName) ': ' '[' num2str(pk) ']'],'NodeData',[]);
        createStructFieldNodes(rNode2{pk},s,[OKname2text(rootName) ': ' num2str(pk)]);
    end
else
    createStructFieldNodes(rootNode,s,rootName);
    t.SelectionChangedFcn = @nodechange;
end

    function setMyIcon(node)
        try
            %set(parentNode,'Icon',[ctfroot '\S3T\unprocesssed_icon.png']);
            set(node,'Icon',[ctfroot '\S3T\my_icon.png']);
        catch
            % set(parentNode,'Icon',['unprocesssed_icon.png']);
            set(node,'Icon',['my_icon.png']);
        end
    end


    function setGreyIcon(node)
         try
            %set(parentNode,'Icon',[ctfroot '\S3T\unprocesssed_icon.png']);
            set(node,'Icon',[ctfroot '\S3T\grey_icon.png']);
        catch
            % set(parentNode,'Icon',['unprocesssed_icon.png']);
            set(node,'Icon',['grey_icon.png']);
         end
    end

    function setProcessedIcon(node)
        try
            set(node,'Icon',[ctfroot '\S3T\processsed_icon.png']);
        catch
            set(node,'Icon',['processsed_icon.png']);
        end
    end

    function greyOut(e,d,f)
        disp(['greyout: ' currentPath]);
        disp([currentPath ' should be greyed Out.']);
        psonFileName='gal2_Filter.pson';
        fr.greyOut{end+1}=currentPath;
        psonwrite(psonFileName,fr)
        setGreyIcon(currentNode);
    end

    function ungreyOut(e,d,f)
        disp(['ungrey: ' currentPath]);
        disp([currentPath ' should be ungreyed']);
        psonFileName='gal2_Filter.pson';
        for i=length(fr.greyOut):-1:1
            p = strcmp(fr.greyOut{i},currentPath);
            if p==1
                fr.greyOut(i)=[];
            end
        end
        psonwrite(psonFileName,fr)
       setProcessedIcon(currentNode);
    end

    function openDir(e,d,f)
        disp(['opening ' currentPath]);
        rr=strfind(currentPath,'\');
        projViewer(currentPath(1:rr(end)))
    end

    function createStructFieldNodes(parentNode,s2,fnj)%s2=s.(fn{j})
        % creates for each field in the struct a node
        % fnn=fieldnames(s.(fn{j}));
        fnn = fieldnames(s2);
        for i=1:(length(fnn))
            %if (isstruct(s.(fn{j})))
            if (isstruct(s2.(fnn{i}))) % There are still childs
                %L1Node{j,i} = uitreenode(rootTxtNode{j},'Text',fnn{i},'NodeData',[]);
                L1Node{i} = uitreenode(parentNode,'Text',OKname2text(fnn{i}),'NodeData',[]);
                if length(s2.(fnn{i}))~=1 % If more items
                    for kk=1:length(s2.(fnn{i})) % create for each element in the array a node
                        Node2{i,kk} = uitreenode(L1Node{i},'Text',[OKname2text(fnn{i}) '[' num2str(kk) ']'],'NodeData',[]);
                        % Create for each element in the struct a node.
                        createStructFieldNodes(Node2{i,kk},s2.(fnn{i})(kk),fnn{i});
                    end
                else % Single node: create for each element in the struct a node.
                    createStructFieldNodes( L1Node{i},s2.(fnn{i}),fnn{i})
                end
            else % This is the leave.
                if ~isExcluded(s2.(fnn{i}),fr) %Is it excluded?
                    if ~isGreyedOut(s2.(fnn{i}),fr) % Not Greyed Out?
                         showLeave(parentNode,s2.(fnn{i}),fnn{i})
                    else % Is greyed Out
                        leaveNode = uitreenode(parentNode,'Text',[OKname2text(fnn{i}) ': ' s2.(fnn{i})],'NodeData',[s2.(fnn{i})]);
                        setGreyIcon(parentNode);
                    end
                end
            end
        end
    end

    % If node is a leave, display the leave.
    function showLeave(parentNode,s2,fnj)%s2=s.(fn{j}),fn{j}
        try ctfroot()
        catch
            ctfroot=pwd;
        end
        if (isstr(s2))
            leaveNode = uitreenode(parentNode,'Text',[OKname2text(fnj) ': ' s2],'NodeData',[s2]);
            setProcessedIcon(parentNode);
        else
            if (isnumeric(s2))
                if strcmp(fnj,'processed')
                    if s2==0
                        try
                            set(parentNode,'Icon',[ctfroot '\S3T\unprocesssed_icon.png']);
                        catch
                            set(parentNode,'Icon',['unprocesssed_icon.png']);
                        end
                    else
                        if s2==1
                            try
                                set(parentNode,'Icon',[ctfroot '\S3T\processsed_icon.png']);
                            catch
                                set(parentNode,'Icon',['processsed_icon.png']);
                            end
                        else
                            try
                                set(parentNode,'Icon',[ctfroot '\S3T\partiallyprocesssed_icon.png']);
                            catch
                                set(parentNode,'Icon',['partiallyprocesssed_icon.png']);
                            end
                        end
                    end
                end
                leaveNode = uitreenode(parentNode,'Text',[OKname2text(fnj) ': ' num2str(s2)],'NodeData',[s2]);
            else
                if (islogical(s2))
                    leaveNode = uitreenode(parentNode,'Text',[OKname2text(fnj) ': ' num2str(s2)],'NodeData',[]);
                else
                    leaveNode = uitreenode(parentNode,'Text',[OKname2text(fnj) ': ' 'unsupported format'],'NodeData',[]);
                end
            end
        end
        
    end

    function currentAnalysis2 = checkCurrentAnalysis(thePath,currentAnalysis2)
        if isfile([thePath '\' currentAnalysis2 '_Analysis\mask_overview.png'])
            %avgFile=[thePath '\' currentAnalysis2 '_Analysis\mask_overview.png'];
        else
            Analysises=dir([thePath '\*_Analysis']);
            if ~isempty(Analysises)
                %avgFile=[Analysises(1).folder '\' Analysises(1).name '\mask_overview.png'];%'\' 'mask_overview.png'];
                ca = Analysises(1).name;
                currentAnalysis2 = ca(1:end-(length('_Analysis')));
            else
                error(['could not find file: ' thePath] );
                %error();
            end
        end
    end

    function nodechange(src,event)
      
        
        %check here if the particular node has some more information, which
        %can be retreived.
        node = event.SelectedNodes;
        currentNode = node;
        thecolor = [0 0 1; 1 0 0; 0 1 0; 1 1 0; 0 1 1; 1 0 1];%colormap(jet);
        hold off
        compoundAvg = [];
        legendLabels = [];
        % clear figure 1;
        %figure(1);
        clf;
        
        % Bleach correction polytype
        bcp='autoLinFit';%2exp';%'none'; 
        % 'autoZeroFit' 'autoLinFit' 'none' 'lin' '2exp' 'poly' '1expa'
        nSelections=size(node,1);
        for sel=1:nSelections % nB of selections = different compounds
            display(node(sel).NodeData);
            display(node(sel).Text);
            %dir(['/**/*' node.Text])
            %        thePath=node(sel).Text
            sNode = node(sel);
            level=findLevel(sNode);
            plateAvg=[];
            plateTime=[];
            level
            i=0;
            
            % Set the currentPath and plot            
            switch level
                case 4 % Synapse selected
                    thePath  = sNode.Parent.Parent.Children(1).NodeData;
                    currentPath = thePath;
                    tifPath = [thePath '\' sNode.Text(1:end-11) '.tif'];
                    currentAnalysis2 = checkCurrentAnalysis(thePath,currentAnalysis2);
                    str = readtable([thePath  '\' currentAnalysis2 '_Analysis\output\SynapseDetails\' sNode.Parent.Text(1:end-11) '_synTraces.csv']);
                    %figure(1)
                    plot(str.time,str.(sNode.Text));
                case 3 % Well selected
                   
                    thePath  = sNode.Parent.Children(1).NodeData;
                    tifPath = [thePath '\' sNode.Text(1:end-11) '.tif'];
                    currentPath = tifPath;
                    currentAnalysis2 = checkCurrentAnalysis(thePath,currentAnalysis2);
                    % Looking at wells, show synapses
                    for jjjj=length(sNode.Children):-1:1 % Always remove and recreate fields from here.
                        sNode.Children(jjjj).delete;
                    end
                    
                    wtr = readtable([thePath  '\' currentAnalysis2 '_Analysis\output\' sNode.Text(1:end-11) '_traces.csv']);
                    wta=table2array(wtr);
                    %figure(1);
                    
                    if nSelections <2 % Only plot individual synapses when no multiple selections
                        str = readtable([thePath  '\' currentAnalysis2 '_Analysis\output\SynapseDetails\' sNode.Text(1:end-11) '_synTraces.csv']);
                        for jjj=1:width(str) % Show all synapses in Tree
                            %synapseNode =
                            uitreenode(sNode,'Text',str.Properties.VariableNames{jjj},'NodeData',[tifPath]);
                        end
                        sta=table2array(str);
                        plot(str.time,sta(:,2:end),'color',[0.5 0.5 0.5]);
                        hold on;
                        plot(str.time,mean(sta(:,2:end),2),'color',[0.0 0 0],'LineWidth',3);
                    end
                    hold on;
                    plot(wtr.time,wta(:,2),'color',[1.0 0 0],'LineWidth',1);
                case 2 % Plate selected
                    % Check if plate is on exclude or gray list and remove from list
                    plateNode=sNode(1);
                    thePath=plateNode.Children(1).NodeData;
                    currentPath = thePath;
                    if isGreyedOut(thePath,fr)
                        % Grey the node
                        setGreyIcon(sNode(1));
                        includedPlates = 0;
                    else
                        includedPlates = 1;
                    end
                    
                    %%
                    if includedPlates 
                                                
                        %% Check current Analysis
                        currentAnalysis2 = checkCurrentAnalysis(thePath,currentAnalysis2);
                        
                        %%
                        aw=readtable([thePath  '\' currentAnalysis2 '_Analysis\output\AllWells.txt']);
                        compoundName = plateNode.Parent.Text;
                        fff=~isnan(aw.(text2OKname(compoundName)));
                        fff2=~(0==(aw.(text2OKname(compoundName))));
                        fff3=fff & fff2;
                        cfn = aw.FileNumber(fff3); % Compound file number(s)
                        if isempty(cfn)
                            disp( 'The compound well is not in this plate directory.');
                        else
                            inputDir = [thePath  '\' currentAnalysis2 '_Analysis\output\'];
                            dcs=dir([inputDir '\*_traces.csv']); % Directory Csv'S
                            disp(inputDir);
                            
                            [r,c] = find(cfn==extractNumber({dcs(:).name}));
                            %% 
                            node = removeAllWellNodes(node);
                               
                            %% Check if well is on exclude or gray list:
                            % draw Nodes
                            [c, includedWells] = EGfilter(c);
                            if length(includedWells)>0
                            %%
                            Wellavg=[];
                            WellTime=[];
                            iw=includedWells;
                            
                            %% Load Analysis Files settings
                            loadAnalysis=1;
                            if loadAnalysis
                                [stimCfgFN.name, folderReturn] = uigetfile([dcs(iw(1)).folder '\..\..' '\*.xml']);
                                if folderReturn
                                    stimCfgFN.folder = folderReturn;
                                end
                            end
                            %% 
                            for i=1:length(iw) % All non grey/included wells with compound
                                disp(dcs(iw(i)).name)
%                                createWellNode(iw(i));
                                tr{i} = readtable([dcs(iw(i)).folder '\' dcs(iw(i)).name]); % loadWellTable
                                
                                
                                if ~loadAnalysis
                                    Wellavg(:,i) = tr{i}.PixelAverage; %SynapseAverage,PixelAverage,rawAverageResponse,SWSynapseAverage,SynapseAverage
                                    WellTime(:,i) = tr{i}.time;
                                else
                                %% load analysis cfg and apply
                                
                                set2 = xmlSettingsExtractor(stimCfgFN);
                                
                                settings.NOS = set2.pulseCount;
                                settings.dCOF = set2.dutyCycle;
                                settings.dCOF2 = set2.dutyCycle2;
                                settings.OnOffset = round(set2.delayTime*set2.imageFreq/1000);
                                settings.OnOffset2 = round(set2.delayTime2*set2.imageFreq/1000);
                                settings.NOS2 = set2.pulseCount2;
                                settings.fps = set2.imageFreq;
                                settings.stimFreq = set2.stimFreq;
                                settings.stimFreq2 = set2.stimFreq2;
                                
                                traceFrames = tr{i}.PixelAverage; %SynapseAverage,PixelAverage,rawAverageResponse,SWSynapseAverage,SynapseAverage
                                Wellavg(:,i) = foldData(traceFrames,settings);
                                WellTime(:,i) = tr{i}.time(1:(size(Wellavg(:,i),1)));
                                end
                                
                                
                                if nSelections>1 % When multiple files selected.
                                    %%  plot(tr{i}.time,tr{i}.rawAverageResponse,'color',thecolor(sel,:)); %PixelAverage,rawAverageResponse
                                    %hold on;
                                    % Wellavg(:,i)=tr{i}.PixelAverage;
                                    
                                else %Single File selected, Show all well avgs
                                    %plot(tr{i}.time, findBaseFluorPoints(Wellavg(:,i)',bcp,0)'); %PixelAverage,rawAverageResponse,SWSynapseAverage,SynapseAverage
                                    plot(WellTime(:,i) , findBaseFluorPoints(Wellavg(:,i)',bcp,0)'); %PixelAverage,rawAverageResponse,SWSynapseAverage,SynapseAverage
                                    hold on;
                                end
                            end
                            
                            mW = findBaseFluorPoints(mean(Wellavg,2)',bcp,0)';
                            wT = mean(WellTime,2);
                            [plateAvg, plateTime] = updateAvg(plateAvg,plateTime,mW,wT);
                       
                        %figure(1);
                        if size(node,1)==1 %Single compound selection, => show all plates avg.
                            try
                                plot( plateTime(:,1),plateAvg(:,1),'color',thecolor(mod(sel-1,6)+1,:),'LineWidth',3); %PixelAverage,rawAverageResponse
                            catch
                                plot( plateTime(:,1),plateAvg(:,1),'color',thecolor(mod(sel-1,6)+1,:),'LineWidth',3); %PixelAverage,rawAverageResponse
                            end
                            hold on;
                        end
                             end   
                        end
                    end
                case 1 % Compound Selected
                    pNode=sNode(1).Children;
                    K=length(pNode);
                    %% Check if plate is on exclude or gray list and remove from list
                    K2=K;
                    for k=K:-1:1 % All wells with compound
                        plateNode = pNode(k);
                        thePath=plateNode.Children(1).NodeData;
                        if isExcluded(thePath,fr)
                            pNode(k) = [];
                            K2=K2-1;
                        end
                    end
                    includedPlates=[];
                    for k=1:K2 % All plates with compound
                        plateNode = pNode(k);
                        thePath=plateNode.Children(1).NodeData;
                        if isGreyedOut(thePath,fr)
                            % Grey the node
                            setGreyIcon(pNode(k));
                        else
                            includedPlates(end+1) = k;
                        end
                    end      
                    
                    %%
                    ip = includedPlates;
                    plateAvg=[]; plateTime=[]; legendPlateLabel=[];
                    k2=0; % This counter is the counter of valid plates to calculate the avg from
                    for k=1:length(ip) % All included plates with particular compound
                        k2=k2+1;
                        plateNode=pNode(ip(k));
                        
                        thePath=plateNode.Children(1).NodeData;
                        currentPath = thePath;
                        
                        %% Check current Analysis
                        currentAnalysis2 = checkCurrentAnalysis(thePath,currentAnalysis2);
                        
                       %%
                       aw=readtable([thePath  '\' currentAnalysis2 '_Analysis\output\AllWells.txt']);
                        compoundName = plateNode.Parent.Text;
                         fff=~isnan(aw.(text2OKname(compoundName)));
                        fff2=~(0==(aw.(text2OKname(compoundName))));
                        fff3=fff & fff2;
                        cfn = aw.FileNumber(fff3); % Compound file number(s)
                        if isempty(cfn)
                            disp( 'The compound well is not in this plate directory.');
                        else
                            inputDir = [thePath  '\' currentAnalysis2 '_Analysis\output\'];
                            dcs=dir([inputDir '\*_traces.csv']); % Directory Csv'S
                            disp(inputDir);
                            
                            [r,c] = find(cfn==extractNumber({dcs(:).name}));
                           
                            
                            %% Check if well is on exclude or gray list:
                            for jjj=length(c):-1:1 % All wells with compound
                                disp([dcs(c(jjj)).folder '\' dcs(c(jjj)).name]);
                                tifPath = [thePath '\' dcs(c(jjj)).name(1:end-11) '.tif'];
                                if isExcluded(tifPath,fr)
                                    c(jjj)=[];
                                end
                            end
                            includedWells=[];
                            for jjj=1:length(c) % All wells with compound
                                tifPath = [thePath '\' dcs(c(jjj)).name(1:end-11) '.tif'];
                                if isGreyedOut(tifPath,fr)
                                    %setGreyIcon(sNode.Children(end)); % The last added node is grey
                                else
                                    includedWells(end+1) = c(jjj);
                                end
                            end
                            
                            %%
                            if isempty(includedWells) % check if not all wells with compounds are disabled.
                                k2=k2-1;
                            else
                                legendPlateLabel{k2}=plateNode.Text;
                                %if includedPlates 
                            Wellavg=[];
                            WellTime=[];
                            iw=includedWells;
                            for ii=1:length(iw) % All wells in plate with compound
                                disp(dcs(iw(ii)).name);
                                tr{ii} = readtable([dcs(iw(ii)).folder '\' dcs(iw(ii)).name]);
                                Wellavg(:,ii)=tr{ii}.PixelAverage; %SynapseAverage,PixelAverage,rawAverageResponse,SWSynapseAverage,SynapseAverage
                                WellTime(:,ii)=tr{ii}.time;
                            end
                            
                            mW = findBaseFluorPoints(mean(Wellavg,2)',bcp,0)';
                            wT = mean(WellTime,2);
                            
                           [plateAvg, plateTime] = updateAvg(plateAvg,plateTime,mW,wT,k2);
                         
                       
                        %figure(1);
                        if size(node,1)==1 %Single compound selection, => show all plates avg.
                            try
                                plot( plateTime(:,k2),plateAvg(:,k2),'color',thecolor(mod(sel-1,6)+1,:),'LineWidth',3); %PixelAverage,rawAverageResponse
                            catch
                                plot( plateTime(:,k2),plateAvg(:,k2),'color',thecolor(mod(sel-1,6)+1,:),'LineWidth',3); %PixelAverage,rawAverageResponse
                            end
                            hold on;
                        end
                             end
                        end
                    end
            end
            
            % Create the legend labels
            switch level
                case 1
                    if nSelections==1
                        legendLabels={legendPlateLabel{:}, node(sel).Text};
                    else
                        legendLabels{sel}=node(sel).Text;  
                    end
                case 2
                    if nSelections==1
                        if includedPlates
                            legendLabels={dcs(includedWells).name};
                        end
                    else
                        legendLabels{sel}=node(sel).Text;
                    end
                case 3
                    if nSelections==1
                        if includedPlates
                            legendLabels={dcs(includedWells).name};
                        end
                    else
                        legendLabels{sel}=node(sel).Text;
                    end
                    
                case 4
            end
         
            % Calculate averages
            compoundAvg{sel}=findBaseFluorPoints(mean(plateAvg,2)',bcp,0)';
            compoundTime{sel}=mean(plateTime,2);
            %figure(1);
            if (nSelections>1) || (level==1)% if multiple selections, show compound Avg
                plot(compoundTime{sel},compoundAvg{sel},'color',thecolor(mod(sel-1+1,6)+1,:),'LineWidth',8); %PixelAverage,rawAverageResponse
                hold on;
            end
        end
        % Show the legend
        legend(legendLabels,'Interpreter','none');
        
        %% Some helper sub-sub-functions:
        function [plateAvg, plateTime] = updateAvg(plateAvg,plateTime,mW,wT,k)
            if ~exist('k','var')
                k=1;
            end
            if isempty(mW)
                plateAvg=plateAvg;
                plateTime=plateTime;
            else
                if size(mW,1)==size(plateAvg,1) % Check length recordings
                    plateAvg(:,k) = mW;
                    plateTime(:,k) = wT;
                    
                else % Change the size of the shortest to the longest recording by adding zeros.
                    % Adjust avg and time:
                    % plateAvg = f(plateAvg,mW)
                    % plateTime = f(plateTime,mT )
                    
                    if size(mW,1)<size(plateAvg,1)
                        dsize=size(plateAvg,1)-size(mW,1);
                        plateAvg(:,k) = [mW; zeros(dsize,1)];
                        plateTime(:,k) = [wT; wT(end)+(wT(2)-wT(1))*(1:dsize)'];
                    else
                        dsize=size(mW,1)-size(plateAvg,1);
                        plateAvg = [plateAvg; zeros(dsize,size(plateAvg,2))];
                        plateAvg(:,k) = mW;
                        if isempty(plateTime)
                            plateTime(:,k) = wT;
                        else
                            plateTime = [plateTime; plateTime(end,:)+(plateTime(2,:)-plateTime(1,:)).*(1:dsize)' ];
                            plateTime(:,k) = wT;
                        end
                    end
                    
                end
            end
        end
        function [c, includedWells] = EGfilter(c)
            % Exclude Greyout filter:
            % [c, includedWells] = EGfilter(c)
            % check if wells are greyed out or exluded.
            % the new c is a list with all non-excluded c(i)
            % includeWells is a list with all non-excluded or not-greyed
            % items
            % c is a list of indices of a dcs which have a the particular
            % compound
        
            for jj=length(c):-1:1 % All wells with compound
                disp([dcs(c(jj)).folder '\' dcs(c(jj)).name]);
                tifPath = [thePath '\' dcs(c(jj)).name(1:end-11) '.tif'];
                if isExcluded(tifPath,fr)
                    % remove excluded wells
                    c(jj)=[];
                end
            end
            includedWells=[];
            for jj=length(c):-1:1
                tifPath = [thePath '\' dcs(c(jj)).name(1:end-11) '.tif'];
                if isGreyedOut(tifPath,fr)
                    % Grey out greyed cells
                    createWellNode(c(jj));
                    setGreyIcon(sNode.Children(end)); % The last added node is grey
                   %wellIsIncluded(i) = 0;
                else
                    includedWells(end+1)=c(jj);
                    createWellNode(c(jj));
                    setMyIcon(sNode.Children(end));
                    %wellIsIncluded(i) = 1;
                end
            end
        end
        function level = findLevel(node)
            level=0;
            p=node.Parent;
            while (isprop(p,'Text')) %Go up the tree, until there is no text field
                %  thePath=[p.Text '\' thePath];
                p=p.Parent;
                level=level+1;
            end
        end
        function node = removeAllWellNodes(node)
            for jjjj=length(node(sel).Children):-1:2 % Always remove and recreate fields from here.
                node(sel).Children(jjjj).delete;
            end
        end
        function createWellNode(well)
            tifPath = [thePath '\' dcs(well).name(1:end-11) '.tif'];
            leaveNode = uitreenode(node(sel),'Text',dcs(well).name,'NodeData',[tifPath]);
        end
    end

    function displayNode(thePath, nodeText)
        %imagesc(uia,imread(['F:\share\data\Rajiv\2018\02-03-2018\plate1\Protocol11220180302_110630_20180302_112921\1AP_Analysis\' node.Text '_avg.png']));
        maskFile=[thePath '_mask.png'];
        if exist(maskFile,'file')
            %             tifViewMode='mask'
            %             tifViewMode='avg'
            %             tifViewMode='play'
            %             tifViewMode='analysis'
            %             tifViewMode='temp'
            tifViewMode2=tifViewMode2; %comes from global variable in projViewer
            switch tifViewMode2
                case 'mask'
                    gg=strfind(thePath,'\');
                    % Find the _Analysis folders/xml files.
                    ttt=dir([thePath(1:gg(end)) '*_Analysis']); % This takes a few ms which can be avoided, but is OK for now.
                    analysisLst.Items= getAnalysises(thePath);
                    io=1;
                    % ttt(io).folder = [ttt(io).folder '\' ttt(io).name];
                    ttt(io).folder = [ttt(io).folder '\' currentAnalysis2 '_Analysis'];
                    ttt(io).name=thePath(gg(end)+1:end);
                    if ~isempty(ttt)
                        for io=1:1%size(t,1)
                            avgFile=[ttt(io).folder '\' ttt(io).name '_mask.png'];
                            imagesc(uia,imresize(imread(avgFile),'OutputSize',[512,512]));
                            uia.Position=[700,-10,512*2,512*2 ];
                        end
                    end
                    %imagesc(uia,imread(maskFile));
                    % uia.Position=[700,200,512,512 ];
                    %uia.Position=[700,-10,512*2,512*2 ];
                case 'avg'
                    %t = dir([rootDir '/**/' node.Text '*_avg.png' ]);
                    
                    gg=strfind(thePath,'\');
                    ttt=dir([thePath(1:gg(end)) '*_Analysis']); % This takes a few ms which can be avoided, but is OK for now.
                    io=1;
                    %ttt(io).folder= 'D:\data\Rajiv\m Galenea\Galenea\28-02-2019\NS_320190228_111224_20190228_113209\01AP_1st_Analysis';
                    %ttt(io).folder= thePath(1:gg(end))'D:\data\Rajiv\m Galenea\Galenea\28-02-2019\NS_320190228_111224_20190228_113209\01AP_1st_Analysis';
                    %ttt(1).folder
                    ttt(io).folder=[ttt(io).folder '\' ttt(io).name]
                    ttt(io).name=thePath(gg(end)+1:end);%nodeText;
                    if ~isempty(ttt)
                        for io=1:1%size(t,1)
                            avgFile=[ttt(io).folder '\' ttt(io).name];
                            avgFile=[ttt(io).folder '\' ttt(io).name '_avg.png'];
                            imagesc(uia,imread(avgFile));
                            uia.Position=[700,-10,512*2,512*2 ];
                        end
                    end
                    %    imagesc(uia,imread(maskFile));
                    %    uia.Position=[700,200,512,512 ];
                case 'play'
                    M = loadTiff(thePath,1);
                    speed=60;
                    isPlaying=1;
                    for i=1:speed:(size(M,3)-speed)
                        imagesc(uia,max(M(:,:,i+(0:speed)),[],3));
                        uia.Position=[700,-10,512*2,512*2 ];
                        drawnow();
                        if isPlaying==0 % Disable continued play when switched before end of movie.
                            break;
                        end
                    end
                    isPlaying=0;
                    
                case 'analysis'
                    gg=strfind(thePath,'\');
                    % Find the _Analysis folders/xml files.
                    ttt=dir([thePath(1:gg(end)) '*_Analysis']); % This takes a few ms which can be avoided, but is OK for now.
                    analysisLst.Items= getAnalysises(thePath);
                    io=1;
                    % ttt(io).folder = [ttt(io).folder '\' ttt(io).name];
                    ttt(io).folder = [ttt(io).folder '\' currentAnalysis2 '_Analysis'];
                    ttt(io).name=thePath(gg(end)+1:end);
                    if ~isempty(ttt)
                        for io=1:1%size(t,1)
                            avgFile=[ttt(io).folder '\' ttt(io).name '_Analysis.png'];
                            imagesc(uia,imresize(imread(avgFile),'OutputSize',[512,512]));
                            uia.Position=[700,-10,512*2,512*2 ];
                        end
                    end
                    
                case 'temp'
                    gg=strfind(thePath,'\');
                    % Find the _Analysis folders with _temp.png in.
                    ttt=dir([thePath(1:gg(end)) '*_Analysis\' thePath(gg(end)+1:end) '_temp.png']); % This takes a few ms which can be avoided, but is OK for now.
                    io=1;
                    % ttt(io).folder = [ttt(io).folder '\' ttt(io).name];
                    %ttt(io).name=thePath(gg(end)+1:end);
                    if ~isempty(ttt)
                        for io=1:1%size(t,1)
                            avgFile=[ttt(io).folder '\' ttt(io).name];
                            imagesc(uia,imresize(imread(avgFile),'OutputSize',[512,512]));
                            uia.Position=[700,-10,512*2,512*2 ];
                        end
                    end
                case 'signals'
                    gg=strfind(thePath,'\');
                    % Find the _Analysis folders/xml files.
                    ttt=dir([thePath(1:gg(end)) '*_Analysis']); % This takes a few ms which can be avoided, but is OK for now.
                    io=1;
                    ttt(io).folder = [ttt(io).folder '\' ttt(io).name];
                    ttt(io).name=thePath(gg(end)+1:end);;
                    if ~isempty(ttt)
                        for io=1:1%size(t,1)
                            avgFile=[ttt(io).folder '\' ttt(io).name(1:end-4) '_signals.png'];
                            imagesc(uia,imresize(imread(avgFile),'OutputSize',[512,512]));
                            uia.Position=[700,-10,512*2,512*2 ];
                        end
                    end
                    
            end
        else
            overviewFile=[thePath '\mask_overview.png'];
            if exist(overviewFile,'file')
                currentPath = thePath;
                switch tifViewMode2
                    case 'mask'
                        % Find the _Analysis folders/xml files.
                        ttt=dir([thePath '\*_Analysis\mask_overview.png']); % This takes a few ms which can be avoided, but is OK for now.
                        for i=1:length(ttt)
                            gg = strfind(ttt(i).folder,'\');
                            AL{i} = ttt(i).folder(gg(end)+1:end-9);
                        end
                        io=1;
                        analysisLst.Items = AL;
                        ttt(io).folder = [ttt(io).folder '\' ttt(io).name];
                        % ttt(io).name=nodeText;
                        if ~isempty(ttt)
                            for io=1:1%size(t,1)
                                %avgFile=[ttt(io).folder '\' ttt(io).name];
                                %avgFile=[ttt(io).folder '\' 'analysis_overview.png'];
                                if isfile([thePath '\' currentAnalysis2 '_Analysis\mask_overview.png'])
                                    avgFile=[thePath '\' currentAnalysis2 '_Analysis\mask_overview.png'];
                                else
                                    avgFile=[ttt(io).folder ];%'\' 'mask_overview.png'];
                                end
                                
                                imagesc(uia,imresize(imread(avgFile),'OutputSize',[3102/2.3,5170/2.3 ]));
                                %uia.Position=[700,-10,512*2,512*2 ];
                                uia.Position=[560,-600,3102/2.3,5170/2.3 ]
                            end
                        else % not found
                            imagesc(uia,imresize(zeros(3102,5170),'OutputSize',[3102/2.3,5170/2.3 ]));
                            warning('not found');
                        end
                        
                        
                        
                        %imagesc(uia,imresize(imread(overviewFile),'OutputSize',[3102/2.3,5170/2.3]));
                        %uia.Position=[560,-600,3102/2.3,5170/2.3 ];
                    case 'analysis'
                        % Find the _Analysis folders/xml files.
                        ttt=dir([thePath '\*_Analysis\analysis_overview.png']); % This takes a few ms which can be avoided, but is OK for now.
                        for i=1:length(ttt)
                            gg = strfind(ttt(i).folder,'\');
                            AL{i} = ttt(i).folder(gg(end)+1:end-9);
                        end
                        io=1;
                        analysisLst.Items = AL;
                        ttt(io).folder = [ttt(io).folder '\' ttt(io).name];
                        % ttt(io).name=nodeText;
                        if ~isempty(ttt)
                            for io=1:1%size(t,1)
                                %avgFile=[ttt(io).folder '\' ttt(io).name];
                                %avgFile=[ttt(io).folder '\' 'analysis_overview.png'];
                                avgFile=[thePath '\' currentAnalysis2 '_Analysis\analysis_overview.png'];
                                imagesc(uia,imresize(imread(avgFile),'OutputSize',[3102/2.3,5170/2.3 ]));
                                %uia.Position=[700,-10,512*2,512*2 ];
                                uia.Position=[560,-600,3102/2.3,5170/2.3 ]
                            end
                        end
                    case 'avg'
                        ttt=dir([thePath '\*_Analysis']); % This takes a few ms which can be avoided, but is OK for now.
                        io=1;
                        ttt(io).folder = [ttt(io).folder '\' ttt(io).name];
                        %ttt(io).name=nodeText;
                        if ~isempty(ttt)
                            for io=1:1%size(t,1)
                                % avgFile=[ttt(io).folder '\' ttt(io).name];
                                
                                %                                if ~exist([plateDir dd2],'file')
                                %                                    dd2 = [tempDirFn '..\' tempFFn(1:end-13) '.tif_mask.png'];
                                %                                end
                                
                                avgFile=[ttt(io).folder '\' 'avg_overview.png'];
                                imagesc(uia,imresize(imread(avgFile),'OutputSize',[3102/2.3,5170/2.3 ]));
                                %uia.Position=[700,-10,512*2,512*2 ];
                                uia.Position=[560,-600,3102/2.3,5170/2.3 ]
                            end
                        end
                    case 'temp'
                        ttt=dir([thePath '\*_Analysis\temp_overview.png']); % This takes a few ms which can be avoided, but is OK for now.
                        io=1;
                        for i=1:length(ttt)
                            gg = strfind(ttt(i).folder,'\');
                            AL{i} = ttt(i).folder(gg(end)+1:end-9);
                        end
                        analysisLst.Items = AL;
                        %ttt(io).folder = [ttt(io).folder '\' ttt(io).name];
                        %ttt(io).name=nodeText;
                        if ~isempty(ttt)
                            for io=1:1%size(t,1)
                                if isfile([thePath '\' currentAnalysis2 '_Analysis\temp_overview.png'])
                                    avgFile=[thePath '\' currentAnalysis2 '_Analysis\temp_overview.png'];
                                else
                                    avgFile=[thePath '\' AL{i} '_Analysis\temp_overview.png'];
                                    
                                end
                                imagesc(uia,imresize(imread(avgFile),'OutputSize',[3102/2.3,5170/2.3 ]));
                                uia.Position=[560,-600,3102/2.3,5170/2.3 ]
                            end
                        end
                    case 'signals'
                        ttt=dir([thePath '\*_Analysis']); % This takes a few ms which can be avoided, but is OK for now.
                        io=1;
                        ttt(io).folder = [ttt(io).folder '\' ttt(io).name];
                        %ttt(io).name=nodeText;
                        if ~isempty(ttt)
                            for io=1:1%size(t,1)
                                % avgFile=[ttt(io).folder '\' ttt(io).name];
                                avgFile=[ttt(io).folder '\' 'signals_overview.png'];
                                imagesc(uia,imresize(imread(avgFile),'OutputSize',[3102/2.3,5170/2.3 ]));
                                %uia.Position=[700,-10,512*2,512*2 ];
                                uia.Position=[560,-600,3102/2.3,5170/2.3 ]
                            end
                        end
                    case 'play'
                        image(uia,imresize(zeros(3102,5170),'OutputSize',[3102/2.3,5170/2.3 ]));
                        uia.Position=[560,-600,3102/2.3,5170/2.3 ]
                        drawnow();
                        playPlateMovie(thePath,0,3,0,8,uia,3);
                end
            end
        end
    end

    function AL = getAnalysises(currentPath)
        % There are 2 getAnalysises, the other one in projViewer, keep sync!
        gg=strfind(currentPath,'\');
        % Find the _Analysis folders/xml files.
        ttt=dir([currentPath(1:gg(end)) '*_Analysis']); % This takes a few ms which can be avoided, but is OK for now.
        for i=1:size(ttt,1)
            AL{i} = ttt(i).name(1:end-9);
        end
    end

end
