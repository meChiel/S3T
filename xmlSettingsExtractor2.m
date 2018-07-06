
function stimCfg = xmlSettingsExtractor(stimCfgFN)
%% Also see : stimSettingsLoader()


%% Parse the file

fid=fopen([stimCfgFN.folder '\' stimCfgFN.name],'r');%xmlread([stimCfgFN.folder '\' stimCfgFN.name]);
aa=fread(fid,inf,'uint8=>char')';
fclose(fid);
cn=1; % select which result you want to use. 



% First exposure time 

% rr = strfind(aa,'Camera Exposure Time (s)');
% if length(rr)>1
%     warning('did find multiple camera ep times, chosing 1')
% end
% 
% ss=strfind(aa(rr(cn):end),' - ');

% ss2=strfind(aa(rr(cn)+(ss(1)):end),sprintf('\r'));

% imagePeriod=str2num(aa(rr(cn)+ss(1)+2:rr(cn)+ss(1)+ss2(1)-0));
% imageFreq = 1/imagePeriod;



% Than remove all the other channel information except channel2
% Exposure Frequency should be extracted before.
rr = strfind(aa,'<Val>Channel 2</Val>');
aa=aa(rr(1):end);

rr = strfind(aa,'<Val>Channel 3</Val>');
aa=aa(1:rr(1));


% Look for the other info:
rr = strfind(aa,'<Name>Frequency (Hz)</Name>');
if length(rr)>1
    warning('did find multiple frequencies, chosing freq 1')
end

ss=strfind(aa(rr(cn):end),'<Val>');

ss2=strfind(aa(rr(cn)+(ss(1)):end),'</Val>');

stimFreq=str2num(aa(rr(cn)+ss(1)+4:rr(cn)+ss(1)+ss2(1)-2));



rr = strfind(aa,'<Name>Delay Time (ms)</Name>');
if length(rr)>1
    warning('did find multiple Delay Time, chosing Delay Time 1')
end

ss=strfind(aa(rr(cn):end),'<Val>');

ss2=strfind(aa(rr(cn)+(ss(1)):end),'</Val>');

delayTime=str2num(aa(rr(cn)+ss(1)+4:rr(cn)+ss(1)+ss2(1)-2));


rr = strfind(aa,'<Name>Pulse width (ms)</Name>');
if length(rr)>1
    warning('did find multiple PulseWidth, chosing PulseWidth 1')
end

ss=strfind(aa(rr(cn):end),'<Val>');

ss2=strfind(aa(rr(cn)+(ss(1)):end),'</Val>');

pulseWidth=str2num(aa(rr(cn)+ss(1)+4:rr(cn)+ss(1)+ss2(1)-2));



rr = strfind(aa,'<Name>Pulse count</Name>');
if length(rr)>1
    warning('did find Pulse count, chosing Pulse count 1')
end

ss=strfind(aa(rr(cn):end),'<Val>');

ss2=strfind(aa(rr(cn)+(ss(1)):end),'</Val>');

pulseCount=str2num(aa(rr(cn)+ss(1)+4:rr(cn)+ss(1)+ss2(1)-2));



stimCfg.delayTime =delayTime;
stimCfg.stimFreq =stimFreq;
%stimCfg.imageFreq =imageFreq;
stimCfg.pulseCount=pulseCount;
stimCfg.pulseWidth=pulseWidth;


end
