function psonwrite(filename,fr)
%filename='gal2.pson';
c2=jsonencode(fr);
c2=strrep(c2,'\','£'); % for json escape character or json \

c2=strrep(c2,'££','\');
c2=strrep(c2,',',[',' 13]);
c2=strrep(c2,'[',['[' 13]);
c2=strrep(c2,']',[13 ']' 13]);

fid = fopen(filename, 'w');
fwrite(fid,c2,'uint8');
fclose(fid);
end