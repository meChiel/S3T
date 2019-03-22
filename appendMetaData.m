% Function to addd extra collumns on existing AllWells/AllSynapse files.

function appendMetaData()
[fn fd]=uigetfile('*.txt','Pick allWell file.');
[fn2 fd2]=uigetfile('plateLayout_*.csv','Pick a/mutiple plateLayout files','MultiSelect', 'on');

tcsv=[]
 for (i=1:length(fn2)) % For all Plate Layout files
tcsv(i).name=fn2{i};
tcsv(i).folder=fd2(1:end-1); %remove last \ to be standard
 end
 
 %%
 aST=readtable([fd fn]);

            for (i=1:length(fn2)) % For all Plate Layout files
                
                %[plateFilename, plateDir] = uigetfile('*.csv',['Select Plate Layout File'],[defaultDir '\']);
                plateLayoutFileName= tcsv(i).name;
                plateDir = tcsv(i).folder;
                
                plateValues = csvread([plateDir '\' plateLayoutFileName]);
                rotplateValues=rot90(plateValues );
                qtyName = plateLayoutFileName(13:(end-4));
                rvec=[];
                for ii=1:height(aST)
                    rvec=[rvec; rotplateValues(aST.logicalWellIndex(ii))];
                end
                aST = [aST, array2table(rvec,'VariableNames',{text2OKname(qtyName)})];
            end
            
        writetable(aST,[fd fn(1:end-4) '2' fn(end-3:end) ])

end
