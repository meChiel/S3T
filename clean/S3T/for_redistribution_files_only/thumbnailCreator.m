%startWorker('thumbnailCreator([inputDir inputFile])');
%pdir = uigetdir();
%d = dir([ pdir '/*.*']);
%for i=3:length(d)
%   startWorker('thumbnailCreator([inputDir inputFile])',[pdir '\' d(i).name '\' ]);
%end
%fname = '../../data/Experiment 1_iglu spontaneous.tif';
%fname = '../../data/data_endoscope.tif';

function error = thumbnailCreator(fname)
%fname = '../../data/Experiment 5_SyG 10AP.tif';
error=1;
if nargin<1    
    [FileName,PathName] = uigetfile('*.tif','Select the MATLAB code file');
    fname = [PathName FileName];
end

%% read the images
info = imfinfo(fname);
num_images = numel(info);
A=zeros(info(1).Height,info(1).Width,num_images);
for k = 1:num_images
    A(:,:,k) = imread(fname, k);    
end
%% Calculate Average
Avg= mean(A,3);
%figure(2); imagesc(squeeze(Avg))
%% Look at average reponse:
for k = 1:num_images
    %ss(k) = sum(sum(A(:,:,k)-Avg));
    AvgResponse(k) = mean(mean(A(:,:,k)));%-Avg));
end
%fig=figure(1);plot(AvgResponse);
%mpa = colormap(hot);
%imwrite((Avg-min(min(Avg)))/(max(max(Avg))-min(min(Avg))+100)*128,mpa,[fname '.png']);
%%
%axis off
 %saveas(fig,[fname '2.png'])
 save([fname '_results.mat'],'Avg','AvgResponse');%,'-append')
    error= 0;
%close all
