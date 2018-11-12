function metaDataImporter()
try
fid = fopen('../urls/urls.json', 'r');
c = fread(fid, inf, 'uint8=>char')';
fclose(fid);
catch
    disp(['Could not find urls.json in ' pwd '../urls/'] )
end


f= uifigure('AutoResizeChildren','off');
label = uilabel(f,'Text','CellFactoryID','Position',[50 020 100 32]);
c1 = uitextarea(f,'Value', '44266',...
            'Position', [255 20 150 20],...
            'ValueChangedFcn', @changeCellCulture);
label = uilabel(f,'Text','WellID','Position',[50 40 100 32]);
c2 = uitextarea(f,'Value', '153',...
            'Position', [255 40 150 20],...
            'ValueChangedFcn', @changeWell);
label = uilabel(f,'Text','PlateID','Position',[50 60 100 32]);
c3 = uitextarea(f,'Value', '153',...
            'Position', [255 60 150 20],...
            'ValueChangedFcn', @changePlate);
label = uilabel(f,'Text','experimentID','Position',[50 80 100 32]);
c4 = uitextarea(f,'Value', 'NS_2018_016259',...
            'Position', [255 80 150 20],...
            'ValueChangedFcn', @changeExperiment);

        
urls = jsondecode(c);

% experimentInfo = jsondecode(urlread([urls.EFSURL 'NS_2018_016259']));
% plateInfo = jsondecode(urlread([urls.PlateDataURL '153']));%10
% wellInfo = jsondecode(urlread([urls.WellDataURL '153']));
% neuroCellFactoryInfo = jsondecode(urlread([urls.NeuroCellFactoryURL '44266']));%102 %experiment->culture->externalID
% 
% structViewer(experimentInfo,'Experiment');
% structViewer([plateInfo;plateInfo],'Plate');
% structViewer(wellInfo,'well');
% structViewer(neuroCellFactoryInfo,'neuro Cell',f);

% d.experimentInfo=experimentInfo;
% d.plateInfo=plateInfo;
% d.wellInfo=wellInfo;
% d.neuroCellFactory=neuroCellFactoryInfo;
% structViewer(d,'Neuro synapse metaData')



    function changeCellCulture (e,g,h)
        %neuroCellFactoryInfo = jsondecode(urlread([dd.NeuroCellFactoryURL '44266']));%102 %experiment->culture->externalID
        neuroCellFactoryInfo = jsondecode(urlread([urls.NeuroCellFactoryURL num2str(str2num(c1.Value{1}))]));%102 %experiment->culture->externalID
        d.neuroCellFactory=neuroCellFactoryInfo;
        structViewer(d,'Neuro synapse metaData',f);
    end


    function changeWell (e,g,h)
        %neuroCellFactoryInfo = jsondecode(urlread([dd.NeuroCellFactoryURL '44266']));%102 %experiment->culture->externalID
        wellInfo = jsondecode(urlread([urls.WellDataURL num2str(str2num(c2.Value{1}))]));%102 %experiment->culture->externalID
        d.wellInfo=wellInfo;
        structViewer(d,'Neuro synapse metaData',f);
    end

    function changePlate(e,g,h)
        %neuroCellFactoryInfo = jsondecode(urlread([dd.NeuroCellFactoryURL '44266']));%102 %experiment->culture->externalID
        plateInfo = jsondecode(urlread([urls.NeuroCellFactoryURL num2str(str2num(c3.Value{1}))]));%102 %experiment->culture->externalID
        d.plateInfo=plateInfo;
        structViewer(d,'Neuro synapse metaData',f);
    end

    function changeExperiment (e,g,h)
        %neuroCellFactoryInfo = jsondecode(urlread([dd.NeuroCellFactoryURL '44266']));%102 %experiment->culture->externalID
        experimentInfo = jsondecode(urlread([urls.EFSURL c4.Value{1}]));%102 %experiment->culture->externalID
        d.experimentInfo=experimentInfo;
        structViewer(d,'Neuro synapse metaData',f);
    end

end