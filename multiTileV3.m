fname='Y:\data\Michiel\Protocol1120171121_161207.tif';
txtname='Y:\data\Michiel\Protocol1120171121_161207.txt';
%%
fname= 'Y:\data\Michiel\Protocol1420171121_162003.tif';
txtname  = 'Y:\data\Michiel\Protocol1420171121_162003.txt';
%%
fname= 'Y:\data\Michiel\Protocol1220171121_161824.tif';
txtname  = 'Y:\data\Michiel\Protocol1220171121_161824.txt';

%% open the text file
fid = fopen(txtname);
S = fscanf(fid,'%s');       
fclose(fid);
%%
 pos=strfind(S,['Fields' num2str(32768)]);
 for L=1:100  
       xpos(L)=str2num(S(pos(L)+10+(1:10)));
       ypos(L)=str2num(S(pos(L)+22+(1:11)));
 end

 %%
 data=A;
 %%
mx=min(xpos);
my=min(ypos);
dx=max(xpos)-min(xpos)
dy=max(ypos)-min(ypos)

%%
[data fname]=loadTiff(fname);
%%

A=zeros(ceil(dy*3.75)+512,ceil(dx*3.75)+512);

sc=1/0.266666666;
for k = 1:100
    
  %  FileName=['Current' num2str(22+k)];

    %fname = [PathName FileName '.tif'];
    %B=imread(fname, k);
    nframes=10; % frames Per field
    B=mean( data(:,:,(k-1)*nframes+(1:nframes)),3);
   % figure(1);imagesc(B);
    %pause
    %if k>192
    %    B=double(B)/3.33;
    %end
    cy=floor((ypos(k)-my)*sc);
    cx=floor((xpos(k)-mx)*sc);
    
    %A(floor((ypos(k)-my)*sc)+(1:512),floor((xpos(k)-mx)*sc)+(1:512)) = 1/2*A(floor((ypos(k)-my)*sc)+(1:512),floor((xpos(k)-mx)*sc)+(1:512)) + 1/2*double(B)  ;  
    A(cy+(1:512),cx+(1:512)) = (A(cy+(1:512),cx+(1:512)).*A(cy+(1:512),cx+(1:512))+double(B).*double(B))./(A(cy+(1:512),cx+(1:512))+double(B)+.0001)  ;  
    %A(1:512,floor((xpos(k2)-mx)*3.75)+ddx+(1:512))=A(1:512,floor((xpos(k2)-mx)*3.75)+ddx+(1:512))+double(E);

    
end
figure(1);
imagesc(A);
pause(.01);


%% OLD Read images
if 0
    info = imfinfo(fname);
    num_images = numel(info);
    A=zeros(info(1).Height,info(1).Width,num_images);
    for k = 1:num_images
        A(:,:,k) = imread(fname, k);
    end
end
%% OLD Concatenate the images:
if 0
    B=zeros(512*10,512*10);
    for k=0:9
        for j=0:9
            for i=1:30
                wx=1:512;
                B(wx+k*512,wx+j*512)=B(wx+k*512,wx+j*512)+A(:,:,i+j*30+k*30*10);
            end
        end
    end
end
%%
%figure;
image(A/60-4)

%% Export
jj=colormap('hot');
imwrite(A/60-4,jj,'figure1618.png','bitdepth',8,'colormap','hot')
