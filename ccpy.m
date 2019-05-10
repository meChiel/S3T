function d=ccpy()
% This is a compressed copy.
% This is build to copy from a processed plate of information, only the 
% results, with eig and a nameid to be able to use fastload.
[d1]=uigetdir([],'please select source dir:');
ff=strfind(d1,'\')
if ff(end)==length(d1)
    lastSlash=ff(end-1)
    d1=d1(1:(end-1));
else
    lastSlash=ff(end)
end 
r=d1((lastSlash+1):end);

[d2]=uigetdir([],'please select dest dir:');
d2=[d2 '\' r];
 
disp('Will copy')
disp('files of:')
disp(d1)
disp('into: ')
disp(d2)
disp('Press a key to continue:')
pause

eval(['!robocopy "' d1 '" "' d2 '"' ' /E /XF *.tif']); 
eigdir=[d2 '\eigs'];

makeFakeTiffs(eigdir)

disp('-------------')
disp('files of:')
disp(d1)
disp('copied into: ')
disp(d2)
