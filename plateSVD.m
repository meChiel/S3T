% function plateSVD()

dirname=uigetdir();
%%
tfiles= dir([dirname '\*.tif']);
nof = 12;length(tfiles);
f=zeros(512,512*nof,550);

tic
for i=1:nof
    disp(['loading:' tfiles(i).name]);
    f(1:512,((i-1)*512)+(1:512),1:550) = loadTiff([dirname '\' tfiles(12+i).name]);
    
end
disp ('Loading Time:') ;
toc
%
tic;
[u, s, v]=svd(reshape(f,512*nof*512,[]),'econ');
toc
%
figure;
noe=8;
for i= 1:noe
subplot(noe,1,i);imagesc(reshape(u(:,i),512,512*nof));colormap('gray');
axis('off')
end
%
figure;
for i= 1:noe
subplot(noe,1,i);plot(v(:,i),'k');
end
%%
figure;imagesc(diag(s(1:noe,1:noe))')

