dd2=loadTiff; %best to load e0010 or e0020
%%
dd=dd2;
%%
figure; 
trace=(squeeze(mean(mean(dd))));
[~,~,bc]=findBaseFluorPoints(trace');
%%
pbcrm1=trace(1)./trace;
pbcrm2=trace(1)./bc;

pbcdd=zeros(size(dd));
%%
for i=1:size(dd,3)
    pbcdd(:,:,i)=dd2(:,:,i)*pbcrm1(i);
    pbcdd2(:,:,i)=dd2(:,:,i)*pbcrm2(i);
end
%%

trace2=[];
trace3=[];
trace4=[];
trace5=[];
figure;
%imagesc(mean(dd2,3));
ax=gca();
ax.YDir='normal';
colormap gray
hold on
parts=16;
N=512/parts;
s=200;
ts=512/(s*1.25)/(parts);
y=60;
as=512/y/(parts);


for i=1:parts
    for j=1:parts
        trace2(i,j,:)=(squeeze(mean(mean(pbcdd(N*(i-1)+(1:N),N*(j-1)+(1:N),:)))));
        trace5(i,j,:)=(squeeze(mean(mean(pbcdd2(N*(i-1)+(1:N),N*(j-1)+(1:N),:)))));
        trace3(i,j,:)=(squeeze(mean(mean(dd2(N*(i-1)+(1:N),N*(j-1)+(1:N),:)))));
        trace4(i,j,:)=(findBaseFluorPoints(squeeze(mean(mean(dd2(N*(i-1)+(1:N),N*(j-1)+(1:N),:))))')');
       % plot((s*1.25*(j-1)+(1:s))*ts,(y*(i)+squeeze(trace3(i,j,1:s)-trace3(i,j,1)))*as,'g','linewidth',.5);
        hold on
        plot((s*1.25*(j-1)+(1:s))*ts,(y*(i)+0*squeeze(trace3(i,j,1:s)-trace3(i,j,1)))*as,'k','linewidth',.5);
        hold on
        plot((s*1.25*(j-1)+(1:s))*ts,(y*(i)+squeeze(trace2(i,j,1:s)-trace2(i,j,1)))*as,'r','linewidth',.5);
        %plot((s*1.25*(j-1)+(1:s))*ts,(y*(i)+squeeze(trace4(i,j,1:s)-0*trace4(i,j,1)))*as,'c','linewidth',.5);
        %plot((s*1.25*(j-1)+(1:s))*ts,(y*(i)+squeeze(trace5(i,j,1:s)-1*trace5(i,j,1)))*as,'c','linewidth',.5);
    end
end
%axis off
%legend('before','after')
title('Photobleach correction')


