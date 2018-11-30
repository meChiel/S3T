function viewTraces(inputDir)

if nargin<1
    inputDir=uigetdir('','Select the output dir in the analysis folder.');
end
dcs=dir([inputDir '\*.csv']); % Directory Csv'S

for i=1:length(dcs)
    daTab{i}=readtable([inputDir '\' dcs(i).name]);
    dataT(:,:,i)= table2array(daTab{i});
end
try
    aw=readtable([inputDir '\' 'AllWells.txt']);
    plate.plateValues=reshape(1:96,12,8)'; %logical=Matlab subplot numbering
    plate.expwells=aw.WellNumber([aw.FileNumber]+1); % The file2wellnumbers
    logicalPosition = getPlateValue(plate,extractNumber({dcs.name})); % For all files, extract filename and get logical plateNumber
    awT=table2array(aw);
    awT=reshape(awT',[1,size(awT,2),size(awT,1)]);
    
catch e
    warning ('No AllWells file found, showing files alphabetically!')
    text(0,0,'No AllWells file found, showing files alphabetically!')
    logicalPosition =1:length(dcs);
end
%%

figure('Name','Plate Trace Viewer');
%f = uifigure('Name','Plate Trace Viewer');
    
tmax=4;max(max(max(dataT(:,2:end,:))));
tmin=min(min(min(dataT(:,2:end,:))));
stimLstX = uicontrol('Style', 'popup', 'String', [daTab{1}.Properties.VariableNames],...
    'Position', [10 60 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
    'CallBack',@updatePlot );

stimLstY = uicontrol('Style', 'popup', 'String', [daTab{1}.Properties.VariableNames],...
    'Position', [10 80 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
    'CallBack',@updatePlot );

maxTxt = uicontrol('Style', 'edit', 'String', num2str(tmax),...
    'Position', [10 160 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
    'CallBack',@updateMax );

minTxt = uicontrol('Style', 'edit', 'String',num2str(tmin),...
    'Position', [10 180 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
    'CallBack',@updateMin );
stimLstY.Value=2;
stimLstX.Value=1;

heatOnChk = uicontrol('Style', 'checkbox', 'String','Heat map',...
    'Position', [10 300 150 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
    'CallBack',@heatToggle);

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
    'Position', [100 380 50 15], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
    'CallBack',@updateWellViewNb);


heatOn = 0;
traceOn = 1;
pngOn = 0;
txtOn = 1;
wellViewOn = 0;
tracesChk.Value = traceOn;
txtChk.Value = txtOn;
imageTypes = 0;
isStarted = 0;
sp = []; % SubPlots, to accelrate Psubplotting

wellViewNumber = 15;
%
updatePlot();
    function updateWellViewNb(f,d,e)
        wellViewNumber = str2num(wellViewNbField.String{wellViewNbField.Value});
        updatePlot();
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
    end
    function txtToggle(f,d,e)
        if txtOn==0
            txtOn=1;
        else
            txtOn=0;
        end
        updatePlot();
    end
    function pngToggle(f,d,e)
        if pngOn==0
            pngOn=1;
            imageView();
        else
            pngOn=0;
        end
        updatePlot();
    end
    function heatToggle(f,d,e)
        if heatOn==0
            heatOn=1
        else
            heatOn=0
        end
        updatePlot();
    end
    function wellViewToggle(f,d,e)
        if wellViewOn==0
            wellViewOn=1
        else
            wellViewOn=0
        end
        updatePlot();
    end
    function traceToggle(f,d,e)
        if traceOn==0
            traceOn=1;
            stimLstX.String=daTab{1}.Properties.VariableNames;
            stimLstY.String=daTab{1}.Properties.VariableNames;
        else
            traceOn=0;
            stimLstX.String={};%aw.Properties.VariableNames;
            stimLstY.String=aw.Properties.VariableNames;
        end
        updatePlot();
    end
    function updateMax(e,f,g)
        tmax=str2num(maxTxt.String);
        updatePlot();
    end
    function updateMin(e,f,g)
        tmin=str2num(minTxt.String);
        updatePlot();
    end
    function updatePlot(e,v,h)
     if wellViewOn
         [d, di]=find(logicalPosition==wellViewNumber);
         fts= di;
         title(['Well: ' num2str(wellViewNumber) num2str(di) ' No Data' ]);
         cla();
     else
         fts=1:length(dcs); % fts: Files To Show
     end
        for ii=fts
            if wellViewOn
                spp = subplot(8,12,1:96);
            else
                if 1%isStarted == 0
                  subplot(8,12,logicalPosition(ii));
               else
                    axes(sp(logicalPosition(ii)));
                end
            end
            
            if traceOn
                dataT2=dataT;
            else
                dataT2=awT;
            end
            if pngOn
                selImType = imageTypes(stimLstY.Value);
                pngFiles=dir([inputDir '\..\' '*' selImType{1} '.png']);
                ims=natsort(pngFiles);
                tempImage = imread([inputDir '\..\' ims(ii).name]);
                imagesc(tempImage);
            else
                if heatOn
                    imagesc(dataT2(:,stimLstY.Value,ii)');
                    caxis([tmin tmax]);
                else
                    plot(dataT2(:,stimLstX.Value,ii),dataT2(:,stimLstY.Value,ii));
                    axis([min(0,min(dataT2(:,stimLstX.Value,ii))) max(dataT2(:,stimLstX.Value,ii))*1.1+1e-6 tmin tmax*1.1 ]);
                end
            end
            if txtOn
                titleTxt=(dcs(ii).name(end-15:end-11));
                if logicalPosition(ii)<13
                    titleTxt = [num2str(logicalPosition(ii)) ':' titleTxt];
                end
                
                title(titleTxt);
            else
                axis off
            end
        end
      if wellViewOn
      else
          for ii=1:(8*12)
              if 1%isStarted==0
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
end