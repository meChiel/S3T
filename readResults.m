function readResults(dirname)
% Reads all the output files and concatenates them and adds the meta data
% from the CSV files.
if nargin<1
    try 
        dirname = uigetdir('','Select output dir:');
    catch
         dirname = uigetdir('','Select output dir:');
    end
end
defaultDir = dirname;
files = natsort(dir([dirname '\*_analysis.txt']));
[firstPart, ~, lastPart] = disassembleName(files(1).name);

synFiles = natsort(dir([dirname '\synapseDetails\*_PPsynapses.txt']));


aWT=[]; % all Well Table
aST=[]; % all Synapse Table
fnNber=[];
for i=1:(length(files))
    files(i).name
    try
        aWT = [aWT; readtable([dirname '\' files(i).name])];
    catch
        disp(error);
    end
    %t = [t; readtable([dirname '\' num2fname(i)])];
    fnNber = [fnNber,  extractNumber(files(i).name)];
end


sfnNber=[];
for i=1:(length(synFiles))
    disp(synFiles(i).name)
    try
        SD = readtable([dirname '\synapseDetails\' synFiles(i).name]);
        aST = [aST; SD];
    catch
        disp(error);
    end
    %t = [t; readtable([dirname '\' num2fname(i)])];
    nEl(i) = size(SD,1);
    sfnNber = [sfnNber, extractNumber(synFiles(i).name)];
end

well96Data=1;
% Load Andor file to link exp. with well.
tttt = dir([dirname '\..\NS_*.txt']);
if (length(tttt)==0)
    tttt = dir([dirname '\..\..' '\NS*.txt']);
end

if (length(tttt)==0)
    tttt = dir([dirname '\..' '\Protocol*.txt']);
end
if (length(tttt)==0)
    tttt = dir([dirname '\..' '\iGlu*.txt']);
end
if (length(tttt)==0)
    tttt = dir([dirname '\..' '\PSD*.txt']);
end
if (length(tttt)==0)
    tttt = dir([dirname '\..' '\SyG*.txt']);
end
if (length(tttt)==0)
    warning('No 96-Well data found, assuming single cover slip experiment!');
    well96Data=0;
end


if (well96Data)
    
    andorfilename = [tttt.folder '\' tttt.name];
    exp2wellNr = readAndorFile(andorfilename);
    global   firstExpNb;
    if 0 % set the file name numbering if the first file name 0 or 1, Andor multiwell naming = 0;
        firstExpNb=1;warning('firstExpNb Hacked');
    else
        firstExpNb=0;
    end
    
    %     experiments = 0:59;
    %     experiments = 1:19; warning('experiments Hack');
    experiments = (1:size(aWT,1))-1;
    
    % Load the compound for all wells.
    tcsv = dir([dirname '\..' '\plateLayout_*.csv']);
    if (length(tcsv)==0)
        tcsv = dir([dirname '\..\..' '\plateLayout_*.csv']);
    end
    
    subplot(4,4,[2:3, 6:7]);
    for (i=1:length(tcsv)) % For all Plate Layout files
        
        %[plateFilename, plateDir] = uigetfile('*.csv',['Select Plate Layout File'],[defaultDir '\']);
        plateLayoutFileName= tcsv(i).name;
        plateDir = tcsv(i).folder;
        
        plateValues = csvread([plateDir '\' plateLayoutFileName]);
        
        plate.plateValues = plateValues;
        plate.expwells = exp2wellNr;
        
        wellQty = getPlateValue(plate,experiments);
        
        qtyName = plateLayoutFileName(13:(end-4));
        %NESTable = array2table(wellQty','VariableNames',{'NES'});
        qtyTable = array2table(wellQty','VariableNames',{qtyName});
        aWT = [aWT, qtyTable];
        rvec=[];
        for ii=1:length(nEl)
            rvec=[rvec; repmat(table2array(qtyTable(ii,1)),nEl(ii),1)];
        end
        aST = [aST, array2table(rvec,'VariableNames',{qtyName})];
        
        plot(wellQty, aWT.peakAmp,'o-')
        xlabel(qtyName);
        ylabel('peakAmp');
    end
    
    WellNbTable = array2table(exp2wellNr(experiments+1-firstExpNb)','VariableNames',{'AndorWellNumber'});
    %t=[t, NESTable, WellNbTable];
    aWT=[aWT, WellNbTable];
       rvec=[];
        for ii=1:length(nEl)
            rvec=[rvec; repmat(table2array(WellNbTable(ii,1)),nEl(ii),1)];
        end
        aST = [aST, array2table(rvec,'VariableNames',{'AndorWellNumber'})];
     
    
    plate.plateValues = reshape(1:96,12,8)';
    plate.expwells = exp2wellNr;
    
    logicalWellIndex = getPlateValue(plate,experiments);
    logicalWellIndexTable = array2table(logicalWellIndex','VariableNames',{'logicalWellIndex'});
    aWT=[aWT, logicalWellIndexTable];
      rvec=[];
        for ii=1:length(nEl)
            rvec=[rvec; repmat(table2array(logicalWellIndexTable(ii,1)),nEl(ii),1)];
        end
        aST = [aST, array2table(rvec,'VariableNames',{'logicalWellIndex'})];
    
    
    RowIndex = floor(logicalWellIndex/12)+1;
    RowIndexTable = array2table(RowIndex','VariableNames',{'PRow'}); % Plate Row
    aWT=[aWT, RowIndexTable];
       rvec=[];
        for ii=1:length(nEl)
            rvec=[rvec; repmat(table2array(RowIndexTable(ii,1)),nEl(ii),1)];
        end
        aST = [aST, array2table(rvec,'VariableNames',{'PRow'})];
  
    
    
    colIndex = mod(logicalWellIndex-1,12)+1;
    colIndexTable = array2table(colIndex','VariableNames',{'PCol'}); % Plate Collumn
    aWT=[aWT, colIndexTable ];
          rvec=[];
        for ii=1:length(nEl)
            rvec=[rvec; repmat(table2array(colIndexTable(ii,1)),nEl(ii),1)];
        end
        aST = [aST, array2table(rvec,'VariableNames',{'PCol'})];
  
    
    
    fileNbTable = array2table(experiments','VariableNames',{'FileNumber'});
    %t=[t, NESTable, WellNbTable];
    aWT=[aWT, fileNbTable];
        rvec=[];
        for ii=1:length(nEl)
            rvec=[rvec; repmat(table2array(fileNbTable(ii,1)),nEl(ii),1)];
        end
        aST = [aST, array2table(rvec,'VariableNames',{'FileNumber'})];
  
    
    
    
else %if single coverslip Data
    tcsv = dir([dirname '\..' '\MetaData*.csv']);
    if length(tcsv)==0  
        tcsv = dir([dirname '\..\..' '\MetaData*.csv']);
    end
     plateDir = tcsv(1).folder;
    bb = readtable([plateDir '\' 'MetaData.csv'],'Delimiter',',');
    
    % Check wich fields are numeric
    cc=table2cell(bb);
    for i=1:width(bb)
        numericEntries(i)=isnumeric(cc{1,i});
    end
    
    metaTable=[];
    fname=[];
    k=1;
    for i=1:length(files)
        for j=1:height(bb)
            microData = files(i).name;
            metaData = bb.MovieFilename{j};
            if (strcmp(microData(1:end-length('_analysis.txt')),metaData(1:end-length('.tif'))))
                fname{k}=microData(1:end-length('_analysis.txt'));
                disp([num2str(i) ',' num2str(j) ',' num2str(k) ]);
                metaTable(k,:)=bb{j,numericEntries};
                k=k+1;
            end
        end
    end
   try
        metaTable2=  array2table(metaTable,'VariableNames',{bb.Properties.VariableNames{numericEntries}});
   catch e
       disp(['Problems in: ' dirname])
       error(e.message);       
   end
   aWT=[aWT, metaTable2];
   
   %fileNb = catNumbers({bb.MovieFilename{:}},4);
 
   rvec=[];
   for ii=1:length(nEl)
       rvec=[rvec; repmat(sfnNber(ii),nEl(ii),1)];
   end
   aST = [aST, array2table(rvec,'VariableNames',{'FileNumber'})];
end

writetable(aST,[dirname '\AllSynapses']);
writetable(aWT,[dirname '\AllWells']);
end