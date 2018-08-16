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
names = {'temp','analysis','align','avg','mask','signals'};
%  names = {'hist','mean','meanAS','changeAS','eigenNeuron_1'};
% % 
%  names = {'hist','mean','meanAS','changeAS','eigenNeuron_1'...
%  'eigenNeuron_1','eigenNeuron_2','eigenNeuron_3','eigenNeuron_4','eigenNeuron_5'...
%  'eigenNeuron_1R','eigenNeuron_2R','eigenNeuron_3R','eigenNeuron_4R','eigenNeuron_5R'};


for iii=1:length(names)
ffname = names {iii};
pngFiles=dir([inputDir '*' ffname '.png']);
if ~isempty(pngFiles)
ims=natsort(pngFiles);

%ims(1:2)=[]; disp('First 2 entries removed from overview!');%Delete first two entries
clear a;
for ii=1:length(ims)
    %[a(:,:,i), mapp(:,:,i)]=imread([inputDir  ims(i).name]);
    [sx, sy, sz]= size(imread([inputDir  ims(ii).name]));
    [a(1:sx,1:sy,1:sz,ii)]=imread([inputDir  ims(ii).name]);
end
%
[s1,s2, s3, s4]=size(a);
%b= reshape(a, 512,[]);
b= reshape(a(:,:,:,1),[s1,s2,s3]);%, 512,[]);
figure(6);imagesc(b);
%
nx=10-1;
ny=1;%=7;
vspace=5;
hspace=5;
imHSize=s2;512;875;656;512;
imVSize=s1;512;656;875;512;
if isa(a,'uint8')
    bb=uint8(zeros((imVSize+vspace)*ny,(imHSize+hspace)*nx,s3));
elseif isa(a,'uint16')
    bb=uint16(zeros((imVSize+vspace)*ny,(imHSize+hspace)*nx,s3));
    if strcmp(ffname,'mask')
        bb=bb+2^15-1;
    end
end

%bb=zeros((imVSize+vspace)*ny,(imHSize+hspace)*nx,3);
k=0;
for i=0:ny
    for j=0:nx
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
    warning(['OverviewGenerator : No ' ffname ' entries found for overview generator in ' inputDir]);
    %break;
end
end