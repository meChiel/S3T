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
displayNodeFct2 =@displayNode;
currentNode=0;

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
%c2 = ;
%c3 = ;


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
    %    %
    %
    %     fn = fieldnames(s);
    %     for j=1:(length(fn))
    %         if (isstruct(s.(fn{j})))
    %             rootTxtNode{j} = uitreenode(rootNode,'Text',fn{j},'NodeData',[]);
    %             if length(s.(fn{j}))~=1
    %                 for k=1:length(s.(fn{j})) % create for each element in the array a node
    %                     rootTxtNode2{j,k} = uitreenode(rootTxtNode{j},'Text',[fn{j} '[' num2str(k) ']'],'NodeData',[]);
    %                     % Create for each element in the struct a node.
    %                     createStructFieldNodes(rootTxtNode2{j,k},s.(fn{j})(k),fn{j});
    %                 end
    %             else % Single node: create for each element in the struct a node.
    %                 createStructFieldNodes(rootNode{j},s.(fn{j}),fn{j});
    %             end
    %         else
    %             showLeave(rootNode,s.(fn{j}),fn{j})
    %         end
    %     end
    %
    
    t.SelectionChangedFcn = @nodechange;
    
end



    function greyOut(e,d,f)
        disp(['greyout: ' currentPath]);
        disp([currentPath ' should be greyed Out.']);
        psonFileName='gal2_Filter.pson';
        fr.greyOut{end+1}=currentPath;
        psonwrite(psonFileName,fr)
        try
            %set(parentNode,'Icon',[ctfroot '\S3T\unprocesssed_icon.png']);
            set(currentNode,'Icon',[ctfroot '\S3T\grey_icon.png']);
        catch
            % set(parentNode,'Icon',['unprocesssed_icon.png']);
            set(currentNode,'Icon',['grey_icon.png']);
        end
      
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
        try
            set(currentNode,'Icon',[ctfroot '\S3T\processsed_icon.png']);
        catch
            set(currentNode,'Icon',['processsed_icon.png']);
        end
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
                    if ~isGreyedOut(s2.(fnn{i}),fr) % Greyed Out?
                         showLeave(parentNode,s2.(fnn{i}),fnn{i})
                    else % Is greyed Out?
                        leaveNode = uitreenode(parentNode,'Text',[OKname2text(fnn{i}) ': ' s2.(fnn{i})],'NodeData',[s2.(fnn{i})]);
                        try
                            %set(parentNode,'Icon',[ctfroot '\S3T\unprocesssed_icon.png']);
                            set(parentNode,'Icon',[ctfroot '\S3T\grey_icon.png']);
                        catch
                            % set(parentNode,'Icon',['unprocesssed_icon.png']);
                            set(parentNode,'Icon',['grey_icon.png']);
                        end
                    end
                end
            end
        end
    end

% If node is a leave display the leave
    function showLeave(parentNode,s2,fnj)%s2=s.(fn{j}),fn{j}
        try ctfroot()
        catch
            ctfroot=pwd;
        end
        if (isstr(s2))
            leaveNode = uitreenode(parentNode,'Text',[OKname2text(fnj) ': ' s2],'NodeData',[s2]);
            try
                set(parentNode,'Icon',[ctfroot '\S3T\processsed_icon.png']);
            catch
                set(parentNode,'Icon',['processsed_icon.png']);
            end
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
        thecolor= [0 0 1; 1 0 0; 0 1 0; 1 1 0; 0 1 1; 1 0 1];%colormap(jet);
        hold off
        compoundAvg=[];
        legendLabels=[];
        % clear figure 1;
        %figure(1);
        clf;
        
        bcp='none';%2exp';%'none'; % Bleach correction polytype
        nSelections=size(node,1);
        for sel=1:nSelections % nB of selections = different compounds
            display(node(sel).NodeData);
            display(node(sel).Text);
            %dir(['/**/*' node.Text])
            %        thePath=node(sel).Text
            level=0;
            p=node(sel).Parent;
            while (isprop(p,'Text')) %Go up the tree, until there is no text field
                %  thePath=[p.Text '\' thePath];
                p=p.Parent;
                level=level+1;
            end
            %         if strcmp(rootDir(end),'\')
            %             thePath=strrep(thePath,[rootName '\'],rootDir);
            %         else
            %             thePath=strrep(thePath,rootName,rootDir);
            %         end
            %hold off
            plateAvg=[];
            plateTime=[];
            level
            i=0;
            switch level
                case 1 % Compound selected
                    K=length(node(sel).Children);
                    node3=node(sel).Children;
                case 2 % Plate selected
                    K=length(node(sel));
                    node3=node(sel);
                case 3 % Well selected
                    K=length(node(sel));
                    node3=node(sel).Parent;
                case 4 % Synapse selected
                    K=length(node(sel));
                    node3=node(sel).Parent;
            end    
            %%
          
            switch level
                case 4 % Synapse selected
                    thePath  = node(sel).Parent.Parent.Children(1).NodeData;
                    currentPath = thePath;
                    tifPath = [thePath '\' node(sel).Text(1:end-11) '.tif'];
                    currentAnalysis2 = checkCurrentAnalysis(thePath,currentAnalysis2);
                    str = readtable([thePath  '\' currentAnalysis2 '_Analysis\output\SynapseDetails\' node(sel).Parent.Text(1:end-11) '_synTraces.csv']);
                    %figure(1)
                    plot(str.time,str.(node(sel).Text));
                case 3 % Well selected
                    thePath  = node(sel).Parent.Children(1).NodeData;
                    tifPath = [thePath '\' node(sel).Text(1:end-11) '.tif'];
                    currentPath = tifPath;
                    currentAnalysis2 = checkCurrentAnalysis(thePath,currentAnalysis2);
                    % Looking at wells, show synapses
                    for jjjj=length(node(sel).Children):-1:1 % Always remove and recreate fields from here.
                        node(sel).Children(jjjj).delete;
                    end
                    
                    wtr = readtable([thePath  '\' currentAnalysis2 '_Analysis\output\' node(sel).Text(1:end-11) '_traces.csv']);
                    wta=table2array(wtr);
                    %figure(1);
                    
                    if nSelections <2 % Only plot individual synapses when no multiple selections
                        str = readtable([thePath  '\' currentAnalysis2 '_Analysis\output\SynapseDetails\' node(sel).Text(1:end-11) '_synTraces.csv']);
                        for jjj=1:width(str) % Show all synapses in Tree
                            %synapseNode =
                            uitreenode(node(sel),'Text',str.Properties.VariableNames{jjj},'NodeData',[tifPath]);
                        end
                        sta=table2array(str);
                        plot(str.time,sta(:,2:end),'color',[0.5 0.5 0.5]);
                        hold on;
                        plot(str.time,mean(sta(:,2:end),2),'color',[0.0 0 0],'LineWidth',3);
                    end
                    hold on;
                    plot(wtr.time,wta(:,2),'color',[1.0 0 0],'LineWidth',1);

                case 2  % Plate selected
                    
                          %% Check if plate is on exclude or gray list and remove from list
                    K2=K;
                    for k=K:-1:1 % All wells with compound
                        isIncluded = 0;
                        node2=node3(k);
                        thePath=node2.Children(1).NodeData;
                        currentPath = thePath;
                        if isExcluded(thePath,fr)
                            node3(k)=[];
                            K2=K2-1;
                        else
                            if isGreyedOut(thePath,fr)
                                node3(k)=[];
                                K2=K2-1;
                            else
                                 isIncluded = 1;
                            end
                        end
                    end
                    K=K2;
                    
                    %%
                    if K2>0 % All plates with particular compound
                        node2=node3(k);
                        thePath=node2.Children(1).NodeData;
                        
                        %thePath=strrep(thePath,rootName,rootDir);
                        currentPath = thePath;
                        %  displayNode(thePath,node.Text);
                        %gg=strfind(thePath,'\');
                        
                        
                        %% Check current Analysis
                        currentAnalysis2 = checkCurrentAnalysis(thePath,currentAnalysis2);
                        
                        %%
                        %imagesc(imresize(imread(avgFile),'OutputSize',[3102/2.3,5170/2.3 ]));
                        %                aw=csvread([thePath  '\plateLayout_' node2.Parent.Text '.csv']);
                        aw=readtable([thePath  '\' currentAnalysis2 '_Analysis\output\AllWells.txt']);
                        
                        compoundName = node2.Parent.Text;
                        cfn = aw.FileNumber(~isnan(aw.(text2OKname(compoundName)))); % Compound file number(s)
                        if isempty(cfn)
                            disp( 'The compound well is not in this plate directory.');
                        else
                            inputDir = [thePath  '\' currentAnalysis2 '_Analysis\output\'];
                            dcs=dir([inputDir '\*_traces.csv']); % Directory Csv'S
                            disp(inputDir);
                            
                            [r,c] = find(cfn==extractNumber({dcs(:).name}));
                            isIncluded = 0;
                            
                            %% Check if well is on exclude or gray list:
                            for i=length(c):-1:1 % All wells with compound
                                disp([dcs(c(i)).folder '\' dcs(c(i)).name]);
                                tifPath = [thePath '\' dcs(c(i)).name(1:end-11) '.tif'];
                                if isExcluded(tifPath,fr)
                                    c(i)=[];
                                else
                                    if isGreyedOut(tifPath,fr)
                                        c(i)=[];
                                    else
                                        isIncluded = 1;
                                    end
                                end
                            end
                            
                            %%
                            if isIncluded 
                            Wellavg=[];
                            WellTime=[];
                            if 1 %level ==2 % plate selected, remove wells
                                for jjjj=length(node(sel).Children):-1:2 % Always remove and recreate fields from here.
                                    node(sel).Children(jjjj).delete;
                                end
                            end
                            for i=1:length(c) % All wells with compound
                                disp(dcs(c(i)).name)
                                if level == 2 % Looking at plates, show wells
                                    tifPath = [thePath '\' dcs(c(i)).name(1:end-11) '.tif'];
                                    leaveNode = uitreenode(node(sel),'Text',dcs(c(i)).name,'NodeData',[tifPath]);
                                end
                                
                                tr{i} = readtable([dcs(c(i)).folder '\' dcs(c(i)).name]);
                                Wellavg(:,i)=tr{i}.PixelAverage; %SynapseAverage,PixelAverage,rawAverageResponse,SWSynapseAverage,SynapseAverage
                                WellTime(:,i)=tr{i}.time;
                                
                                if nSelections>1 % When multiple files selected.
                                    %%  plot(tr{i}.time,tr{i}.rawAverageResponse,'color',thecolor(sel,:)); %PixelAverage,rawAverageResponse
                                    %hold on;
                                    % Wellavg(:,i)=tr{i}.PixelAverage;
                                    
                                else %Single File selected, Show all well avgs
                                    plot(tr{i}.time, findBaseFluorPoints(Wellavg(:,i)',bcp,0)'); %PixelAverage,rawAverageResponse,SWSynapseAverage,SynapseAverage
                                    hold on;
                                end
                                
                            end
                            
                            mW = findBaseFluorPoints(mean(Wellavg,2)',bcp,0)';
                            wT = mean(WellTime,2);
                            if size(mW,1)==size(plateAvg,1) % Check length recordings
                                plateAvg(:,k) = mW;
                                plateTime(:,k) = wT;
                                
                            else % Change the size of the shortest to the longest recording by adding zeros.
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
                        %figure(1);
                        if size(node,1)==1 %Single compound selection, => show all plates avg.
                            try
                                plot( plateTime(:,k),plateAvg(:,k),'color',thecolor(mod(sel-1,6)+1,:),'LineWidth',3); %PixelAverage,rawAverageResponse
                            catch
                                plot( plateTime(:,k),plateAvg(:,k),'color',thecolor(mod(sel-1,6)+1,:),'LineWidth',3); %PixelAverage,rawAverageResponse
                            end
                            hold on;
                        end
                    end
                    
                case 1 % Compound Selected
                    %% Check if plate is on exclude or gray list and remove from list
                    K2=K;
                    for k=K:-1:1 % All wells with compound
                        isIncluded = 0;
                        node2=node3(k);
                        thePath=node2.Children(1).NodeData;
                        if isExcluded(thePath,fr)
                            node3(k)=[];
                            K2=K2-1;
                        else
                            if isGreyedOut(thePath,fr)
                                node3(k)=[];
                                K2=K2-1;
                            else
                                 isIncluded = 1;
                            end
                        end
                    end
                    K=K2;
                    
                    %%
                    for k=1:K % All plates with particular compound
                        node2=node3(k);
                        thePath=node2.Children(1).NodeData;
                        
                        %thePath=strrep(thePath,rootName,rootDir);
                        currentPath = thePath;
                        %  displayNode(thePath,node.Text);
                        %gg=strfind(thePath,'\');
                        
                        
                        %% Check current Analysis
                        currentAnalysis2 = checkCurrentAnalysis(thePath,currentAnalysis2);
                        
                        %%
                        %imagesc(imresize(imread(avgFile),'OutputSize',[3102/2.3,5170/2.3 ]));
                        %                aw=csvread([thePath  '\plateLayout_' node2.Parent.Text '.csv']);
                        aw=readtable([thePath  '\' currentAnalysis2 '_Analysis\output\AllWells.txt']);
                        
                        compoundName = node2.Parent.Text;
                        cfn = aw.FileNumber(~isnan(aw.(text2OKname(compoundName)))); % Compound file number(s)
                        if isempty(cfn)
                            disp( 'The compound well is not in this plate directory.');
                        else
                            inputDir = [thePath  '\' currentAnalysis2 '_Analysis\output\'];
                            dcs=dir([inputDir '\*_traces.csv']); % Directory Csv'S
                            disp(inputDir);
                            
                            [r,c] = find(cfn==extractNumber({dcs(:).name}));
                            isIncluded = 0;
                            
                            %% Check if well is on exclude or gray list:
                            for i=length(c):-1:1 % All wells with compound
                                disp([dcs(c(i)).folder '\' dcs(c(i)).name]);
                                tifPath = [thePath '\' dcs(c(i)).name(1:end-11) '.tif'];
                                if isExcluded(tifPath,fr)
                                    c(i)=[];
                                else
                                    if isGreyedOut(tifPath,fr)
                                        c(i)=[];
                                    else
                                        isIncluded = 1;
                                    end
                                end
                            end
                            
                            %%
                            if isIncluded 
                            Wellavg=[];
                            WellTime=[];
                            for i=1:length(c) % All wells with compound
                                disp(dcs(c(i)).name)
                                tr{i} = readtable([dcs(c(i)).folder '\' dcs(c(i)).name]);
                                Wellavg(:,i)=tr{i}.PixelAverage; %SynapseAverage,PixelAverage,rawAverageResponse,SWSynapseAverage,SynapseAverage
                                WellTime(:,i)=tr{i}.time;
                            end
                            
                            mW = findBaseFluorPoints(mean(Wellavg,2)',bcp,0)';
                            wT = mean(WellTime,2);
                            if size(mW,1)==size(plateAvg,1) % Check length recordings
                                plateAvg(:,k) = mW;
                                plateTime(:,k) = wT;
                                
                            else % Change the size of the shortest to the longest recording by adding zeros.
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
                        %figure(1);
                        if size(node,1)==1 %Single compound selection, => show all plates avg.
                            try
                                plot( plateTime(:,k),plateAvg(:,k),'color',thecolor(mod(sel-1,6)+1,:),'LineWidth',3); %PixelAverage,rawAverageResponse
                            catch
                                plot( plateTime(:,k),plateAvg(:,k),'color',thecolor(mod(sel-1,6)+1,:),'LineWidth',3); %PixelAverage,rawAverageResponse
                            end
                            hold on;
                        end
                    end
            end
            
            switch level
                case 1
                     legendLabels{sel}=node(sel).Text;  
                case 2
                    if isIncluded
                        legendLabels={dcs(c).name};
                    end
                case 3
                case 4
            end
         
            compoundAvg{sel}=findBaseFluorPoints(mean(plateAvg,2)',bcp,0)';
            compoundTime{sel}=mean(plateTime,2);
            %figure(1);
            if (nSelections>1) || (level==1)% if multiple selections, show compound Avg
                plot(compoundTime{sel},compoundAvg{sel},'color',thecolor(mod(sel-1+1,6)+1,:),'LineWidth',8); %PixelAverage,rawAverageResponse
                hold on;
            end
        end
        legend(legendLabels);
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
