%[filename,pathname] = uigetfile('C:\*.tif','Select Tiff');
%pname = [pathname filename];
function ifd62TimeStamps = readExactAndorTifTime(pname)
fid = fopen(pname, 'r');
fseek(fid, 0, 'bof');
fseek(fid, 4, 'bof');
ifh = fread(fid, 4, 'uint8');
jumpfirst=str2num([int2str(ifh(4)) int2str(ifh(3)) int2str(ifh(2)) int2str(ifh(1))]);

fseek(fid, jumpfirst, 'bof');
ifd = fread(fid, 2, 'uint8');
rep=str2num([int2str(ifd(2)) int2str(ifd(1))]);

%next ifd
fseek(fid, jumpfirst+2+((rep-2)*12), 'bof');
a=dec2hex(fread(fid, 12, 'uint8'),2);
nextsixtwotag=hex2dec([a(12,:) a(11,:) a(10,:) a(9,:)]);
fseek(fid, nextsixtwotag+8, 'bof');
ifd62TimeStamps(1)= fread(fid, 1, 'float64', 'ieee-le.l64')

%next pointer
fseek(fid, jumpfirst+2+(rep*12), 'bof');
ifdnextpointer = dec2hex(fread(fid, 4, 'uint8'),2);
nextifd=hex2dec([ifdnextpointer(4,:) ifdnextpointer(3,:) ifdnextpointer(2,:) ifdnextpointer(1,:)]);

i=1;
while nextifd~=0
    i=i+1;
    fseek(fid, nextifd, 'bof');
    ifd = fread(fid, 2, 'uint8');
    rep=str2num([int2str(ifd(2)) int2str(ifd(1))]);
    %next timestamp
    fseek(fid, nextifd+2+((rep-1)*12), 'bof');
    a=dec2hex(fread(fid, 12, 'uint8'),2);
    nextsixtwotag=hex2dec([a(12,:) a(11,:) a(10,:) a(9,:)]);
    fseek(fid, nextsixtwotag+8, 'bof');
    ifd62TimeStamps(i)= fread(fid, 1, 'float64', 'ieee-le.l64');
    %next pointer
    fseek(fid, nextifd+2+(rep*12), 'bof');
    ifdnextpointer = dec2hex(fread(fid, 4, 'uint8'),2);
    nextifd=hex2dec([ifdnextpointer(4,:) ifdnextpointer(3,:) ifdnextpointer(2,:) ifdnextpointer(1,:)]);
end
% fclose(fid);
% fid = fopen([pathname filename(1:length(filename)-4) 'TimeStamp' '.txt'], 'wb');
% fprintf(fid, '%14.f \n', ifd62TimeStamps);
% fclose(fid);

end