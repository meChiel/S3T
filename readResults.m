function readResults()

dirname = uigetdir();
defaultDir = dirname;
files = dir([dirname '\*_analysis.txt']);
t=[];
for i=1:(length(files))
    t=[t; readtable([dirname '\' files(i).name])];
end

% Load Andor file to link exp with well
tttt = dir([dirname '\NS_*.txt']);
if (length(tttt)==0)
    tttt = dir([dirname '\..' '\Protocol*.txt']);
end
andorfilename = [tttt.folder '\' tttt.name];
exp2wellNr = readAndorFile(andorfilename);

% Load the compound for all wells.
for (i=1:3) 

[plateFilename, plateDir] = uigetfile('*.csv',['Select Plate Layout File'],[defaultDir '\']);
 plateValues = csvread([plateDir '\' plateFilename]);
       
plate.plateValues = plateValues;
plate.expwells = exp2wellNr;

experiments = 0:59;
wellQty = getPlateValue(plate,experiments);

plot(wellQty, t.mASR,'o')
qtyName = plateFilename(13:(end-4))
%NESTable = array2table(wellQty','VariableNames',{'NES'});
qtyTable = array2table(wellQty','VariableNames',{qtyName});
t=[t, qtyTable];
end
WellNbTable = array2table(exp2wellNr(experiments+1)','VariableNames',{'WellNumber'});
%t=[t, NESTable, WellNbTable];
t=[t, WellNbTable];
writetable(t,[dirname '\AllWells']);

end