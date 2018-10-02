
function stimCfg = xmlSettingsExtractor(stimCfgFN)
%% Also see : stimSettingsLoader()


%% Parse the file

fid=fopen([stimCfgFN.folder '\' stimCfgFN.name],'r');%xmlread([stimCfgFN.folder '\' stimCfgFN.name]);
aa=fread(fid,inf,'uint8=>char')';
fclose(fid);


rr = strfind(aa,'<Name>Frequency (Hz)</Name>');
if length(rr)>1
    warning('did find multiple frequencies, chosing freq 1')
end
ss=strfind(aa(rr(1):end),'<Val>');
ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');
stimFreq=str2num(aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2));


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



rr = strfind(aa,'<Name>Delay Time (ms)</Name>');

if length(rr)>1
    warning('did find multiple Delay Time, chosing Delay Time 1')
end
ss=strfind(aa(rr(1):end),'<Val>');
ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');
delayTime=str2num(aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2));

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

rr = strfind(aa,'<Name>Pulse count</Name>');
if length(rr)>1
    warning('did find Pulse count, chosing Pulse count 1')
end
ss=strfind(aa(rr(1):end),'<Val>');
ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');
pulseCount=str2num(aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2));



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


rr = strfind(aa,'<Name>Eigenvalue Number</Name>');
if length(rr)>0
    if length(rr)>1
        warning('did find multiple Eigen Value, chosing Eigen value 1')
    end
    
    ss=strfind(aa(rr(1):end),'<Val>');
    
    ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');
    
    eigenvalueNumber=str2num(aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2));
end

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

if exist('eigenvalueNumber') 
    stimCfg.eigenvalueNumber=eigenvalueNumber;
else
    % Set default eigenvalue
    stimCfg.eigenvalueNumber=2;
end

end
