function readResults(dirname)
% Reads all the output files and concatenates them and adds the meta data
% from the CSV files.
if nargin<1
    dirname = uigetdir('','Select output dir:');
end
defaultDir = dirname
files = natsort(dir([dirname '\*_analysis.txt']));
[firstPart, ~, lastPart]=disassembleName(files(1).name);

t=[];
fnNber=[];
for i=1:(length(files))
    files(i).name
    t = [t; readtable([dirname '\' files(i).name])];
    %t = [t; readtable([dirname '\' num2fname(i)])];
    fnNber = [fnNber,  extractNumber(files(i).name)];
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
    experiments = (1:size(t,1))-1;
    
    % Load the compound for all wells.
    tcsv = dir([dirname '\..' '\plateLayout_*.csv']);
    if (length(tcsv)==0)
        tcsv = dir([dirname '\..\..' '\plateLayout_*.csv']);
    end
    
    
    subplot(4,4,[2:3, 6:7]);
    for (i=1:length(tcsv))
        
        %[plateFilename, plateDir] = uigetfile('*.csv',['Select Plate Layout File'],[defaultDir '\']);
        plateFilename= tcsv(i).name;
        plateDir = tcsv(i).folder;
        
        plateValues = csvread([plateDir '\' plateFilename]);
        
        plate.plateValues = plateValues;
        plate.expwells = exp2wellNr;
        
        wellQty = getPlateValue(plate,experiments);
        
        qtyName = plateFilename(13:(end-4))
        %NESTable = array2table(wellQty','VariableNames',{'NES'});
        qtyTable = array2table(wellQty','VariableNames',{qtyName});
        t = [t, qtyTable];
        
        plot(wellQty, t.peakAmp,'o-')
        xlabel(qtyName);
        ylabel('peakAmp');
    end
    
    WellNbTable = array2table(exp2wellNr(experiments+1-firstExpNb)','VariableNames',{'AndorWellNumber'});
    %t=[t, NESTable, WellNbTable];
    t=[t, WellNbTable];
    
      plate.plateValues = reshape(1:96,12,8)';
        plate.expwells = exp2wellNr;
        
        logicalWellIndex = getPlateValue(plate,experiments);
        logicalWellIndexTable = array2table(logicalWellIndex','VariableNames',{'logicalWellIndex'});
      t=[t, logicalWellIndexTable];
      
       RowIndex = floor(logicalWellIndex/12)+1;
        RowIndexTable = array2table(RowIndex','VariableNames',{'PRow'}); % Plate Row
      t=[t, RowIndexTable];
      
      
       colIndex = mod(logicalWellIndex-1,12)+1;
        colIndexTable = array2table(colIndex','VariableNames',{'PCol'}); % Plate Collumn
      t=[t, colIndexTable ];
      
    
    fileNbTable = array2table(experiments','VariableNames',{'FileNumber'});
    %t=[t, NESTable, WellNbTable];
    t=[t, fileNbTable];
    
   
else %if single coverslip Data
    tcsv = dir([dirname '\..' '\MetaData*.csv']);
    if length(tcsv)==0  
        tcsv = dir([dirname '\..\..' '\MetaData*.csv']);
    end
     plateDir = tcsv(1).folder;
    bb = readtable([plateDir '\' 'MetaData.csv']);
    
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
                i, j, k
                metaTable(k,:)=bb{j,numericEntries};
                k=k+1;
            end
        end
    end
   metaTable2=  array2table(metaTable,'VariableNames',{bb.Properties.VariableNames{numericEntries}});
   t=[t, metaTable2];
end

 writetable(t,[dirname '\AllWells']);
end