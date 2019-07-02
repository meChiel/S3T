[A, fname, FileName, PathName, U, S, V, error]=loadTiff([],1);
%%

sx=size(A,2);336;512; 
sy=size(A,1);256;512;
R=reshape(U(:,1),sy,sx);
G=reshape(U(:,2),sy,sx);
B=reshape(U(:,3),sy,sx);
P=[];
P(:,:,1)=G;
P(:,:,2)=R;
P(:,:,3)=B;

figure('color',[0 0 0]);
subplot(1,4,1);imagesc(R);
subplot(1,4,2);
imagesc(G);
subplot(1,4,3);imagesc(B);
subplot(1,4,4);image(P*100);
colormap gray

%%

R2=reshape(U(:,4),sy,sx);
G2=reshape(U(:,5),sy,sx);
B2=reshape(U(:,6),sy,sx);
P2=[];
P2(:,:,1)=R2;
P2(:,:,2)=G2;
P2(:,:,3)=B2;
figure('color',[0 0 0]);image(P2*100);axis equal;axis off;
col=[0 1 0;1 0 0; 0 0 1;...%];
    0 1 0;1 0 0; 0 0 1];


%%
figure('color',[0 0 0]);
subplot(1,2,1);
image(P*100);axis equal, axis off

subplot(1,2,2)
image(P2*100);
axis equal, axis off

%%
%pause

for channel=1:16

%%


clf
movWrite=1;
if movWrite
    
accuracy=16;
%vidObj = VideoWriter([PathName FileName(1:end-4) '__SVDVideo_a' num2str(accuracy) '.avi']);

accuracy=1;

vidObj = VideoWriter([PathName FileName(1:end-4) '__SVDVideo_a' num2str(accuracy) '_c' num2str(channel) '.avi'],'Grayscale AVI');
    
    %vidObj = VideoWriter('overviewVideo.avi','MPEG-4');
    % vidObj = VideoWriter('overviewVideo.avi','Motion JPEG 2000');
    %vidObj.CompressionRatio=1000;
    %vidObj.Quality=90;
    open(vidObj);
end


%col=colormap('hsv');
%col=colormap('gray');
%col=colormap('hot');
% col=[
% 2 2 2;...
% 6 0 0;...
% 0 10 0;...
% 0 0 10;...
% 0 10 10;...
% 10 10 0;...
% 1 0 1;...
% 1 0 1;...
% 1 0 1;...
% 1 0 1;...
% 1 0 1;...
% 1 0 1;...
% 1 0 1;...
% 1 0 1;...
% 1 0 1;...
% 1 0 1;...
% 1 0 1;...
% ]*1/10*2;


bgCol=[0 0 .5]*.6;
cbCol=[1 0 0]*2;
Acol=[0 1 0]*1.3;
Bcol=[0 1 1]*0.5;
col=[bgCol;cbCol; Bcol;...%];
    Acol;Acol; Acol;...
    Acol;Acol; Acol;...
    Acol;Acol; Acol;...
    Acol;Acol; Acol;...
    Acol;Acol; Acol;...
    Acol;Acol; Acol;...
    ]*.6;

comp=zeros(sy,sx,3);
f1=figure(2);
set(f1,'color',[0 0 0]);
for h=channel;%16:16
    for t=1:1:size(A,3)
    t
    fullcomp=zeros(sy,sx,3);    
    comp=zeros(sy,sx,1);
         % comp=zeros(sy,sx);
         for hh=channel;%1:h
             % E=reshape(U(:,hh)*log(S(hh,hh))*V(t,hh)'*col(hh*10,:),[sy,sx,3]);
             %E=reshape(U(:,hh)*sqrt(S(hh,hh))*V(t,hh)'*col(hh*10,:),[sy,sx,3]);
             %E=reshape(U(:,hh)*(S(hh,hh))*.41*col(mod((hh-1)*45,64)+1,:),[sy,sx,3 ]);
             %E=reshape((0+U(:,hh)*(S(hh,hh))*V(t,hh)')*col(hh*1,:),[sy,sx,3 ]);
             E=reshape((0+U(:,hh)*(S(hh,hh))*V(t,hh)'),[sy,sx,1 ]);
             
             % Other
          %   F=reshape((0+U(:,hh)*(S(hh,hh))*V(t,hh)')*[.3 .3 .3],[sy,sx,3 ]);
             %E=reshape(U(:,hh)*(S(hh,hh))*.1*col(hh*1,:),[sy,sx,3 ]);
             %E=reshape(U(:,hh)*2000*1*col(hh*1,:),[sy,sx,3 ]);
             
              % Saturate E
           % E(E>1)=1;
            % E(E<0)=0;
             
             comp=comp+E;
            % fullcomp=fullcomp+F;
         end
    
    figure(2); 
    currFrame=comp/60/4+0.5;
    
    %currFrame = [fullcomp/26 zeros([size(A,1),30,3]) comp/26];
    image(currFrame);
    % Saturate
            currFrame(currFrame>1)=1;
            currFrame(currFrame<0)=0;
            
%     image(currFrame);
%     subplot(1,2,1)
%     image(fullcomp);
%     subplot(1,2,2)
%     r=gcf
if movWrite
    writeVideo(vidObj,currFrame);
    %writeVideo(vidObj,r);
end
    axis equal,axis off;
    title(num2str(t),'color',[.5 .5 .5]);
    pause(.1)
    end
    
end

%
if movWrite
    close(vidObj);
    disp([PathName '\' FileName(1:end-4) '__synapseSVDVideo_a' num2str(accuracy) '.avi'])
end
end
image(comp/20)

%%
figure;
%image([1:60]');
%colormap('hsv');
image(permute(reshape(repmat(col(1:16,:)',100,1)*64,[3,100*16,1]),[2,3,1]));
%colormap('hsv');

%yticklabels({'eig1','eig2','eig3','eig4','eig5','eig6'})
yticklabels({'eig1','eig2','eig3','eig4','eig5','eig6','eig7','eig8','eig9','eig10','eig11','eig12','eig13','eig14','eig15','eig16'})
xticklabels({' '})

