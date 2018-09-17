function matlabCodeRunner()
[f, p]=uigetfile();   
fid=fopen([p f],'r');
text = fread(fid,'*char');
fclose(fid);
eval(text);
reply=' ';
while (~strcmp(reply,'quit'))
reply = input('Do you want more? Y/N [Y]:','s');
eval(reply);
end
disp('quiting now');
end