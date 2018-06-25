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

% Load Andor file to link exp. with well.
tttt = dir([dirname '\..\NS_*.txt']);
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

WellNbTable = array2table(exp2wellNr(experiments+1-firstExpNb)','VariableNames',{'WellNumber'});
%t=[t, NESTable, WellNbTable];
t=[t, WellNbTable];
fileNbTable = array2table(experiments','VariableNames',{'FileNumber'});
%t=[t, NESTable, WellNbTable];
t=[t, fileNbTable];

writetable(t,[dirname '\AllWells']);

end