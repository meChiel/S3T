function ffhandles=analysisCfgGenerator()
global ptitle3 NOStxt3 stimFreqtxt3 OnOffsettxt3 fpsTxt3 DCOFtxt3 DCOF2txt NOS2txt  stimFreq2txt data trace ...
    OnOffsettxt2;
global frameSelectionTxt frameSelection maskTimeProjLst SVDLst SVDtxt createDictBtn createDicttxt ...
    PhotoBleachLst PhotoBleach ...
    ReuseMaskChkBx ReloadMovieChkBx FastLoadChkBx CellBodytypeLst ...
    skipMovieChkBx WriteSVDChkBx AnalysistypeLst NumAvgSamples ...
    MpreCtxt MpostCtxt numAvgSamplesTxt MpreC MpostC;
global CellBodytype skipMovie WriteSVD;
stimCfgFN.folder='c:\';

ffhandles.generate=@generate;

NOS3=1;
NOS2=1;
stimFreq3=.2;
stimFreq2=0;
OnOffset3=33;
OnOffset2=0;
fps3=33;
dutyCycleOnFrames3=0;
dutyCycleOnFrames2=0;
SVDNumber = 2;
maskTimeProj='SVD';
PhotoBleach='linInt'; %linInt or 2expInt
FastLoad=0;ReloadMovie=1;ReuseMask=0;
Analysistype='0'; %Still to decide but is idea to have 10AP, 5x1AP, options
% or sponatinous vs stimulated?
CellBodytype=0;
skipMovie=0;
WriteSVD=1;

bgc=[.35 .35 .38];
%bgc=[.95 .95 .95];
f2 = figure('Visible','on','name','S3T: analysis Configuration tool',...
    'Color',bgc,...
    'NumberTitle','off');
set(f2,'MenuBar', 'figure');
javaFrame = get(f2,'JavaFrame');
try
    javaFrame.setFigureIcon(javax.swing.ImageIcon([ctfroot '\S3T\PlateLayout_icon.png']));
catch
    javaFrame.setFigureIcon(javax.swing.ImageIcon(['PlateLayout_icon.png']));
end


createInputFields();
    function createInputFields()
        NOStxt3 = uicontrol('Style', 'Edit', 'String', num2str(NOS3),...
            'Position', [20 by(-4) 50 20],...
            'Callback', @doSetNOS);
        uicontrol('Style', 'text', 'String', 'Number of Stim.',...
            'Position', [70 by(-4) 100 20]);
        
        NOS2txt = uicontrol('Style', 'Edit', 'String', num2str(NOS2),...
            'Position', [220 by(-4) 50 20],...
            'Callback', @doSetNOS2);
        uicontrol('Style', 'text', 'String', 'Number of part Stim.',...
            'Position', [270 by(-4) 100 20]);
        
        frameSelectionTxt = uicontrol('Style', 'Edit', 'String', '[1:end]',...
            'Position', [20 by(1) 50 20],...
            'Callback', @doSetFrameSelection);
        uicontrol('Style', 'text', 'String', 'Frame Selection.',...
            'Position', [70 by(1) 100 20]);
        
        DCOFtxt3 = uicontrol('Style', 'Edit', 'String', num2str(dutyCycleOnFrames3),...
            'Position', [20 by(-1) 50 20],...
            'Callback', @doSetDCOF);
        uicontrol('Style', 'text', 'String', 'duty-Cycle On Frames',...
            'Position', [70 by(0) 100 40]);
        
        DCOF2txt = uicontrol('Style', 'Edit', 'String', num2str(dutyCycleOnFrames2),...
            'Position', [220 by(-1) 50 20],...
            'Callback', @doSetDCOF2);
        uicontrol('Style', 'text', 'String', ' Partial duty-Cycle On Frames',...
            'Position', [270 by(0) 100 40]);
        
        stimFreqtxt3 = uicontrol('Style', 'Edit', 'String', num2str(stimFreq3),...
            'Position', [20 by(-3) 50 20],...
            'Callback', @doSetStimFreq);
        uicontrol('Style', 'text', 'String', 'Stim. freq.',...
            'Position', [70 by(-3) 100 20]);
        
        stimFreq2txt = uicontrol('Style', 'Edit', 'String', num2str(stimFreq2),...
            'Position', [220 by(-3) 50 20],...
            'Callback', @doSetStimFreq2);
        uicontrol('Style', 'text', 'String', 'Stim. partial freq.',...
            'Position', [270 by(-3) 100 20]);
        
        OnOffsettxt3 = uicontrol('Style', 'Edit', 'String', num2str(OnOffset3),...
            'Position', [20 by(-2) 50 20],...
            'Callback', @doSetOnOffset);
        uicontrol('Style', 'text', 'String', 'Stim. delay',...
            'Position', [70 by(-2) 100 20]);
        
        OnOffsettxt2 = uicontrol('Style', 'Edit', 'String', num2str(OnOffset2),...
            'Position', [220 by(-2) 50 20],...
            'Callback', @doSetOnOffset2);
        uicontrol('Style', 'text', 'String', 'Stim. part delay',...
            'Position', [270 by(-2) 100 20]);
        
        fpsTxt3 = uicontrol('Style', 'Edit', 'String', num2str(fps3),...
            'Position', [20 by(-7) 50 20],'Callback', @doSetFPS);
        setFPSBtn = uicontrol('Style', 'text', 'String', 'frames per second',...
            'Position', [20+50 by(-7) 150 20],...
            'Callback', @doSetFPS);
        
        
        
        numAvgSamplesTxt = uicontrol('Style', 'Edit', 'String', num2str(fps3),...
            'Position', [20 by(6) 50 20],'Callback', @doSetNumAvgSamples);
        numAvgSamplesTxttt = uicontrol('Style', 'text', 'String', 'number of samples to calc average',...
            'Position', [20+50 by(6) 200 20],...
            'Callback', @doSetNumAvgSamples);
        
        maskTimeProjLst = uicontrol('Style', 'popup', 'String', {'SVD','STD','SVM','NN','NMF','DICT'},...
            'Position', [20 by(3) 50 20],...
            'Callback', @doSetMaskTimeProj);
        
        uicontrol('Style', 'text', 'String', 'Mask creation Time Projection method',...
            'Position', [20+50 by(3) 200 20]);
        
        SVDLst = uicontrol('Style', 'popup', 'String', {'1','2','3','4','Pop-up'},...
            'Position', [20 by(4) 50 20],...
            'Callback', @doSetSVDNumber);
        SVDtxt = uicontrol('Style', 'text', 'String', 'Set the SVD number',...
            'Position', [20+50 by(4) 200 20]);
        
        createDictBtn = uicontrol('Style', 'pushbutton', 'String', 'Gen. Temp. Ref.',...
            'Position',  [20 by(4) 50 20],...
            'Callback', @doCreateRef);
        
        createDicttxt = uicontrol('Style', 'text', 'String', 'Create temporal Reference Dictionaire',...
            'Position', [20+50 by(4) 200 20]);
        
         createDictBtn.Visible='off';
         createDicttxt.Visible='off';
        
        PhotoBleachLst = uicontrol('Style', 'popup', 'String', {'linInt','2expInt','auto2expInt','autoLinInt'},...
            'Position', [20 by(5) 50 20],...
            'Callback', @doSetPhotoBleach);
        PhotoBleachtxt = uicontrol('Style', 'text', 'String', 'Photo Bleaching correction Method',...
            'Position', [20+50 by(5) 200 20]);
        
        
        FastLoadChkBx = uicontrol('Style', 'CheckBox', 'String', 'Fast Load',...
            'Position', [20 by(7) 150 20],...
            'Callback', @doSetFastLoad);
        ReloadMovieChkBx = uicontrol('Style', 'CheckBox', 'String', 'Reload Movie',...
            'Position', [20 by(8) 150 20],...
            'Callback', @doSetReloadMovie);
        ReuseMaskChkBx = uicontrol('Style', 'CheckBox', 'String', 'ReuseMask',...
            'Position', [20 by(9) 150 20],...
            'Callback', @doSetReuseMask);
        
        AnalysistypeLst = uicontrol('Style', 'popup', 'String', {'0','Stimulated','Spontanious'},...
            'Position', [420 by(5) 50 20],...
            'Callback', @doSetAnalysistype);
        uicontrol('Style', 'text', 'String', 'Analysis Type',...
            'Position', [420+50 by(5) 200 20]);
        
        CellBodytypeLst = uicontrol('Style', 'popup', 'String', {'Synapse','cell Body'},...
            'Position', [420 by(6) 50 20],...
            'Callback', @doSetCellBodytype);
        uicontrol('Style', 'text', 'String', 'Cell Type',...
            'Position', [420+50 by(6) 200 20]);
        
        skipMovieChkBx = uicontrol('Style', 'CheckBox', 'String', 'skipMovie',...
            'Position', [420 by(7) 150 20],...
            'Callback', @doSetSkipMovie);
        WriteSVDChkBx = uicontrol('Style', 'CheckBox', 'String', 'WriteSVD',...
            'Position', [420 by(8) 150 20],...
            'Callback', @doSetWriteSVD);
        
          uicontrol('Style', 'text', 'String', 'M pre-Command',...
            'Position', [700 by(-11.2) 100 20],'BackgroundColor',bgc);
        MpreCtxt = uicontrol('Style', 'Edit', 'String', '',...
            'Position', [700 by(-4) 600 150],...
            'Max',2,...
            'HorizontalAlignment','left',...
            'Callback', @doSetPreCommand);
      
        
        uicontrol('Style', 'text', 'String', 'M post-Command',...
            'Position', [700 by(-.2) 100 20],'BackgroundColor',bgc);
        MpostCtxt = uicontrol('Style', 'Edit', 'String', '',...
            'Position', [700 by(7) 600 150],...
            'Max',2,...
            'HorizontalAlignment','left',...
            'Callback', @doSetPostCommand);
       
        setFastLoad(FastLoad);
        setReloadMovie(ReloadMovie);
        setReuseMask(ReuseMask);
        setSVDNumber(SVDNumber);
        
        setAnalysistype(Analysistype);
        setCellBodytype(CellBodytype);
        setSkipMovie(skipMovie);
        setDCOF(dutyCycleOnFrames3);
        setDCOF2(dutyCycleOnFrames2);
        setWriteSVD(WriteSVD);
        
    end
createTitleUI()
    function createTitleUI()
        ptitle3 = uicontrol('Style', 'edit', 'String', '1AP',...
            'Position', [240 390 100 20]);
    end
createButtonsUI();
    function createButtonsUI()
        
      
        
        uicontrol('Style', 'pushbutton', 'String', 'Generate',...
            'Position', [400 30+100 150 100],...
            'Callback', @doGenerate);
        uicontrol('Style', 'pushbutton', 'String', 'Load',...
            'Position', [400 30+200 150 20],...
            'Callback', @loadSettings);
        uicontrol('Style', 'pushbutton', 'String', 'Reset',...
            'Position', [400 30+300 150 20],...
            'Callback', @resetPlate);
        
        uicontrol('Style', 'pushbutton', 'String', 'Load Example Movie',...
            'Position', [400 30+350 150 20],...
            'Callback', @loadMovie);
        
    end
    function loadMovie(e,r,t)
        [fn, di, pn]=uigetfile( [stimCfgFN.folder '*.tif*']);
        if di
           ti = strfind(fn,'.tif');
            stimCfgFN.folder=di;
            stimCfgFN.name=fn(1:(ti+3));
            fn=stimCfgFN.name;
            try % Fast load
                [data, pathname, fname, dirname] = loadTiff([di fn],1);%'c:',1);
            catch % If fast load not possible, do normal load
                [data, pathname, fname, dirname] = loadTiff([di fn],0);%'c:',1);
            end
            trace=mean(reshape(data,size(data,1)*size(data,2),[]),1);
            subplot(4,4,1);
            plot(trace);
        end
        
    end
    function a=by(a)
        a=200-20*a;
    end
    function doUpdateFold(d,f,t)
        settings.NOS = NOS3;
        settings.dCOF = dutyCycleOnFrames3;
        settings.dCOF2 = dutyCycleOnFrames2;
        settings.OnOffset = OnOffset3;
        settings.OnOffset2 = OnOffset2;
        settings.NOS2 = NOS2;
        settings.fps = fps3;
        settings.stimFreq = stimFreq3;
        settings.stimFreq2 = stimFreq2;
        
        updateFold(settings);
    end
    function drawLines1(settings)
        s=settings;
        subplot(4,4,1);
        hold off;
        plot(trace);
        mt=min(trace);
        Mt=max(trace);
        title('Original trace')
        hold on
      %  plot(s.OnOffset *[1 1],[mt Mt],'r');
      
      
      if dutyCycleOnFrames3==0
          dcof3=s.fps/s.stimFreq ;
      else
          dcof3 = dutyCycleOnFrames3;
      end
        for ii=0:(s.NOS-1)
            plot(s.OnOffset *[1 1]+(ii)*s.fps/s.stimFreq ,[mt Mt],'r'); % first |
            
            plot([s.OnOffset *[1]+(ii)*s.fps/s.stimFreq ...
                s.OnOffset *[1]+(ii)*s.fps/s.stimFreq + dcof3 ],...
                [Mt Mt],'r'); % on frames 
            
            plot(s.OnOffset *[1 1]+(ii)*s.fps/s.stimFreq + dcof3 ,...
            [mt Mt],'r'); % on to off | 
             
%             plot([s.OnOffset *[1]+(ii)*s.fps/s.stimFreq ...
%                 s.OnOffset *[1]+(ii)*s.fps/s.stimFreq + dcof3 ],...
%                 [mt mt],'r'); % off frames
            
            plot([s.OnOffset *[1]+(ii+1)*s.fps/s.stimFreq ...
                s.OnOffset *[1]+(ii)*s.fps/s.stimFreq  ],...
                [mt mt],'r'); % off frames
            
            
            plot(s.OnOffset *[1 1]+(ii+1)*s.fps/s.stimFreq ,[Mt Mt],'r'); % end |
        end
        
        % Black lines for partial processing
        
        if dutyCycleOnFrames2==0
            dcof2=min(dutyCycleOnFrames3,s.fps/s.stimFreq2) ;
        else
            dcof2 = dutyCycleOnFrames2;
        end
        
       % plot(s.OnOffset *[1 1],[mt mt+0.9*(Mt-mt)],'k');
        for ii=0:(s.NOS-1)
            for iii=0:(s.NOS2-1)
                plot(s.OnOffset *[1 1]+s.OnOffset2 *[1 1]+(ii)*s.fps/s.stimFreq+(iii)*s.fps/s.stimFreq2 ,[mt mt+0.95*(Mt-mt)],'k');
                
                plot(s.OnOffset *[1 1]+s.OnOffset2 *[1 1]+(ii)*s.fps/s.stimFreq+(iii)*s.fps/s.stimFreq2 + dcof2 ,[mt mt+0.95*(Mt-mt)],'k'); % On to off |
                
                plot(s.OnOffset *[1 1]+s.OnOffset2 *[1 1]+(ii)*s.fps/s.stimFreq+(iii+1)*s.fps/s.stimFreq2 ,[mt mt+0.95*(Mt-mt)],'k'); % On to off |
                
                plot([s.OnOffset *[1]+s.OnOffset2 *[1]+(ii)*s.fps/s.stimFreq+(iii)*s.fps/s.stimFreq2 ...
                    s.OnOffset *[1]+s.OnOffset2 *[1]+(ii)*s.fps/s.stimFreq+(iii)*s.fps/s.stimFreq2 + dcof2],...
                    mt+0.95*(Mt-mt)*[1 1],'k'); % On to off |
            end
        end
        %   NOS=1;
        %   stimFreq=.2;
        %   OnOffset=33;
    end
    function updateFold(settings)
        subplot(4,4,1);
        plot(trace);
        title('Original trace');
        drawLines1(settings);
        subplot(4,4,5);
        traceFrames=[];
        eval(['traceFrames=trace(' frameSelection ');']);
        plot(traceFrames);
        title('trace Frames');
        
        subplot(4,4,2);
        part = foldData(traceFrames,settings);
        subplot(4,4,6);
        plot(part);
        title('Avg trace folding');
        subplot(4,4,3);
        part2 = multiResponseto1(traceFrames,0,settings);
        subplot(4,4,7);
        
        plot(part2);
        subplot(4,4,4);
        part3 = foldData2(part2,settings);
        title('partial trace folding');
        subplot(4,4,8);
        plot(part3);
    end
    function doGenerate(e,g,h)
        generate;
    end
    function generate(e,g,h)
        
        %   NOS=1;
        %   stimFreq=.2;
        %   OnOffset=33;
        
        analysisName = get(ptitle3,'String');
        if ~isfield(stimCfgFN,'name')
            stimCfgFN.name='';
        end
        specificAnalysis=1;
        if specificAnalysis
            [FileName,PathName,FilterIndex] = uiputfile([stimCfgFN.folder '*.xml'],'Save Analysis Configuration: specify file',[stimCfgFN.folder '\' stimCfgFN.name '_' analysisName '_Analysis.xml']);
        else
            [FileName,PathName,FilterIndex] = uiputfile([stimCfgFN.folder '*.xml'],'Save Analysis Configuration',[stimCfgFN.folder analysisName '_Analysis.xml']);
        end
        if PathName
            stimCfgFN.folder=PathName;
            fid = fopen([PathName FileName],'w');
            
            %'<Name>Frequency (Hz)</Name>\n<Val>0.20000000000000</Val>'
            %         dd1='<Name>Frequency (Hz)</Name>\n<Val>%6.13f</Val>';
            %         fprintf(fid,dd1,stimFreq3);
            
            %fwrite('blabla','char');
            %'<Name>Pulse width (ms)</Name>\r\n<Val>1.00000000000000</Val>'
            %         dd2='\r\n\r\n<Name>Pulse width (ms)</Name>\r\n<Val>%5.13f</Val>';
            %         fprintf(fid,dd2,stimFreq);
            
            i=1;
            field(i).Name = 'Stimulation Frequency (Hz)';
            field(i).Value = num2str(stimFreq3);
            i=i+1;
            field(i).Name = 'Delay Time (ms)';
            field(i).Value = num2str(OnOffset3/fps3*1000);
            i=i+1;
            field(i).Name = 'Pulse count';
            field(i).Value = num2str(NOS3);
            i=i+1;
            field(i).Name = 'Partial Stimulation Frequency (Hz)';
            field(i).Value = num2str(stimFreq2);
            i=i+1;
            field(i).Name = 'Partial Delay Time (ms)';
            field(i).Value = num2str(OnOffset2/fps3*1000);
            i=i+1;
            field(i).Name = 'Partial Pulse count';
            field(i).Value = num2str(NOS2);
            i=i+1;
            field(i).Name = 'Frame Selection';
            field(i).Value = frameSelectionTxt.String;
            i=i+1;
            field(i).Name = 'Mask Creation Time Projection';
            field(i).Value = maskTimeProj;
            i=i+1;
            field(i).Name = 'Eigenvalue Number';
            field(i).Value = num2str(SVDNumber);
            i=i+1;
            field(i).Name = 'Reuse Mask';
            field(i).Value = num2str(ReuseMask);
            i=i+1;
            field(i).Name = 'Reload Movie';
            field(i).Value = num2str(ReloadMovie);
            i=i+1;
            field(i).Name = 'Fast Load';
            field(i).Value = num2str(FastLoad);
            i=i+1;
            field(i).Name = 'Photo Bleaching';
            field(i).Value = num2str(PhotoBleach);
            i=i+1;
            field(i).Name = 'Write SVD';
            field(i).Value = num2str(WriteSVD);
            i=i+1;
            field(i).Name = 'duty Cycle (frames)';
            field(i).Value = num2str(dutyCycleOnFrames3);
            i=i+1;
            field(i).Name = 'Partial Duty Cycle (frames)';
            field(i).Value = num2str(dutyCycleOnFrames2);
            i=i+1;
            field(i).Name = 'Skip Movie';
            field(i).Value = num2str(skipMovie);
            i=i+1;
            field(i).Name = 'Cell Body Type';
            field(i).Value = num2str(CellBodytype);
            i=i+1;
            field(i).Name = 'Analysis Type';
            field(i).Value = num2str(Analysistype);
            i=i+1;
            field(i).Name = 'Number Average Samples';
            field(i).Value = num2str(NumAvgSamples);
            i=i+1;
            field(i).Name = 'Matlab Pre-Commands';
            field(i).Value = MpreC;
            i=i+1;
            field(i).Name = 'Matlab Post-Commands';
            field(i).Value = MpostC;
            i=i+1;
            
            for i=1:length(field)
                dd4=['\r\n\r\n<Name>'   field(i).Name '</Name>\r\n<Val>%s</Val>'];
                fprintf(fid,dd4, field(i).Value);
            end
            
            %'Camera Exposure Time (s) - 0.03'
            dd5='\r\n\r\nCamera Exposure Time (s) - %5.5f\r\n';
            fprintf(fid,dd5,1/fps3);
            fclose(fid);
            disp(['Analysis writen to ' PathName FileName]);
        else
            disp(['Analysis write cancelled.']);
        end
    end
    function loadSettings(e,g,h)
        [ stimCfgFN.name, folderReturn] = uigetfile([stimCfgFN.folder '*.xml']);
        if folderReturn
            stimCfgFN.folder=folderReturn;
        end
        stimCfg = xmlSettingsExtractor(stimCfgFN);
        setNOS(stimCfg.pulseCount);
        setNOS2(stimCfg.pulseCount2);
        setFPS(stimCfg.imageFreq);
        setOnOffset(round(stimCfg.delayTime*stimCfg.imageFreq/1000));
        setOnOffset2(round(stimCfg.delayTime2*stimCfg.imageFreq/1000));
        
        setStimFreq(stimCfg.stimFreq);
        setStimFreq2(stimCfg.stimFreq2);
        setFastLoad(stimCfg.fastLoad);
        setReuseMask(stimCfg.reuseMask);
        setReloadMovie(stimCfg.reloadMovie);
        setCellBodytype(stimCfg.cellBody);
        setDCOF(stimCfg.dutyCycle);
        setDCOF(stimCfg.dutyCycle2);
        setSVDNumber(stimCfg.eigenvalueNumber);
        setFrameSelection(stimCfg.FrameSelectionTxt);
        setMaskTimeProj(stimCfg.maskTimeProjectionMethod);
        setPreCommand(stimCfg.preCommand);
        setPostCommand(stimCfg.postCommand);
        setNumAvgSamples(stimCfg.NumAvgSamples);
        setPhotoBleach(stimCfg.PhotoBleachingTxt);
        setSkipMovie(stimCfg.skipMovie);
        setWriteSVD(stimCfg.writeSVD);
    end
    function doSetPreCommand(f,g,h)
        setPreCommand(MpreCtxt.String);
    end
    function setPreCommand(MpreC2)
        %convert to 1 string with ENTER
        MpreC3='';
        for i=1:size(MpreC2,1)
            MpreC3 = [MpreC3 MpreC2(i,:) 'ENTER'];%
        end
        MPreCellArray= text2cell(MpreC3);
        
        % Allocate space for char matrix and fill
        ml=0;
        for i=1:length(MPreCellArray)
         ml=max(ml, size(MPreCellArray{i},2));
        end

        MPreArray=char(zeros(length(MPreCellArray),ml));
        for i=1:length(MPreCellArray)
            MPreArray(i,1:size(MPreCellArray{i},2))=MPreCellArray{i};
        end
        
        % Create 1 line string for export
        MpreC=[];
        for i=1:length(MPreCellArray)
           MpreC = [MpreC MPreCellArray{i} 'ENTER'];%
        end
        
        % Set as the text input.
        MpreCtxt.String=MPreArray;
    end
    function doSetPostCommand(f,g,h)
        setPostCommand(MpostCtxt.String);
    end
    function setPostCommand(MpostC2)
          %convert to 1 string with ENTER
        MpostC3='';
        for i=1:size(MpostC2,1)
            MpostC3 = [MpostC3 MpostC2(i,:) 'ENTER'];%
        end
        MPostCellArray= text2cell(MpostC3);
        
        % Allocate space for char matrix and fill
        ml=0;
        for i=1:length(MPostCellArray)
         ml=max(ml, size(MPostCellArray{i},2));
        end

        MPostArray=char(zeros(length(MPostCellArray),ml));
        for i=1:length(MPostCellArray)
            MPostArray(i,1:size(MPostCellArray{i},2))=MPostCellArray{i};
        end
        
        % Create 1 line string for export
        MpostC=[];
        for i=1:length(MPostCellArray)
           MpostC = [MpostC MPostCellArray{i} 'ENTER'];%
        end
        
        % Set as the text input.
        MpostCtxt.String=MPostArray;
    end
    function doSetReuseMask(s,e,h)
        setReuseMask(ReuseMaskChkBx.Value);
    end
    function setReuseMask(method)
        ReuseMask = method;
        ReuseMaskChkBx.Value=method;
    end
    function doSetReloadMovie(s,e,h)
        setReloadMovie(ReloadMovieChkBx.Value);
    end
    function setReloadMovie(method)
        ReloadMovie = method;
        ReloadMovieChkBx.Value=method;
    end
    function doSetFastLoad(s,e,h)
        setFastLoad(FastLoadChkBx.Value);
    end
    function setFastLoad(method)
        FastLoad = method;
        FastLoadChkBx.Value=method;
    end
    function doSetPhotoBleach(s,e,h)
        setPhotoBleach(PhotoBleachLst.String{PhotoBleachLst.Value});
    end
    function setPhotoBleach(method)
        PhotoBleach = method;
    end
    function doSetAnalysistype(s,e,h)
        setAnalysistype((AnalysistypeLst.String{AnalysistypeLst.Value}));
    end
    function setAnalysistype(tAnalysistype)
        Analysistype =tAnalysistype;
        AnalysistypeLst.Value=find(strcmp(AnalysistypeLst.String,Analysistype));
    end
    function doSetCellBodytype(s,e,h)
        setCellBodytype((CellBodytypeLst.String{CellBodytypeLst.Value}));
    end
    function setCellBodytype(tCellBodytype)
        CellBodytype =tCellBodytype;
        CellBodytypeLst.Value=CellBodytype+1;
        %0 =synapse
        %1 =cellbody
        %2 =future
    end
    function doSetSkipMovie(s,e,h)
        setSkipMovie(skipMovieChkBx.Value);
    end
    function setSkipMovie(tskipMovie)
        skipMovie =tskipMovie;
        skipMovieChkBx.Value=skipMovie;
    end
    function doSetWriteSVD(s,e,h)
        setWriteSVD(WriteSVDChkBx.Value);
    end
    function setWriteSVD(tWriteSVD)
        WriteSVD =tWriteSVD;
        WriteSVDChkBx.Value=WriteSVD;
    end
    function doCreateRef(s,e,h)
        createRef();
    end
    function doSetSVDNumber(s,e,h)
        if strcmp(SVDLst.String{SVDLst.Value},'Pop-up')
            setSVDNumber(0); % set SVDNumber to 0 for interactive popup question.
        else
            setSVDNumber(str2num(SVDLst.String{SVDLst.Value}));
        end
    end
    function setSVDNumber(number)
        SVDNumber = number;
        SVDLst.Value=number;
        if ~strcmp(SVDLst.String{SVDLst.Value},num2str(number))
            error ('SVDNumber mismatch')
        end
    end
    function doSetMaskTimeProj(s,e,h)
        setMaskTimeProj((maskTimeProjLst.String{maskTimeProjLst.Value}));
        
    end
    function setMaskTimeProj(st)
        maskTimeProj= st;
        if strcmp(st,'SVD')
            SVDLst.Visible='on';
            SVDtxt.Visible='on';
        else
            SVDLst.Visible='off';
            SVDtxt.Visible='off';
        end
        
        if strcmp(st,'DICT')
            createDictBtn.Visible='on';
            createDicttxt.Visible='on';
        else
            createDictBtn.Visible='off';
            createDicttxt.Visible='off';
        end
        
    end
    function doSetOnOffset(s,e,h)
        setOnOffset(str2double(OnOffsettxt3.String));
        doUpdateFold();
    end
    function setOnOffset(OnOffset1)
        OnOffset3= OnOffset1;
        OnOffsettxt3.String = num2str(OnOffset3);
    end
    function doSetOnOffset2(s,e,h)
        setOnOffset2(str2double(OnOffsettxt2.String));
        doUpdateFold();
    end
    function setOnOffset2(OonOffset2)
        OnOffset2= OonOffset2;
        OnOffsettxt2.String = num2str(OnOffset2);
    end
    function doSetStimFreq(s,e,h)
        setStimFreq(str2double(stimFreqtxt3.String));
        doUpdateFold();
    end
    function doSetNOS(s,e,h) % Number of Stimuli
        setNOS( str2double(NOStxt3.String));
        doUpdateFold();
    end
    function setNOS(NOS2) % Number of Stimuli
        NOS3 = NOS2;
        NOStxt3.String = num2str(NOS3);
        
    end
    function doSetNOS2(s,e,h) % Number of Stimuli
        setNOS2( str2double(NOS2txt.String));
        doUpdateFold();
    end
    function setNOS2(nNOS2) % Number of Stimuli
        NOS2 = nNOS2;
        NOS2txt.String = num2str(NOS2);
        
    end
    function doSetFrameSelection(s,e,h) % Number of Stimuli
        setFrameSelection( frameSelectionTxt.String);
        doUpdateFold();
    end
    function setFrameSelection(fs) % Number of Stimuli
        frameSelection = fs;
        try
            eval(['trace(' fs ');']);
        catch e
            error(e.message);
        end
        frameSelectionTxt.String = frameSelection;
    end
    function doSetNumAvgSamples(s,e,h)
        setNumAvgSamples(str2double(numAvgSamplesTxt.String));
        doUpdateFold();
    end
    function setNumAvgSamples(num)
        NumAvgSamples=num;
        numAvgSamplesTxt.String = num2str(NumAvgSamples);
    end
    function doSetFPS(s,e,h)
        setFPS(str2double(fpsTxt3.String));
        doUpdateFold();
    end
    function setFPS(fps2)
        fps3=fps2;
        dt=1/fps3;
        fpsTxt3.String = num2str(fps3);
    end
    function setStimFreq(stimFreq2)
        stimFreq3= stimFreq2;
        stimFreqtxt3.String = num2str(stimFreq3);
    end
    function doSetStimFreq2(d,f,r)
        setStimFreq2(str2num(stimFreq2txt.String));
        doUpdateFold();
    end
    function setStimFreq2(stimmFreq2)
        stimFreq2= stimmFreq2;
        stimFreqtxt2.String = num2str(stimFreq2);
    end
    function doSetDCOF(d,f,r)
        setDCOF(str2num(DCOFtxt3.String));
        doUpdateFold();
    end
    function setDCOF(DCOF2)
        dutyCycleOnFrames3= DCOF2;
        DCOFtxt3.String = num2str(dutyCycleOnFrames3);
    end
    function doSetDCOF2(d,f,r)
        setDCOF2(str2num(DCOF2txt.String));
        doUpdateFold();
    end
    function setDCOF2(DCOF2)
        dutyCycleOnFrames2= DCOF2;
        DCOF2txt.String = num2str(dutyCycleOnFrames2);
    end

% copy from segGUIV1: Try to keep copy up to date.
    function part = foldData(data,settings)
        [fhandles]=segGUIV1([],1);
        foldData = fhandles.foldData;
        try
            part = foldData(data,settings);
            title('settings 1 OK')
        catch
            title('error!!')
            part=zeros(2000,1);
        end
        
        %         NOS=settings.NOS;
        %         dCOF=settings.dCOF;
        %         fps=settings.fps;
        %         stimFreq=settings.stimFreq;
        %         OnOffset=settings.OnOffset;
        %         nNOS2=settings.NOS2;
        %         sstimFreq2=settings.stimFreq2;
        %         ddCOF2=settings.dCOF2;
        %         % stimFreq = 0.125;%Hz
        %         % Number of Stimuli
        %         % NOS = 3; % Number of Stimuli
        %         interStimPeriod = 1/stimFreq*fps; %Do not floor here but only after multiplication.
        %         iSP = interStimPeriod;
        %         dCOF=dCOF; % DutyCycleOnFrames.  |--dCOF--|____|-----|____
        %         if (dCOF==0 || dCOF>iSP)
        %             dCOF = floor(iSP);
        %         end
        %
        %         %dCOF = floor(iSP); %dutyCycleOnFrames.
        %         part = zeros(dCOF,NOS);
        %         for iii = 1:NOS
        %             try
        %                 part(:,iii)=data(OnOffset+floor((iii-1)*iSP)+(1:dCOF));
        %             catch e
        %                 disp(['size(data) = ' num2str(size(data)) ', OnOffset= ' num2str(OnOffset) ', iSP =' num2str(iSP) ', dCOF= ' num2str(dCOF) ]);
        %                 disp('Multi Response to 1 error, press any to crash, or set a breakpoint to investigate')
        %                 % pause;
        %                 error(e.message);
        %             end
        %         end
        %
        
    end

% copy from segGUIV1
    function meanData = multiResponseto1(data,exportPlot,settings)
        
        fhandles=segGUIV1([],1);
        meanData = fhandles.multiResponseto1(data,exportPlot,settings);
        %         if nargin==1multiResponseto1
        %             exportPlot=1;
        %         end
        %
        %         part = foldData(data,settings);
        %
        %         %         part(:,2)=data(OnOffset+1*iSP+(1:iSP));
        %         %         part(:,3)=data(OnOffset+2*iSP+(1:iSP));
        %         %         part(:,4)=data(OnOffset+3*iSP+(1:iSP));
        %         %         part(:,5)=data(OnOffset+4*iSP+(1:iSP));
        %         % figure;
        %         subplot(4,4,12)
        %         [spart,~,~,level] = linBleachCorrect(part');
        %         part = (spart-level)'; %Using Matlab Matrix expansion
        %         plot(part);
        %         hold on
        %
        %         meanData=mean(part,2);
        %
        %
        %         [meanData,~, ~,baseLevel] = linBleachCorrect(meanData'); % To set the bottom back to zero,
        %         meanData = meanData'-baseLevel;
        %         plot(meanData,'k','LineWidth',3);
        %
        %
        %         hold off
        %         pause(.01);
        %         if (exportPlot)
        %             savesubplot(4,4,12,[pathname '_align']);
        %         end
        %
        %
        %         % ASR = meanData;
    end


% Copy from segGUIV1
    function part = foldData2(signal,settings)    % Check if the partial interval is bigger than the interval
        % itself.
        
                [fhandles]=segGUIV1([],1);
                rfoldData2 = fhandles.foldData2;
                try
                    part = rfoldData2(signal,settings);
                    title('settings 1 OK');
                catch
                    title('error!!');
                    part=nan*zeros(2000,1);
                end
        %
        %         nNOS2=settings.NOS2;
        %         fps=settings.fps;
        %         stimFreq=settings.stimFreq;
        %         sstimFreq2=settings.stimFreq2;
        %         oOnOffset2=settings.OnOffset2;
        %         ddCOF2=settings.dCOF2;
        %
        %
        %
        %
        %         debug=0;
        %         if (sstimFreq2<stimFreq) && (sstimFreq2~=0)
        %             sstimFreq2=stimFreq;
        %             setStimFreq2(sstimFreq2);
        %             warning(['stimFreq2 adjusted to: ' num2str(stimFreq) 'to fit interval.']);
        %             warning(['Continue on your own risk by pressing a key ' ]);
        %             % pause();
        %         end
        %
        %         if sstimFreq2==0
        %             sFq2=stimFreq;
        %         else
        %             sFq2=sstimFreq2;
        %         end
        %         interStimPeriod = floor(1/sFq2*fps);
        %         iSP = interStimPeriod;
        %         if nNOS2==0
        %             setNOS2(1);
        %         end
        %            dCOF2=ddCOF2; % DutyCycleOnFrames.  |--dCOF--|____|-----|____
        %         if (dCOF2==0 || dCOF2>iSP)
        %             dCOF2 = floor(iSP);
        %         end
        %
        %         part=zeros(dCOF2,nNOS2);
        %
        %         for j = 1:nNOS2
        %             %part(:,j)=signal(OnOffset2+(j-1)*iSP+(1:iSP));
        %             try
        %                 part(:,j)=signal(oOnOffset2+floor((j-1)/sFq2*fps)+(1:dCOF2)); % Here the rounding is done after the multiplication = better
        %             catch e
        %                 d = dialog('Position',[300 300 250 150],'Name','Wrong Numbers');
        %
        %                 txt = uicontrol('Parent',d,...
        %                     'Style','text',...
        %                     'Position',[20 80 210 40],...
        %                     'String','The artificial intelligence says the partial analysis numbers are wrong.');
        %
        %                 btn = uicontrol('Parent',d,...
        %                     'Position',[85 20 70 25],...
        %                     'String','Close',...
        %                     'Callback','delete(gcf)');
        %                 error(e.message);
        %             end
        %         end
        %         if debug
        %             plot(part);
        %             pause(.01);
        %         end
    end
end