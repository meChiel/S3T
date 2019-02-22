function analysisCfgGenerator  ()
global ptitle3 NOStxt3 stimFreqtxt3 OnOffsettxt3 fpsTxt3 DCOFtxt3 DCOF2txt NOS2txt  stimFreq2txt data trace ...
    OnOffsettxt2;
global frameSelectionTxt frameSelection;

NOS3=1;
NOS2=1;
stimFreq3=.2;
stimFreq2=0;
OnOffset3=33;
OnOffset2=0;
fps3=33;
dutyCycleOnFrames3=0;
dutyCycleOnFrames2=0;

bgc=[.35 .35 .38];
%bgc=[.95 .95 .95];
f2 = figure('Visible','on','name','S3T: analysis Configuration tool',...
    'Color',bgc,...
    'NumberTitle','off');
set(f2,'MenuBar', 'figure');
javaFrame = get(f2,'JavaFrame');
javaFrame.setFigureIcon(javax.swing.ImageIcon('PlateLayout_icon.png'));
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
        
    end
createTitleUI()
    function createTitleUI()
        ptitle3 = uicontrol('Style', 'edit', 'String', '1AP',...
            'Position', [240 390 100 20]);
    end
createButtonsUI();
    function createButtonsUI()
        uicontrol('Style', 'pushbutton', 'String', 'Generate',...
            'Position', [350 30+100 150 100],...
            'Callback', @generate);
        uicontrol('Style', 'pushbutton', 'String', 'Load',...
            'Position', [350 30+200 150 20],...
            'Callback', @loadSettings);
        uicontrol('Style', 'pushbutton', 'String', 'Reset',...
            'Position', [350 30+300 150 20],...
            'Callback', @resetPlate);
        
        uicontrol('Style', 'pushbutton', 'String', 'Load Example Movie',...
            'Position', [350 30+350 150 20],...
            'Callback', @loadMovie);
        
    end

    function loadMovie(e,r,t)
        [fn, di, pn]=uigetfile('*.tif');
        [data, pathname, fname, dirname] = loadTiff([di fn],1);%'c:',1);
        trace=mean(reshape(data,size(data,1)*size(data,2),[]),1);
        subplot(4,4,1);
        plot(trace);
        
    end
    function a=by(a)
        a=200-20*a;
    end

    function doUpdateFold(d,f,t)
        settings.NOS=NOS3;
        settings.dCOF=dutyCycleOnFrames3;
        settings.dCOF2=dutyCycleOnFrames2;
        settings.OnOffset=  OnOffset3;
        settings.OnOffset2=  OnOffset2;
        settings.NOS2 =NOS2;
        settings.fps=fps3;
        settings.stimFreq=stimFreq3;
        settings.stimFreq2=stimFreq2;
        
        updateFold(settings);
    end
    function updateFold(settings)
        subplot(4,4,1);
        plot(trace);
        title('Original trace')
        subplot(4,4,5);
        traceFrames=[];
        eval(['traceFrames=trace(' frameSelection ');']);
        plot(traceFrames);
        title('trace Frames')
        
        subplot(4,4,2);
        part = foldData(traceFrames,settings);
        subplot(4,4,6)
        plot(part);
        title('Avg trace folding')
        subplot(4,4,3)
        part2 = multiResponseto1(traceFrames,0,settings);
        subplot(4,4,7)
        
        plot(part2);
        subplot(4,4,4)
        part3 = foldData2(traceFrames,settings);
        title('partial trace folding')
        subplot(4,4,8)
        plot(part3);
    end


    function generate(e,g,h)
        
        %   NOS=1;
        %   stimFreq=.2;
        %   OnOffset=33;
        
        analysisName = get(ptitle3,'String');
        [FileName,PathName,FilterIndex] = uiputfile('*.xml','Save Analysis Configuration',[analysisName '_Analysis.xml']);
        %csvwrite([PathName FileName],conc);
        
        
        %'<Name>Frequency (Hz)</Name>\n<Val>0.20000000000000</Val>'
        dd1='<Name>Frequency (Hz)</Name>\n<Val>%6.13f</Val>';
        
        
        
        fid = fopen([PathName FileName],'w');
        fprintf(fid,dd1,stimFreq3);
        %fwrite('blabla','char');
        %'<Name>Pulse width (ms)</Name>\r\n<Val>1.00000000000000</Val>'
        %         dd2='\r\n\r\n<Name>Pulse width (ms)</Name>\r\n<Val>%5.13f</Val>';
        %         fprintf(fid,dd2,stimFreq);
        
        %'<Name>Delay Time (ms)</Name>\r\n<Val>2000</Val>'
        dd3='\r\n\r\n<Name>Delay Time (ms)</Name>\r\n<Val>%6f</Val>';
        fprintf(fid,dd3,OnOffset3/fps3*1000);
        
        %'<Name>Pulse count</Name>\r\n<Val>2</Val>'
        dd4='\r\n\r\n<Name>Pulse count</Name>\r\n<Val>%d</Val>';
        fprintf(fid,dd4,NOS3);
        
        
        fieldNames = {'Partial Frequency (Hz)'
            'Partial Delay Time (ms)'
            'Partial Pulse count'
            'Frame Selection'
            };

        
        
        fieldValues= {stimFreq2txt.String, ...
        OnOffsettxt2.String, ...    
        NOS2txt.String,  ...   
        frameSelectionTxt.String
            };
        
        for ii=1:length(fieldNames)
            dd4=['\r\n\r\n<Name>' fieldNames{ii} '</Name>\r\n<Val>%s</Val>'];
            fprintf(fid,dd4,fieldValues{ii});
        end
 
        
        %'Camera Exposure Time (s) - 0.03'
        dd5='\r\n\r\nCamera Exposure Time (s) - %5.5f\r\n';
        fprintf(fid,dd5,1/fps3);
        fclose(fid);
        disp(['Analysis writen to ' PathName FileName]);
    end
    function loadSettings(e,g,h)
        [ stimCfgFN.name, stimCfgFN.folder] = uigetfile('*.xml');
        stimCfg = xmlSettingsExtractor(stimCfgFN);
        setNOS(stimCfg.pulseCount);
        setFPS(stimCfg.imageFreq);
        setOnOffset(round(stimCfg.delayTime*stimCfg.imageFreq/1000));
        setStimFreq(stimCfg.stimFreq);
    end


    function doSetOnOffset(s,e,h)
        setOnOffset(str2double(OnOffsettxt3.String));
        doUpdateFold();
    end
    function setOnOffset(OnOffset2)
        OnOffset3= OnOffset2;
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
        NOS=settings.NOS;
        dCOF=settings.dCOF;
        fps=settings.fps;
        stimFreq=settings.stimFreq;
        OnOffset=settings.OnOffset;
        nNOS2=settings.NOS2;
        sstimFreq2=settings.stimFreq2;
        ddCOF2=settings.dCOF2;
        % stimFreq = 0.125;%Hz
        % Number of Stimuli
        % NOS = 3; % Number of Stimuli
        interStimPeriod = 1/stimFreq*fps; %Do not floor here but only after multiplication.
        iSP = interStimPeriod;
        dCOF=dCOF; % DutyCycleOnFrames.  |--dCOF--|____|-----|____
        if (dCOF==0 || dCOF>iSP)
            dCOF = floor(iSP);
        end
        
        %dCOF = floor(iSP); %dutyCycleOnFrames.
        part = zeros(dCOF,NOS);
        for iii = 1:NOS
            try
                part(:,iii)=data(OnOffset+floor((iii-1)*iSP)+(1:dCOF));
            catch e
                disp(['size(data) = ' num2str(size(data)) ', OnOffset= ' num2str(OnOffset) ', iSP =' num2str(iSP) ', dCOF= ' num2str(dCOF) ]);
                disp('Multi Response to 1 error, press any to crash, or set a breakpoint to investigate')
                % pause;
                error(e.message);
            end
        end
        
        
    end

% copy from segGUIV1
    function meanData = multiResponseto1(data,exportPlot,settings)
        if nargin==1
            exportPlot=1;
        end
        
        part = foldData(data,settings);
        
        %         part(:,2)=data(OnOffset+1*iSP+(1:iSP));
        %         part(:,3)=data(OnOffset+2*iSP+(1:iSP));
        %         part(:,4)=data(OnOffset+3*iSP+(1:iSP));
        %         part(:,5)=data(OnOffset+4*iSP+(1:iSP));
        % figure;
        subplot(4,4,12)
        [spart,~,~,level] = linBleachCorrect(part');
        part = (spart-level)'; %Using Matlab Matrix expansion
        plot(part);
        hold on
        
        meanData=mean(part,2);
        
        
        [meanData,~, ~,baseLevel] = linBleachCorrect(meanData'); % To set the bottom back to zero,
        meanData = meanData'-baseLevel;
        plot(meanData,'k','LineWidth',3);
        
        
        hold off
        pause(.01);
        if (exportPlot)
            savesubplot(4,4,12,[pathname '_align']);
        end
        
        
        % ASR = meanData;
    end


% Copy from segGUIV1
    function part = foldData2(signal,settings)    % Check if the partial interval is bigger than the interval
        % itself.
        nNOS2=settings.NOS2;
        fps=settings.fps;
        stimFreq=settings.stimFreq;
        sstimFreq2=settings.stimFreq2;
        oOnOffset2=settings.OnOffset2;
        ddCOF2=settings.dCOF2;
        
        debug=0;
        if (sstimFreq2<stimFreq) && (sstimFreq2~=0)
            sstimFreq2=stimFreq;
            setStimFreq2(sstimFreq2);
            warning(['stimFreq2 adjusted to: ' num2str(stimFreq) 'to fit interval.']);
            warning(['Continue on your own risk by pressing a key ' ]);
            % pause();
        end
        
        if sstimFreq2==0
            sFq2=stimFreq;
        else
            sFq2=sstimFreq2;
        end
        interStimPeriod = floor(1/sFq2*fps);
        iSP = interStimPeriod;
        if nNOS2==0
            setNOS2(1);
        end
           dCOF2=ddCOF2; % DutyCycleOnFrames.  |--dCOF--|____|-----|____
        if (dCOF2==0 || dCOF2>iSP)
            dCOF2 = floor(iSP);
        end
        
        part=zeros(dCOF2,nNOS2);
        
        for j = 1:nNOS2
            %part(:,j)=signal(OnOffset2+(j-1)*iSP+(1:iSP));
            try
                part(:,j)=signal(oOnOffset2+floor((j-1)/sFq2*fps)+(1:dCOF2)); % Here the rounding is done after the multiplication = better
            catch e
                d = dialog('Position',[300 300 250 150],'Name','Wrong Numbers');
                
                txt = uicontrol('Parent',d,...
                    'Style','text',...
                    'Position',[20 80 210 40],...
                    'String','The artificial intelligence says the partial analysis numbers are wrong.');
                
                btn = uicontrol('Parent',d,...
                    'Position',[85 20 70 25],...
                    'String','Close',...
                    'Callback','delete(gcf)');
                error(e.message);
            end
        end
        if debug
            plot(part);
            pause(.01);
        end
    end
end