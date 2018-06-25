kern=synsignal(1168:1205,17);
%kern2=fliplr(kern)-mean(kern);
kern2=(kern)-mean(kern);


%%
sig=dff(synsignal(:,17)',0)';
cosig=conv(sig,kern,'same')/1e5;
kern3=cosig(1154:1193);
cosig2=conv(cosig,kern3,'same')/1e5;
figure;plot(cosig2)
dd=xcorr(sig,kern);
%ssig = smooth(xas,sig,.06,'loess');

ssig=diff(cosig);
figure;
plot(cosig);
hold on;
%plot(sig);
plot(ssig);
sssig = diff(ssig);
plot(sssig.*(sssig>0.01)*10);
%%
xas= 1:length(sig);
hold on
[ pksId]=find(sssig>.01);
%
%[pks, pksId]= findpeaks(ssig,'MinPeakDistance',.01);
%
%%'MinPeakProminence',0.01,'Threshold',.001,
npks = length(pksId)
ein=ones(npks,1);
plot([pksId pksId]',[ein 0*ein]','r')
hold on;
plot(xas,sig);

%%

T=toeplitz(sig);
%sigR=reshape(sig,60,[]);
[U S V]=svd(T);

figure;plot(U(:,4))