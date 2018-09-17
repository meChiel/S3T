function  stimCfg = stimSettingsLoader(dirNm)
if ~exist('dirNm','var')
    dirNm = uigetdir();
end
stimCfgFN = dir([dirNm '\STIM_CONFIG*.xml']);
stimCfgFN.name 

stimCfg = xmlSettingsExtractor(stimCfgFN);
end
