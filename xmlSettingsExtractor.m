
function stimCfg = xmlSettingsExtractor(stimCfgFN)
%% Also see : stimSettingsLoader()

if ~exist('stimCfgFN','var')
    [stimCfgFN.name, stimCfgFN.folder] = uigetfile();
end
%% Parse the file

fid=fopen([stimCfgFN.folder '\' stimCfgFN.name],'r');%xmlread([stimCfgFN.folder '\' stimCfgFN.name]);
aa=fread(fid,inf,'uint8=>char')';
fclose(fid);
if (length(aa)==0)
    stimFreq=0;
    imageFreq=0;
    
else
    %% Frequency (Hz)
    rr = strfind(aa,'<Name>Frequency (Hz)</Name>');
   if length(rr)<1
        warning('did not find Frequency, setting Frequency = 0')
        stimFreq=0;
   else
    if length(rr)>1
        warning('did find multiple frequencies, chosing freq 1')
    end
    ss=strfind(aa(rr(1):end),'<Val>');
    ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');
    stimFreq=str2num(aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2));
   end
    %% Partial Frequency (Hz)
    rr = strfind(aa,'<Name>Partial Frequency (Hz)</Name>');
    if length(rr)<1
        warning('did not find Partial frequencies, setting Partial freq = 0')
        stimFreq2=0;
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
        
        imagePeriod=str2num(aa(rr(1)+ss(1)+2:rr(1)+ss(1)+ss2(1)-0));
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
        %% Cell Body
    rr = strfind(aa,'<Name>Cell Body</Name>');
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
    
       %% Analysis
    rr = strfind(aa,'<Name>Cell Body</Name>');
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


end
