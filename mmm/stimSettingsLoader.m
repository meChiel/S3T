function  stimCfg = stimSettingsLoader(dirNm)
if ~exist('dirNm','var')
    dirNm = uigetdir();
end
stimCfgFN = dir([dirNm '\STIM_CONFIG*.xml']);
stimCfgFN.name 

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



rr = strfind(aa,'<Name>Delay Time (ms)</Name>');
if length(rr)>1
    warning('did find multiple Delay Time, chosing Delay Time 1')
end

ss=strfind(aa(rr(1):end),'<Val>');

ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');

delayTime=str2num(aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2));




rr = strfind(aa,'<Name>Pulse count</Name>');
if length(rr)>1
    warning('did find Pulse count, chosing Pulse count 1')
end

ss=strfind(aa(rr(1):end),'<Val>');

ss2=strfind(aa(rr(1)+(ss(1)):end),'</Val>');

pulseCount=str2num(aa(rr(1)+ss(1)+4:rr(1)+ss(1)+ss2(1)-2));



rr = strfind(aa,'Camera Exposure Time (s)');
if length(rr)>1
    warning('did find multiple camera ep times, chosing 1')
end

ss=strfind(aa(rr(1):end),' - ');

ss2=strfind(aa(rr(1)+(ss(1)):end),sprintf('\r'));

imagePeriod=str2num(aa(rr(1)+ss(1)+2:rr(1)+ss(1)+ss2(1)-0));
imageFreq = 1/imagePeriod;

stimCfg.delayTime =delayTime;
stimCfg.stimFreq =stimFreq;
stimCfg.imageFreq =imageFreq;
stimCfg.pulseCount=pulseCount;


end
