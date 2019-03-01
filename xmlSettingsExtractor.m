
function stimCfg = xmlSettingsExtractor(stimCfgFN)
%% Also see : stimSettingsLoader()

if ~exist('stimCfgFN','var')
    [stimCfgFN.name, stimCfgFN.folder] = uigetfile('*_Analysis.xml');
end
%% Parse the file

fid=fopen([stimCfgFN.folder '\' stimCfgFN.name],'r');%xmlread([stimCfgFN.folder '\' stimCfgFN.name]);
aa=fread(fid,inf,'uint8=>char')';
fclose(fid);
if (length(aa)==0)
    stimFreq=0;
    imageFreq=0;
    
else
   %% Stimulation Frequency (Hz)
   rr = strfind(aa,'<Name>Stimulation Frequency (Hz)</Name>');
   if length(rr)<1
       warning('did not find Stimulation Frequency, looking for Frequency')
       rr = strfind(aa,'<Name>Frequency (Hz)</Name>');
       if length(rr)<1
           warning('did not find Frequency, setting Frequency = 0')
           stimFreq=0;
       else
           if length(rr)>1
               warning('did find multiple frequencies, chosing freq 1')
           end
           warning(['Frequency field found, this is the old convention,'...
               '                                                       '...
           'please update Analysis to new format: <Name>Stimulation Frequency (Hz)</Name> '])
           ss=strfind(aa(rr(1):end),'<Val>');
           ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');
           stimFreq=str2num(aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2));
       end
   else
    if length(rr)>1
        warning('did find multiple Stimulation frequencies, chosing freq 1')
    end
    ss=strfind(aa(rr(1):end),'<Val>');
    ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');
    stimFreq=str2num(aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2));
   end
    
    
   
    %% Partial Stimulation Frequency (Hz)
    rr = strfind(aa,'<Name>Partial Stimulation Frequency (Hz)</Name>');
    if length(rr)<1
        warning('did not find Partial Stimulation Frequency (Hz), looking for Partial Frequency (Hz)')
        
        rr = strfind(aa,'<Name>Partial Frequency (Hz)</Name>');
        if length(rr)<1
            warning('did not find Partial frequencies, setting Partial freq = 0')
            stimFreq2=0;
        else
            if length(rr)>1
                warning('did find multiple Partial frequencies, chosing first Partial freq 1')
            end
            warning('Please upgrade analysis file: Partial Frequency (Hz) to Partial Stimulation Frequency (Hz)')
            ss=strfind(aa(rr(1):end),'<Val>');
            ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');
            stimFreq2=str2num(aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2));
        end
        
    else
        if length(rr)>1
            warning('did find multiple Partial frequencies, chosing first Partial freq 1')
        end
        ss=strfind(aa(rr(1):end),'<Val>');
        ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');
        stimFreq2=str2num(aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2));
    end
    
    
    %% Delay Time (ms)
    rr = strfind(aa,'<Name>Delay Time (ms)</Name>');
    if length(rr)<1
        warning('did not find Delay Time, chosing Delay Time = 0')
        delayTime=0;
    else
        if length(rr)>1
            warning('did find multiple Delay Time, chosing Delay Time 1')
        end
        ss=strfind(aa(rr(1):end),'<Val>');
        ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');
        delayTime=str2num(aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2));
    end
    %% Partial Delay Time (ms)
    rr = strfind(aa,'<Name>Partial Delay Time (ms)</Name>');
    if length(rr)<1
        warning('did not find Partial Delay Time, chosing Partial Delay Time = 0')
        delayTime2=0;
    else
        if length(rr)>1
            warning('did find multiple Partial Delay Time, chosing Partial Delay Time 1')
        end
        ss=strfind(aa(rr(1):end),'<Val>');
        ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');
        delayTime2=str2num(aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2));
    end
    %% Pulse count
    rr = strfind(aa,'<Name>Pulse count</Name>');
    if length(rr)<1
        warning('did not find Pulse count, chosing Pulse count = 0')
        pulseCount=0;
    else
        if length(rr)>1
            warning('did find Pulse count, chosing Pulse count 1')
        end
        ss=strfind(aa(rr(1):end),'<Val>');
        ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');
        pulseCount=str2num(aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2));
    end
    %% Partial Pulse count
    rr = strfind(aa,'<Name>Partial Pulse count</Name>');
    if length(rr)<1
        warning('did not find any Partial Pulse count, chosing Partial Pulse count = 1')
        pulseCount2=1;
    else
        if length(rr)>1
            warning('did find multiple Partial Pulse count, chosing first Partial Pulse count')
        end
        ss=strfind(aa(rr(1):end),'<Val>');
        ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');
        pulseCount2=str2num(aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2));
    end
    %% Eigenvalue Number
    rr = strfind(aa,'<Name>Eigenvalue Number</Name>');
    if length(rr)>0
        if length(rr)>1
            warning('did find multiple Eigen Value, chosing Eigen value 1')
        end
        
        ss=strfind(aa(rr(1):end),'<Val>');
        
        ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');
        
        eigenvalueNumber=str2num(aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2));
    else
         % Set default eigenvalue
        disp('Did not find eigenvalue Number, using 2.')
        eigenvalueNumber=2;
    end
    %% Camera Exposure Time (s)
    rr = strfind(aa,'Camera Exposure Time (s)');
    if length(rr)>0
        if length(rr)>1
            warning('did find multiple camera ep times, chosing 1')
        end
        
        ss=strfind(aa(rr(1):end),' - ');
        
        ss2=strfind(aa(rr(1)+(ss(1)):end),sprintf('\r'));
        
        if (rr(1)+ss(1)+ss2(1)-0))<length(aa)
            imagePeriod=str2num(aa(rr(1)+ss(1)+2:rr(1)+ss(1)+ss2(1)-0));
        else % In case no newline @EOF
            imagePeriod=str2num(aa((rr(1)+ss(1)+2):end));
        end
        imageFreq = 1/imagePeriod;
    else
        warning('did not find Camera Exposure Time (s)')
        imageFreq = nan;
    end
    %% Reload Movie
    rr = strfind(aa,'<Name>Reload Movie</Name>');
    if length(rr)>0
        if length(rr)>1
            warning('did find multiple Reload Movie, chosing 1')
        end
        ss=strfind(aa(rr(1):end),'<Val>');
        ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');
        reloadMovie=str2num((aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2)));
        
    else
        disp('did not find Reload Movie, ')
        reloadMovie = 1;
    end
    %% writeSVD
    rr = strfind(aa,'<Name>Write SVD</Name>');
    if length(rr)>0
        if length(rr)>1
            warning('did find multiple Write SVD, chosing 1')
        end
        ss=strfind(aa(rr(1):end),'<Val>');
        ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');
        writeSVD=str2num((aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2)));
        
    else
        disp('Did not find Write SVD, writeSVD set to 1. ')
        writeSVD = 1;
    end
    
        %% duty Cycle: Only use first samples in the period. Discard later
    rr = strfind(aa,'<Name>duty Cycle (frames)</Name>');
    if length(rr)>0
        if length(rr)>1
            warning('did find multiple duty Cycles, chosing 1')
        end
        ss=strfind(aa(rr(1):end),'<Val>');
        ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');
        dutyCycle=str2num((aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2)));
        
    else
        disp('Did not find dutyCycle, dutyCycle set to 0. ')
        dutyCycle = 0;
    end
        %% partial Duty Cycle
    rr = strfind(aa,'<Name>Partial Duty Cycle (frames)</Name>');
    if length(rr)>0
        if length(rr)>1
            warning('did find multiple Partial Duty Cycles, chosing 1')
        end
        ss=strfind(aa(rr(1):end),'<Val>');
        ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');
        dutyCycle=str2num((aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2)));
        
    else
        disp('Did not find Partial Duty Cycle, Partial Duty Cycle set to 0. ')
        dutyCycle = 0;
    end
    
    %%  skipMovie
   rr = strfind(aa,'<Name>Skip Movie</Name>');
    if length(rr)>0
        if length(rr)>1
            warning('did find multiple skipMovie, chosing 1')
        end
        ss=strfind(aa(rr(1):end),'<Val>');
        ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');
        skipMovie =str2num((aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2)));
        
    else
        disp('Did not find Skip Movie, skipMovie set to 0. ')
        skipMovie = 0;
    end
    
     %% fastLoad
    rr = strfind(aa,'<Name>Fast Load</Name>');
    if length(rr)>0
        if length(rr)>1
            warning('did find multiple fast Load, chosing 1')
        end
        ss=strfind(aa(rr(1):end),'<Val>');
        ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');
        fastLoad=str2num((aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2)));
        
    else
        disp('Did not find Fast Load, fastLoad set to 0. ')
        fastLoad = 1;
    end
    %% Frame Selection
    rr = strfind(aa,'<Name>Frame Selection</Name>');
    if length(rr)>0
        if length(rr)>1
            warning('did find multiple Frame Selection, chosing 1')
        end
        ss=strfind(aa(rr(1):end),'<Val>');
        ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');
        FrameSelectionTxt=(aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2));
        
    else
        warning('did not find frame selection, using all frames')
        FrameSelectionTxt = '(1:end)';
    end
    %% Photo Bleaching
    rr = strfind(aa,'<Name>Photo Bleaching</Name>');
    if length(rr)>0
        if length(rr)>1
            warning('did find multiple Photo Bleaching, chosing 1')
        end
        ss=strfind(aa(rr(1):end),'<Val>');
        ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');
        PhotoBleachingTxt=(aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2));
        
    else
        disp('Did not find Photo Bleaching type, using Lin. Interpolation.')
        PhotoBleachingTxt = 'linInt'; %2expInt
    end
    %% Reuse Mask
    rr = strfind(aa,'<Name>Reuse Mask</Name>');
    if length(rr)>0
        if length(rr)>1
            warning('did find multiple reuse mask, chosing 1')
        end
        ss=strfind(aa(rr(1):end),'<Val>');
        ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');
        reuseMask=str2num(aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2));
        
    else
        disp('Did not find Reuse Mask type, using no.')
        reuseMask = 0; %1
    end
        %% Cell Body Type
        rr = strfind(aa,'<Name>Cell Body Type</Name>');
    
    if length(rr)>0
        if length(rr)>1
            warning('did find Cell Body, chosing 1')
        end
        ss=strfind(aa(rr(1):end),'<Val>');
        ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');
        cellBody=str2num(aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2));
        
    else
        disp('Did not find Cell Body type, using no.')
        cellBody = 0; %1
    end
    
%%% For legacy, show warning to upgrade.
    if strfind(aa,'<Name>Cell Body</Name>');
        warning('Don''t use ''Cell Body'' in Analysis.xml, but use ''Cell Body Type''!!');
        disp(['Cell Body found in : ' stimCfgFN.folder '\' stimCfgFN.name]);
    end
    
       %% Analysis: The idea here is to create a meta-data set with predefined 
       % hardcoded analysis parameters. So you can set analysis to: 5x1AP
       % 10AP.
    rr = strfind(aa,'<Name>Analysis Type</Name>');
    if length(rr)>0
        if length(rr)>1
            warning('did find multiple Analysis Type, chosing 1')
        end
        ss=strfind(aa(rr(1):end),'<Val>');
        ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');
        analysisType=str2num(aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2));
        
    else
        disp('Did not find Analysis type, using no.')
        analysisType = 0; %1
    end
%%     Mask Creation Time Projection
rr = strfind(aa,'<Name>Mask Creation Time Projection</Name>');
    if length(rr)>0
        if length(rr)>1
            warning('did find multiple Mask Creation Time Projection, chosing 1')
        end
        ss=strfind(aa(rr(1):end),'<Val>');
        ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');
        maskTimeProjection=(aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2));
        mTP = maskTimeProjection;
        if (strcmp(mTP,'SVD') || strcmp(mTP,'STD') || strcmp(mTP,'SVM') || strcmp(mTP,'NN') || strcmp(mTP,'NMF'))
        else
            error (['Mask Creation Time Projection: ' mTP ' does not exist. Solve problem in Analysis.xml conf. file.!']);
        end
    else
        disp('Did not find Mask Creation Time Projection, using SVD.')
        maskTimeProjection = 'SVD';
    end    

%% Pre Commands: Some Matlab commands to run before the execution of the analysis.
rr = strfind(aa,'<Name>Matlab Pre-Commands</Name>');
    if length(rr)>0
        ss=strfind(aa(rr(1):end),'<Val>');
        ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');
        matlabPreCommand=(aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2));
        MPreC = matlabPreCommand;
    else
        MPreC ='';
    end    

%% Post Commands: Some Matlab commands to run after the execution of the analysis.

rr = strfind(aa,'<Name>Matlab Post-Commands</Name>');
    if length(rr)>0
        ss=strfind(aa(rr(1):end),'<Val>');
        ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');
        matlabPreCommand=(aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2));
        MPostC = matlabPreCommand;
    else
        MPostC ='';
    end    

end
stimCfg.cellBody =cellBody;
stimCfg.delayTime =delayTime;
stimCfg.delayTime2 =delayTime2;
stimCfg.stimFreq =stimFreq;
stimCfg.stimFreq2 =stimFreq2;
stimCfg.imageFreq =imageFreq;
stimCfg.pulseCount =pulseCount;
stimCfg.pulseCount2 =pulseCount2;
stimCfg.FrameSelectionTxt = FrameSelectionTxt;
stimCfg.PhotoBleachingTxt = PhotoBleachingTxt;
stimCfg.reuseMask = reuseMask;
stimCfg.reloadMovie = reloadMovie;
stimCfg.writeSVD = writeSVD;
stimCfg.fastLoad = fastLoad;
stimCfg.eigenvalueNumber = eigenvalueNumber;
stimCfg.skipMovie = skipMovie;
stimCfg.dutyCycle = dutyCycle;
stimCfg.maskTimeProjectionMethod = maskTimeProjection;%'SVD';
stimCfg.MPreC=MPreC;
stimCfg.MPostC=MPostC;

end
