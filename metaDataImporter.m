fid = fopen('../urls/urls.json', 'r');
c = fread(fid, inf, 'uint8=>char')';
fclose(fid);
 
dd = jsondecode(c);
experimentInfo = jsondecode(urlread([dd.EFSURL 'NS_2018_016259']));
plateInfo = jsondecode(urlread([dd.PlateDataURL '153']));%10
wellInfo = jsondecode(urlread([dd.WellDataURL '153']));
neuroCellFactoryInfo = jsondecode(urlread([dd.NeuroCellFactoryURL '44266']));%102 %experiment->culture->externalID

structViewer(experimentInfo,'Experiment');
structViewer([plateInfo;plateInfo],'Plate');
structViewer(wellInfo,'well');
structViewer(neuroCellFactoryInfo,'neuro Cell');

d.experimentInfo=experimentInfo;
d.plateInfo=plateInfo;
d.wellInfo=wellInfo;
d.neuroCellFactory=neuroCellFactoryInfo;
structViewer(d,'Neuro synapse metaData')

