%
plateOnOff = [...
    0 0 0 0 0 0 0 0 0 0 0 0;
    0 1 1 1 1 1 1 1 1 1 1 0;
    0 1 1 1 1 1 1 1 1 1 1 0;
    0 1 1 1 1 1 1 1 1 1 1 0;
    0 1 1 1 1 1 1 1 1 1 1 0;
    0 1 1 1 1 1 1 1 1 1 1 0;
    0 1 1 1 1 1 1 1 1 1 1 0;
    0 0 0 0 0 0 0 0 0 0 0 0;
    ]'; % Transpose to make the serialisation from left to right iso up to down. 
% this direction is the direction the virtual microscope XY - stage will
% scan the different wells.


numOfWells = sum(plateOnOff(:));
andorText = ['Well ' num2str(numOfWells) '\n-----------\n\n Repeat - Well\n']; 

layout = [1:12;13:24;25:36;37:48;49:60;61:72;73:84;85:96]';
idx=find(plateOnOff==1);

for i=1:numOfWells
    andorText = [andorText '\t Well ' num2str(layout((idx(i)))) '\n \t\t XY 1- \n'];
end

fid = fopen('protocol-Simulation.txt','w');
fprintf(fid,andorText,'%s');
fclose(fid);
    