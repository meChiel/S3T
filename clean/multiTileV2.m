% multi-tile

bigPict=[];
xpos=[];
ypos=[];
%%
%for L = 1:285
%PathName= 'C:\Users\MVanDyc5\Desktop\jj\work\scanning\multi-tile\manualpanoramascan\';
PathName= 'F:\jj\michiel\mvandyc5\jj\work\segmentation\scripts\tile\';
FileName=['NS_2017_1420171012_164940'];% num2str(22+L)];
%[FileName,PathName] = uigetfile('*.tif','Select the MATLAB code file');
fname = [PathName FileName '.tif'];
fname= 'Y:\data\Michiel\Protocol1420171121_162003.tif';

txtname = [PathName FileName '.txt'];
txtname  = 'Y:\data\Michiel\xy162003.txt';
%% open the text file
 fid = fopen(txtname);

 
S = fscanf(fid,'%s');
       
fclose(fid);
%%
pos=strfind(S,['-(' ]);
for L=1:100        
        line=S(pos(L)+(2:15));
        firstC=strfind(line,',');
        
       xpos(L)=str2num(line(1:firstC(1)));
       ypos(L)=str2num(line(firstC(1)+1:firstC(2)-1));
        
      
           % C = textscan(fid, '%c',100);
       

end
 
%%
xpos=xy(1,:);
ypos=xy(2,:);

 %%
mx=min(xpos);
my=min(ypos);
dx=max(xpos)-min(xpos)
dy=max(ypos)-min(ypos)
%%
A=zeros(ceil(dy*3.75)+512,ceil(dx*3.75)+512);

%A=zeros(ceil(dy)+512,ceil(dx)+512);


info = imfinfo(fname);
num_images = numel(info);
%A=zeros(info(1).Height,info(1).Width,num_images);

sc=1/0.266666666;
for k = 1:212
    
  %  FileName=['Current' num2str(22+k)];

    %fname = [PathName FileName '.tif'];
    B=imread(fname, k);
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

%%
k1=23; FileName=['Current' num2str(22+k1)];fname = [PathName FileName '.tif'];B=imread(fname, 1);
D=B;                                                                 
k2=24; FileName=['Current' num2str(22+k2)];fname = [PathName FileName '.tif'];B=imread(fname, 1);
E=B;
for (ddx=0:500)
ddx
A=zeros(ceil(dy*3.75)+512,ceil(dx*3.75)+512);
%
A(1:512,floor((xpos(k1)-mx)*3.75)+(1:512))=double(D);
%        A(1:512,xpos(k2)-mx+ddx+(1:512))=A(1:512,xpos(k2)-mx+ddx+(1:512))+double(E);
%A(1:512,floor((xpos(k2)-mx)*1.3)+0+(1:512))=double(E);
A(1:512,floor((xpos(k2)-mx)*3.75)+ddx+(1:512))=A(1:512,floor((xpos(k2)-mx)*3.75)+ddx+(1:512))+double(E);
    %figure(1);
imagesc(A);
pause(); 
end 
                 


%%
[FileName,PathName] = uigetfile('*.tif','Select the MATLAB code file');
fname = [PathName FileName];
%%
info = imfinfo(fname);
num_images = numel(info);
A=zeros(info(1).Height,info(1).Width,num_images);
for k = 1:num_images
    A(:,:,k) = imread(fname, k);    
end
