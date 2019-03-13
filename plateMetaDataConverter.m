function plateMetaDataConverter(barcodeNumber)
% Converts the Meta Data from the json server into the local *.csv file format
% This for creation of the allWells.txt file.
% Example:
% plateMetaDataConverter('Z:/create/_Rajiv_HTS/NS_2018_016700/NS_920181022_140908_20181022_143016/barcode.txt')
% plateMetaDataConverter('Z:/create/_Rajiv_HTS/NS_2018_016700/NS_920181022_140908_20181022_143016/')
% plateMetaDataConverter() %Will ask for barcode.txt file
% plateMetaDataConverter(1400031); %Well ask where to store files


%% Get the barcode file:
if nargin==0
    [fname, dirname]=uigetfile('barcode.txt');
else
    if isnumeric(barcodeNumber)
    else % BarcodeNumber is path
        barcodePath=strrep(barcodeNumber,'\','/');
        if isdir(barcodePath) %strcmp(barcodePath(end),'/') || ~strcmp(barcodePath(end-3),'.') % Check if dir or dir with filename (last=='/' or has point xxxx.xxx end-3)
            fname='barcode.txt';
            if ~strcmp(barcodePath(end),'/')
                dirname=[barcodePath '/'];
            else
                dirname=[barcodePath];
            end
        else %full Path wit filename
            dd=strfind(barcodePath,'/');
            dirname=barcodePath(1:dd(end));
            fname=barcodePath((dd(end)+1):end);
        end
    end
end
if isfile([dirname fname])
    try
        fid = fopen([dirname fname], 'r');
        barcodeText = fread(fid, inf, 'uint8=>char')';
        dd = textscan(barcodeText,'%s');
        r=dd{1};
        barcodeNumber=str2num(r{1});
        fclose(fid);
    catch
        disp(['Error reading barcode in:'] );
        disp([dirname fname]);
    end
    
    %% Get the JSON server URL:
    try
        fid = fopen('../urls/urls.json', 'r');
        c = fread(fid, inf, 'uint8=>char')';
        fclose(fid);
    catch
        disp(['Could not find urls.json in ' pwd '../urls/'] )
    end
    %% Get the data from the server:
    urls = jsondecode(c);
    wellInfo = jsondecode(urlread([urls.WellDataURL num2str(barcodeNumber)]));
    %% Find the different labels:
    A={wellInfo(:).sampleCode};
    % Convert empty cells into 'Empty' to let unique work
    for i=1:96
        b=A(i);
        if isempty(b{1})
            A(i)={'Empty'};
        end
    end
    labels = unique(A);
    %% Make sure lablenames are valid
    % Labelnames can not start with a number.
    % No space, brackets, points, slashes
    
    oklabels=labels;
    for i=1:length(oklabels)
        oklabels{i}= text2OKname(oklabels{i});
    end
    %% Create csv files:
    if ~exist('dirname','var')
        dirname=uigetdir([],'Select dir to create csv files:');
    end
    
    
    % Convert empty concentrations to nan
    for i=1:length(wellInfo)
        if isempty(wellInfo(i).concentration)
            wellInfo(i).concentration=nan;
        end
        
    end
    
    for i=1:length(oklabels)
        present=strcmp( {A{:}},labels(i)); % Compare here with the un-altered labels
        cc=[wellInfo.concentration].*present;
        cc(present==0)=nan;
        cc2=reshape(cc,12,8)';
        csvwrite([dirname 'plateLayout_' oklabels{i} '.csv'],cc2);
        disp([dirname 'plateLayout_' oklabels{i} '.csv created.'])
    end
else
    disp(['Could not find barcode.txt'] );
    disp([dirname fname]);
end
