%fname = '../../data/Experiment 1_iglu spontaneous.tif';
%fname = '../../data/data_endoscope.tif';

function loadTiff2(fname)
%fname = '../../data/Experiment 5_SyG 10AP.tif';
if nargin<1    
    [FileName,PathName] = uigetfile('*.tif','Select the MATLAB code file');
    fname = [PathName FileName];
end

%%
info = imfinfo(fname);
num_images = numel(info);
A=zeros(info(1).Height,info(1).Width,num_images);
for k = 1:num_images
    A(:,:,k) = imread(fname, k);    
end
%% Calculate Average
Avg= mean(A,3);
figure; imagesc(squeeze(Avg))
%% Look at average reponse:
for k = 1:num_images
    ss(k) = sum(sum(A(:,:,k)-Avg));
end
figure;plot(ss);

%% Correlate each pixel with global dynamic response:
% We assume that all synapses behave roughly the same.
C=[];
for c = 1:size(A,2)
    C(:,c) = sum(squeeze(A(:,c,:)).*repmat(ss,[size(A,2),1,1]),2);
end
figure;
imagesc((C-mean(mean(C))));



%% Temporal filtering
B=zeros(size(A));
figure;
w=[1 0.8 0.5 0.2 0.1 0.01 0.001 0.0001 0.0001 0.0001]; %Assymetric filter
for k = 11:num_images
B(:,:,k) = A(:,:,k);
    for L=1:10
        B(:,:,k) = B(:,:,k)+w(L)*A(:,:,k-L);        
    end   
end

for k=11:num_images
    B(:,:,k)=B(:,:,k)-mean(B,3);
end
viewer(B)
%%
for k = 3:num_images
    figure(6);
    imagesc(squeeze(B(k,:,:)));
    pause(.1);
end


%%

figure;
for k = 1:num_images
    imagesc(squeeze(A(k,:,:)));  
    pause(.1)
end

%%


%%for k=1:10,
B=sum(A);

B=max(A)-min(A);
%%
    r=squeeze(B);
    d=(r>6e4).*r./num_images;
    %d=(r>1e7);
    dd=uint16(d);

    se = strel('disk',10);
    dclose = imclose(dd,se);
    figure;imagesc(dd);
%%
    s=regionprops(dclose);
    imagesc(squeeze(B))
    centroids = cat(1, s.Centroid);
    
    hold on;
    plot(centroids(:,1), centroids(:,2), 'r*')
    hold off;
    pause(.1);
    
    
    
    %%
    s = [0 0 0; 0 1 0; 0 0 0];
    
    %s = [.4 .6 .4; .4 1 .4; .4 .6 .4];
    %s = [0 0 0 0 0; 0 .4 .6 .4 0; 0 .4 1 .4 0; 0 .4 .6 .4 0; 0 0 0 0 0];
    s=s-mean(s(:));
    H = (conv2(dd,s));
    Hb=H>2000;
  %  H = uint16(conv2(dd,s));
figure, %mesh(H)
imagesc(H)
dclose= H;
    
    %%
    
    
%%end