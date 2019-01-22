function [firstPart, number, lastPart]= disassembleName(filename)
% Decomposes analysis filename: NS_520181102152223_e0002_analysis.txt
% into firstPart: NS_520181102152223_ 
% number: 2
% lastPart: _analysis.txt
% Extract numbers:
underscoreIndex=strfind(filename,'_'); % find all '_'
% Use number between last 2 '_'
u1=underscoreIndex(end-1)+1;
u2=underscoreIndex(end)-1;
if (strcmp(filename(u1),'e'))
number=str2num(filename((u1+1):u2));
else
number=str2num(filename(u1:u2));
end
firstPart = filename(1:(u1-1));
lastPart =  filename((u2+1):end);
end