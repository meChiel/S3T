function analysisCfgGenerator  ()
global ptitle3 NOStxt3 stimFreqtxt3 OnOffsettxt3 fpsTxt3;
NOS3=1;
stimFreq3=.2;
OnOffset3=33;
fps3=33;

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
        stimFreqtxt3 = uicontrol('Style', 'Edit', 'String', num2str(stimFreq3),...
            'Position', [20 by(-3) 50 20],...
            'Callback', @doSetStimFreq);
        uicontrol('Style', 'text', 'String', 'Stim. freq.',...
            'Position', [70 by(-3) 100 20]);
        OnOffsettxt3 = uicontrol('Style', 'Edit', 'String', num2str(OnOffset3),...
            'Position', [20 by(-2) 50 20],...
            'Callback', @doSetOnOffset);
        uicontrol('Style', 'text', 'String', 'Stim. delay',...
            'Position', [70 by(-2) 100 20]);
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
        
    end
    function a=by(a)
        a=200-20*a;
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
    end
    function setOnOffset(OnOffset2)
        OnOffset3= OnOffset2;
        OnOffsettxt3.String = num2str(OnOffset3);
    end
    function doSetStimFreq(s,e,h)
        setStimFreq(str2double(stimFreqtxt3.String));
    end
 function doSetNOS(s,e,h) % Number of Stimuli
        setNOS( str2double(NOStxt3.String));        
    end

    function doSetFPS(s,e,h)
     setFPS(str2double(fpsTxt3.String));
    end
   
 function setNOS(NOS2) % Number of Stimuli
        NOS3 = NOS2;
        NOStxt3.String = num2str(NOS3);
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
   
end