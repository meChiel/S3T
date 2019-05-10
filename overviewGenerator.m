%clear inputDir;
%%
function overviewGenerator(inputDir)
if exist('inputDir','var')
    inputDir=inputDir;
else
    inputDir= uigetdir();    
    %inputPath='L:\beerse\all\Public\Exchange\michiel\Rajiv\NS_20174220170912_143321_20170912_144604 - copy\';
end

if  ~strcmp(inputDir(end),'\')
    inputDir = [inputDir '\'];    
end
%%
%inputDir='E:\Data\Rajiv\26-9-2017\NS_2017920170926_140832_20170926_142329\';
%names = {'temp','analysis','align','avg','mask','signals'...
    %};
%  names = {'hist','mean','meanAS','changeAS','eigenNeuron_1'};
% % 
%  names = {'hist','mean','meanAS','changeAS','eigenNeuron_1'...
%  'eigenNeuron_1','eigenNeuron_2','eigenNeuron_3','eigenNeuron_4','eigenNeuron_5'...
%  'eigenNeuron_1R','eigenNeuron_2R','eigenNeuron_3R','eigenNeuron_4R','eigenNeuron_5R'};
% 

names = {...
  'temp','analysis','align','avg','mask','signals'...
      ,'hist','mean','meanAS','changeAS','eigU1'...
  ,'eigU2','eigU3','eigU4','eigU5','eigU6'...
  ,'eigU7','eigU8','eigU9','eigU10','eigU11'...
  ,'eigU12','eigU13','eigU14','eigU15','eigU16'...
  'eigenNeuron_1R','eigenNeuron_2R','eigenNeuron_3R','eigenNeuron_4R','eigenNeuron_5R'...
,'eigenNeuron_6R','eigenNeuron_7R','eigenNeuron_8R','eigenNeuron_9R','eigenNeuron_10R'...
,'eigenNeuron_11R','eigenNeuron_12R','eigenNeuron_13R','eigenNeuron_14R','eigenNeuron_15R'...
,'eigenNeuron_16R'...
};
% 


for iii=1:length(names)
ffname = names {iii};
pngFiles=dir([inputDir '*' ffname '.png']);
if ~isempty(pngFiles)
ims=natsort(pngFiles);

%ims(1:2)=[]; disp('First 2 entries removed from overview!');%Delete first two entries
clear a;
for ii=1:length(ims)
    %[a(:,:,i), mapp(:,:,i)]=imread([inputDir  ims(i).name]);
    tempImage=imread([inputDir  ims(ii).name]);
    [sx, sy, sz]= size(tempImage);
    [a(1:sx,1:sy,1:sz,ii)]=tempImage;
end
%
[s1,s2, s3, s4]=size(a);
%b= reshape(a, 512,[]);
b= reshape(a(:,:,:,1),[s1,s2,s3]);%, 512,[]);
figure(6);imagesc(b);
%
nx=10;
ny=6;
vspace=5;
hspace=5;
imHSize=s2;512;875;656;512;
imVSize=s1;512;656;875;512;
if isa(a,'uint8')
    bb=uint8(zeros((imVSize+vspace)*ny,(imHSize+hspace)*nx,s3));
elseif isa(a,'uint16')
    bb=uint16(zeros((imVSize+vspace)*ny,(imHSize+hspace)*(nx),s3));
    if strcmp(ffname,'mask')
        bb=bb+2^15-1; %makes background grey
    end
end

%bb=zeros((imVSize+vspace)*ny,(imHSize+hspace)*nx,3);
k=0;
for i=0:(ny-1)
    for j=0:(nx-1)
        k=k+1;
        %if k<=size(a,3)
        if k<=size(a,4)
            %bb(i*(imHSize+vspace)+(1:imVSize),j*(imHSize+hspace)+(1:imHSize))=a(:,:,k); 
            b=a(:,:,:,k);
            bb(i*(imHSize+vspace)+(1:imVSize),j*(imHSize+hspace)+(1:imHSize),:)=double(b); 
        end
    end 
end
drawnow();
%imwrite(bb,mapp(:,:,1),[inputDir '_overview.png'])
if strcmp(ffname,'avg')
    mpa = colormap(hot);
    imwrite(bb,mpa,[inputDir ffname '_overview.png'])
else 
    imwrite(bb,[inputDir ffname '_overview.png'])
end
disp([inputDir ffname '_overview.png Generated'])
figure(7);image(bb);
else
    disp(['OverviewGenerator : No ' ffname ' entries found for overview generator in ' inputDir]);
    %break;
end
end