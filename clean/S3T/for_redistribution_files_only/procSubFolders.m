pdir = uigetdir();
d = dir([ pdir '/*.*']);
for i=3:length(d)
   startWorker('thumbnailCreator([inputDir inputFile])',[pdir '\' d(i).name '\' ]);
end

%%

pdir = uigetdir();
d = dir([ pdir '/*.*']);
for i=3:length(d)
    inputDir = [pdir '\' d(i).name '\' ]
   startWorker('overviewGenerator()');
end
