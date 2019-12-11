function [im, compoundName, clegendd, Y]=generatePlateSummary(dd,color)
% Creates an plate Overview image based on the plate layoutfiles and will color each 
% combination in a different color.
% dd is the directory with the platelayoutfiles in.
%
% Color defines if the output is a 3D coordinate/RGB image or just the value / index?
if nargin<2
    color =0;
end
dcsv=dir([dd '\PlateLayout_*.csv']);

r=zeros(8,12,length(dcsv));
for i=1:length(dcsv)
    r(:,:,i)=csvread([dcsv(i).folder '\' dcsv(i).name]);
    compoundName{i}=dcsv(i).name(13:end-4);
end


% convert nan to 0
for i=1:size(r,3)
    rr=r(:,:,i);
    rr(isnan(rr(:,:)))=0;
    r(:,:,i)=rr;
end

sr=zeros(8,12);
for i=1:size(r,3)
    sr=sr+r(:,:,i)*i*10;
    slegend(i)=max(max(r(:,:,i)))*i*10;
end
[~, si]=sort(slegend);
compoundName=compoundName(si);
im = sr;
if color
[Y,NEWMAP] = cmunique(im);
my=max(Y(:));
lu=unique(sr);
lNM=length(NEWMAP);
jj=colorwheel(1:360/64:360);
im=ind2rgb(uint8(mod(floor(Y*(64/lNM)),64)),jj);
clegendd=ind2rgb(uint8(mod(floor(uint8((1:lNM)-1)*(64/lNM)),64)),jj);
end

%figure;imagesc(sr*2);colormap jet
