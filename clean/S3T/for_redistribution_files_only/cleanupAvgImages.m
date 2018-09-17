%% cleanup

[dirpath]=uigetdir();
dirlist=dir(dirpath);
%%
%[fname, dirpath]=uigetfile();
mp=colormap('hot');
for i=3:length(dirlist)
    dd=imread([dirlist(i).folder '\' dirlist(i).name]);
    imwrite(dd/2,mp,['neuronImages/neuron' num2str(i) '.png']);
end


