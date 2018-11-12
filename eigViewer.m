function eigViewer()
if nargin<1
    eigDir=uigetdir([],'Select eig dir:');
end
if ~exist([eigDir '\eigU1_overview.png'],'file')
    overviewGenerator(eigDir);
end
dd=imread([eigDir '\eigU1_overview.png']);
figure(1);
for i=1:6
    dd=double(imread([eigDir '\eigU' num2str(mod(i,6)+1) '_overview.png']));
    
    dd(dd==0)=2^15;
    imagesc(dd);
    
    md= median(dd(:));
    id= iqr(dd(:));
    y = prctile(dd(:),[2.5 25 50 75 97.5]); % a useful summary of x
    y = prctile(dd(:),[5 22 50 99 90]); % a useful summary of x
    
    caxis([y(2) y(4)+0.01])
    %      caxis([md-id/0.5,md+id/0.5])
    imwrite(1-(dd-y(2))/(y(4)-y(2)+.01),[eigDir '\neurons' num2str(mod(i,6)+1) '.jpg'])
    pause(1);
    
end
end