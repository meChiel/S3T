function tiffJoiner(path,fileName1,fileName2)
% Joins 2 tiff files into 1.
% 1 Argument = default pathname
% 2 Argument filenames 1 and 2 to join.
% Example1: tiffJoiner
% Example2: tifjoiner(defaultpath)
% Example3: tiffJoiner(path,fileName1,fileName2)
% path='C:\Users\MVanDyc5\Desktop\jj\work\segmentation\data\Rajiv\3 sept 2017\NS_2017_016620170906_155133_20170906_155227'
% filename='NS_2017_016620170906_155133_e000'
% for m=1:5,tiffJoiner([path '\'], [filename num2str(m) '_tt0000.tif'],[filename num2str(m) '_tt0001.tif']);end
if nargin==0   
    PathName1=cd;
end

if nargin==3
    PathName1=path;
    PathName2=path;
    FileName1=fileName1;
    FileName2=fileName2;
end

if ~exist('FileName1','var')
[FileName1,PathName1] = uigetfile('*.tif','Select the 1st tiff file',PathName1);
[FileName2,PathName2] = uigetfile('*.tif','Select the 2nd tiff file',PathName1);
end

fname1 = [PathName1 FileName1 ];
fname2 = [PathName2 FileName2 ];
%% 
info1 = imfinfo(fname1);
num_images1 = numel(info1);

info2 = imfinfo(fname2);
num_images2 = numel(info2);


%A=uint16zeros(info1(1).Height,info1(1).Width,num_images1+num_images2);

for k = 1:num_images1
    A(:,:,k) = imread(fname1, k);    
end

for k = 1:num_images2
    A(:,:,num_images1+k) = imread(fname2, k);    
end


%%

t = Tiff([PathName1 'comb_' FileName1 ],'w');
t1 = Tiff(fname1,'r');
tagstruct.ImageLength = size(A,1)
tagstruct.ImageWidth = size(A,2)
tagstruct.Photometric = t1.getTag('Photometric');%Tiff.Photometric.MinIsBlack
tagstruct.BitsPerSample = t1.getTag('BitsPerSample');
tagstruct.SamplesPerPixel = t1.getTag('SamplesPerPixel');
tagstruct.RowsPerStrip = t1.getTag('RowsPerStrip'); 
tagstruct.PlanarConfiguration = t1.getTag('PlanarConfiguration');%Tiff.PlanarConfiguration.Chunky
tagstruct.Software = 'tiffJoiner';


for k = 1:size(A,3)
t.setTag(tagstruct)

%t.write(uint16(squeeze(A(:,:,k))));
t.write(squeeze(A(:,:,k)));
t.writeDirectory()
end
t.close();


end