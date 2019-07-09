function viewTraces(inputDir)

if nargin<1
    inputDir=uigetdir('','Select the output dir in the analysis folder.');
end
dcs=dir([inputDir '\*.csv']); % Directory Csv'S

for i=1:length(dcs)
    daTab{i} = readtable([inputDir '\' dcs(i).name]);
    dataT(:,:,i) = table2array(daTab{i});
end
try
    aw = readtable([inputDir '\' 'AllWells.txt']);
    as = readtable([inputDir '\' 'AllSynapses.txt']);
%     plate.plateValues=reshape(1:96,12,8)'; %logical=Matlab subplot numbering
%     plate.expwells=aw.AndorWellNumber([aw.FileNumber]+1); % The file2wellnumbers
%     logicalPosition = getPlateValue(plate,extractNumber({dcs.name})); % For all files, extract filename and get logical plateNumber
    % logicalPosition gives the logical postion of the data on a 96 well plate. dataIndex=>logicalPlatePostion 
    [r,c] = find(aw.FileNumber==extractNumber({dcs(:).name}));
    aw2 = aw(r,:);
    try
    logicalPosition = aw2.logicalWellIndex;
    catch
        disp('rerun readResults, AllWells.txt is outdated.');
        error(e);
    end
    awT=table2array(aw2);
    awT=reshape(awT',[1,size(awT,2),size(awT,1)]);
    
catch e
    warning ('No AllWells file found, showing files alphabetically!')
    text(0,0,'No AllWells file found, showing files alphabetically!')
    logicalPosition =1:length(dcs);
end
%%

fTrace = figure('Name','Plate Trace Viewer');
javaFrame = get(fTrace,'JavaFrame');
try
    javaFrame.setFigureIcon(javax.swing.ImageIcon([ctfroot '\S3T\PlateLayout_icon.png']));
catch
    javaFrame.setFigureIcon(javax.swing.ImageIcon([pwd '\PlateLayout_icon.png']));
end

statusDisp = uicontrol('Style', 'text', 'String', ['OK'],...
    'Position', [0 0 75 25]);


autoscaleOn=1;
tmax=max(max(max(dataT(:,2:end,:))));
tmin=min(min(min(dataT(:,2:end,:))));

dirTxt = uicontrol('Style', 'Text', 'String', inputDir,...
    'Position', [10 910 800 25] , 'HorizontalAlignment','left'...%'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08]...
    );

dataViewerBtn = uicontrol('Style', 'pushbutton', 'String', 'Data Viewer',...
    'Position', [20 890 160 25] , 'HorizontalAlignment','left',...%'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08]...
    'Callback', @openDataViewer);


plotType = uicontrol('Style', 'popup', 'String', {'normal', 'hist','boxplot'},...
    'Position', [10 400 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
    'CallBack',@changePlotType );

stimLstX = uicontrol('Style', 'popup', 'String', [daTab{1}.Properties.VariableNames],...
    'Position', [10 60 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
    'CallBack',@changeX );

stimLstY = uicontrol('Style', 'popup', 'String', [daTab{1}.Properties.VariableNames],...
    'Position', [10 80 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
    'CallBack',@updatePlot );

autoScaleChk = uicontrol('Style', 'checkbox', 'String',' ',...
    'Position', [10 180 10 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
    'CallBack',@autoScaleToggle);
autoScaleChk.Value = autoscaleOn;

maxTxt = uicontrol('Style', 'edit', 'String', num2str(tmax),...
    'Position', [100 180 50 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
    'CallBack',@updateMax );

minTxt = uicontrol('Style', 'edit', 'String',num2str(tmin),...
    'Position', [30 180 50 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
    'CallBack',@updateMin );
stimLstY.Value=2;
stimLstX.Value=1;
plotType.Value=1;

heatOnChk = uicontrol('Style', 'checkbox', 'String','Heat map',...
    'Position', [10 300 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
    'CallBack',@heatToggle);

synapseChk = uicontrol('Style', 'checkbox', 'String','Synapses On',...
    'Position', [10 280 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
    'CallBack',@synapseToggle);

tracesChk = uicontrol('Style', 'checkbox', 'String','Traces On',...
    'Position', [10 320 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
    'CallBack',@traceToggle);

pngChk = uicontrol('Style', 'checkbox', 'String','Png On',...
    'Position', [10 340 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
    'CallBack',@pngToggle);

txtChk = uicontrol('Style', 'checkbox', 'String','Text On',...
    'Position', [10 360 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
    'CallBack',@txtToggle);
wellViewChk = uicontrol('Style', 'checkbox', 'String','Well View',...
    'Position', [10 380 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
    'CallBack',@wellViewToggle);

wellViewNbField = uicontrol('Style', 'listbox', 'String',{num2str((1:96)')},...
    'Position', [100 385 50 15], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
    'CallBack',@updateWellViewNb);


heatOn = 0;
traceOn = 1;
synapseOn=0;
pngOn = 0;
txtOn = 1;
wellViewOn = 0;
tracesChk.Value = traceOn;
synapseChk.Value = synapseOn;
txtChk.Value = txtOn;
imageTypes = 0;
isStarted = 0;
sp = []; % SubPlots, to accelrate Psubplotting
hh = []; % Plot handles
ImA = [];% Image Handles
wellViewNumber = 15;
%
updatePlot();
%%
    function updateWellViewNb(f,d,e)
        wellViewNumber = str2num(wellViewNbField.String{wellViewNbField.Value});
        updatePlot();
    end

    function openDataViewer(f,d,e)
        dataViewer([inputDir '\AllWells.txt']);
    end

    function imageView()
        names = {...
            'temp','analysis','align','avg','maskBTT','mask','signalsAT','signals'...
            ,'hist','mean','meanAS','changeAS','eigU1'...
            ,'eigU2','eigU3','eigU4','eigU5','eigU6'...
            'eigenNeuron_1R','eigenNeuron_2R','eigenNeuron_3R','eigenNeuron_4R','eigenNeuron_5R'};
        %
        
        imageTypes={};
        vitid=0;
        for iii=1:length(names)
            ffname = names {iii};
            pngFiles=dir([inputDir '\..\' '*' ffname '.png']);
            if ~isempty(pngFiles)
                ims=natsort(pngFiles);
                vitid=vitid+1;
                imageTypes{vitid}=names{iii};
            end
        end
        stimLstY.String=imageTypes;
        stimLstX.String={' '};
        stimLstX.Value=1;
        stimLstY.Value=1;
    end

    function txtToggle(f,d,e)
        if txtOn==0
            txtOn=1;
        else
            txtOn=0;
        end
        isStarted=0;
        updatePlot();
    end
    function pngToggle(f,d,e)
        if pngOn==0
            pngOn=1;
            imageView();
            isStarted=0; 
            updatePlot();
        else
            pngOn=0;
            traceToggle();
        end
        
    end
    function heatToggle(f,d,e)
        if heatOn==0
            heatOn=1
        else
            heatOn=0
        end
        isStarted = 0 ;
        updatePlot();
    end
    function wellViewToggle(f,d,e)
        wellViewOn= wellViewChk.Value;
        isStarted=0;
        updatePlot();
    end

    function synapseToggle(f,d,e)
         synapseOn = synapseChk.Value;
        traceToggle();
    end

    function traceToggle(f,d,e)
    traceOn= tracesChk.Value;
    if synapseOn==1
        stimLstX.String=as.Properties.VariableNames;
        stimLstY.String=as.Properties.VariableNames;
            
    else
        if traceOn==1
            %traceOn=1;
            stimLstX.String=daTab{1}.Properties.VariableNames;
            stimLstY.String=daTab{1}.Properties.VariableNames;
            
        else
            %traceOn=0;
            stimLstX.String={' '};%aw.Properties.VariableNames;
            stimLstY.String=aw.Properties.VariableNames;
        end
    end
        
        % Correct wrong selections 
        if (length(stimLstX.String)<stimLstX.Value)
            stimLstX.Value=1;
        end
        if (length(stimLstY.String)<stimLstY.Value)
            stimLstY.Value=2;
        end
        
        isStarted=0;
        updatePlot();
    end

    function autoScaleToggle(e,f,g)
    autoscaleOn=autoScaleChk.Value;
    isStarted=0;
    updatePlot();
    end

    function updateMax(e,f,g)
        tmax=str2num(maxTxt.String);
        isStarted=0;
        updatePlot();
    end
    function updateMin(e,f,g)
        tmin=str2num(minTxt.String);
        isStarted=0;
        updatePlot();
    end
    function setMin(val)
        tmin=val;
        minTxt.String=num2str(val);
    end

    function setMax(val)
        tmax=val;
        maxTxt.String=num2str(val);
    end

    function changeX(e,f,g)
            isStarted=0;
            updatePlot();
    end


    function changePlotType(e,f,g)
            isStarted=0;
            updatePlot();
    end


    function updatePlot(e,v,h)
        
        statusDisp.String='updating...';
        drawnow();
     if wellViewOn
         [di]=find(logicalPosition==wellViewNumber);
         fts = di;
         spp = subplot(8,12,1:96);
         title(['Well: ' num2str(wellViewNumber) num2str(di) ' No Data' ]);
         cla();
     else % Show all 96 wells
         fts = 1:length(dcs); % fts: Files To Show         
     end
     
     if synapseOn
         dataT2=0;
     else
         if traceOn
             dataT2=dataT; % Show trace Well daTa
         else
             dataT2=awT; % Show all Wells Table
         end         
     end
     EDCSN = extractNumber({dcs(:).name}); %extracted DCS number
     if plotType.Value == 2 % 2=histogram
         minX=[];
         maxX=[];
         n=[];
         for ii=fts % calculate bounds
             if synapseOn
             tdata =table2array(as(as.FileNumber==EDCSN(ii),stimLstY.Value));
             else
             tdata = dataT2(:,stimLstY.Value,ii);
             end
             [n, histxbounds] = hist(tdata,40);
             maxN(ii)=max(n);
             minX(ii)=min(histxbounds);
             maxX(ii)=max(histxbounds);
         end
         if autoscaleOn
         plateminX=min(minX);
         platemaxX=max(maxX);
         platemaxCounts=max(n);
         else
         plateminX=tmin;
         platemaxX=tmax;
         platemaxCounts=max(n);
             
         end
         histX = linspace(plateminX,platemaxX,40);
     end
      if autoscaleOn || plotType.Value == 3 % 3=boxplot
          if synapseOn
             bpmax=max(table2array(as(:,stimLstY.Value)));
             bpmin=min(table2array(as(:,stimLstY.Value)));
             else
             bpmin = min(min(dataT2(:,stimLstY.Value,:),[],1),[],3);
             bpmax = max(max(dataT2(:,stimLstY.Value,:),[],1),[],3);
          end
               
             setMin(bpmin);
             setMax(bpmax);
      end
     
     
     for ii=fts
         if (isStarted == 0 ) && ~wellViewOn %|| pngOn==0
             sp(ii)=subplot(8,12,logicalPosition(ii));
             %                else
             %                   try  axes(sp(logicalPosition(ii)));
             %                   catch
             %                       subplot(8,12,logicalPosition(ii));
             %                       isStarted=0;
             %                   end
         end
         
         if pngOn
             selImType = imageTypes(stimLstY.Value);
             pngFiles=dir([inputDir '\..\' '*' selImType{1} '.png']);
             ims=natsort(pngFiles);
             %tempImage = imread([inputDir '\..\' ims(ii).name]);
             try
                 tempImage = imread([inputDir '\..\' dcs(ii).name(1:end-11) '.tif_' selImType{1} '.png']);
             catch
                 try
                     tempImage = imread([inputDir '\..\' dcs(ii).name(1:end-11) '_' selImType{1} '.png']);
                 catch
                     warning('Picture not found');
                     tempImage=0;
                 end
             end
             %title(ims(ii).name);pause
             if (~exist('ImA','var')) || (isStarted==0)
                 ImA(ii) = imagesc(tempImage);
             else % Fast image update.
                 set(ImA(ii),'CData',tempImage);
             end
         else
             if heatOn
                 if (~exist('ImA','var')) || (isStarted==0)
                     ImA(ii) = imagesc(dataT2(:,stimLstY.Value,ii)');
                     caxis([tmin tmax]);
                 else % Fast image update.
                     if synapseOn
                         tdata =table2array(as(as.FileNumber==EDCSN(ii),stimLstY.Value));
                     else
                         tdata = dataT2(:,stimLstY.Value,ii);
                     end
                     set(ImA(ii),'CData',tdata');
                 end
             else % No heat image
                     if synapseOn==1
                         tXdata=table2array(as(as.FileNumber==EDCSN(ii),stimLstX.Value));
                         tYdata=table2array(as(as.FileNumber==EDCSN(ii),stimLstY.Value));
                     else
                         tXdata=dataT2(:,stimLstX.Value,ii);
                         tYdata=dataT2(:,stimLstY.Value,ii);
                     end
                     
                 if  (~exist('hh','var')) || (isStarted==0) % If axis don't exist, create axis
                     
                     switch plotType.Value
                         case 1 %normal
                             try
                             hh(ii) = plot(tXdata,tYdata);
                             catch
                                 wahatswronf
                             end
                             axis([min(0,min(tXdata)) max(tXdata)*1.1+1e-6 tmin tmax*1.1 ]);
                         case 2%hist
                             hist(tYdata,histX );
                             axis([plateminX platemaxX 0 platemaxCounts]);
                             hh(ii)=gca();
                         case 3%boxplot
                             boxplot(tYdata);
                             axis([0.5 1.5 bpmin bpmax*1.1 ]);
                             hh(ii)=gca();
                     end
                     
                     
                 else % Fast update
                     switch plotType.Value
                         case 1
                             try 
                                 if autoscaleOn
                                     error();
                                 else
                                     set(hh(ii),'ydata',tYdata);
                                 end
                             catch
                                 subplot(8,12,logicalPosition(ii));
                                 hh(ii) = plot(tXdata,tYdata);
                                 axis([min(0,min(tXdata)) max(tXdata)*1.1+1e-6 tmin tmax*1.1 ]);
                             end
                            
                         case 2
                             try
                                error;
                                hist(hh(ii),tYdata,histX );
                                 axis([plateminX   platemaxX 0 platemaxCounts]);
                             catch
                                 subplot(8,12,logicalPosition(ii));
                                 hist(tYdata,histX );
                                 axis([plateminX   platemaxX 0 platemaxCounts]);
                                 hh(ii)=gca();
                             end
                         case 3
                             %subplot(8,12,logicalPosition(ii));
                        try
                            errror;
                            set(hh(ii));
                            boxplot(tYdata);
                            axis([0.5 1.5 bpmin bpmax*1.1 ]);
                            hh(ii)=gca();
                        catch
                            subplot(8,12,logicalPosition(ii));
                            boxplot(tYdata);
                            axis([0.5 1.5 bpmin bpmax*1.1 ]);
                            hh(ii)=gca();
                        end
                     end
                 end
             end
         end
        % axis tight;
         if txtOn
             if isStarted ==0
                 try
                     titleTxt=(dcs(ii).name(end-15:end-11));
                 catch
                     titleTxt='no data';
                 end
                 if logicalPosition(ii)<13
                     titleTxt = [num2str(logicalPosition(ii)) ':' titleTxt];
                 end
                 axis on
                 title(titleTxt);
             end
         else
             axis off
         end
     end
        
    % Add text and labels to 96 well view.
      if wellViewOn || plotType.Value==3
      else
          if isStarted==0
              
          for ii=1:(8*12)
              if 1%isStarted==0
               % When assigning subplots with boxplot to sp, they got
               % cleared??
                  sp(ii) = subplot(8,12,ii);
                  
              else
                  axes(sp(ii));
              end
            if ii<13
                title(num2str(ii));
            end
            
            if ii==1
                ylabel('A');
            end
            if ii==13
                ylabel('B');
            end
            if ii==25
                ylabel('C');
            end
            if ii==37
                ylabel('D');
            end
            
            if ii==49
                ylabel('E');
            end
            
            if ii==61
                ylabel('F');
            end
            
            if ii==73
                ylabel('G');
            end
            
            if ii==85
                ylabel('H');
            end
          end
          isStarted =1;
      end
      end
      statusDisp.String='OK';
    end
end