filnm=1;
i=1;
fname=[];
fdir=[];
while (filnm)
[filnm, filedir] = uigetfile();
fname{i} = filnm;
fdir{i} = filedir;
i=i+1;
end


