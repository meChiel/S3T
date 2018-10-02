function viewTraces(d)
if nargin<1
    d=uigetdir();
end
dcs=dir([d '\*.csv']); % Directory Csv'S
for i=1:length(dcs)
    daTab{i}=readtable([d '\' dcs(i).name]);
    dataT(:,:,i)= table2array(daTab{i});
end
try
    aw=readtable([d '\' 'AllWells.txt']);
    plate.plateValues=reshape(1:96,12,8)'; %logical=Matlab subplot numbering
    plate.expwells=aw.WellNumber([aw.FileNumber]+1); % The file2wellnumbers
    logicalPosition = getPlateValue(plate,extractNumber({dcs.name})); % For all files, extract filename and get logical plateNumber
    
catch e
    warning ('No plate overview file found, showing files alphabetically!')
    text(0,0,'No plate overview file found, showing files alphabetically!')
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

%
updatePlot();


    function updateMax(e,f,g)
        tmax=str2num(maxTxt.String);
        updatePlot();
    end
    function updateMin(e,f,g)
        tmin=str2num(minTxt.String);
        updatePlot();
    end
    function updatePlot(e,v,h)
        for ii=1:length(dcs)
            subplot(8,12,logicalPosition(ii));
            plot(dataT(:,stimLstX.Value,ii),dataT(:,stimLstY.Value,ii))
            axis([0 max(dataT(:,stimLstX.Value,ii))*1.1 tmin tmax*1.1 ]);
            % axis ('off')
            titleTxt=(dcs(ii).name(end-15:end-11));
            if logicalPosition(ii)<13
                titleTxt = [num2str(logicalPosition(ii)) ':' titleTxt];
            end
            
            title(titleTxt);
        end
      
          for ii=1:(8*12)
            subplot(8,12,ii);
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
        
    end
end