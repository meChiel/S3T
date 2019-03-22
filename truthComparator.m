% truthComparator

fp=[];
fn=[];
for ii=1:59
pt='Y:\data\simulation\sim3\';
pt='F:\share\data\simulation\sim3\';
pt='F:\share\data\simulation\Noise=0.01-10 PBA=1\';
t = num2str(ii+100);
warning off;
r = load([pt 'GT\groundTruth00' t(2:end) '.mat']);
warning on;
pos=r.pos;
spikeAmplitude=r.spikeAmplitude;
spikeAmplitude2=r.spikeAmplitude2;
spikeAmplitude3=r.spikeAmplitude3;
tFrame=r.tFrame;
f=r.f;
spiketimes = r.spiketimes;
spiketimes2 = r.spiketimes2;
spiketimes3 = r.spiketimes3;
bgF=r.bgF;
PB=r.PB;
decaytime = r.decaytime;
decaytime2 = r.decaytime2;

spineshape=r.spineshape;
images=zeros(512,512);
for i=1:length(pos) % For active spines
    %images(pos(i,1),pos(i,2))=images(pos(i,1),pos(i,2))+bgF(i);
    images(pos(i,1),pos(i,2)) = images(pos(i,1),pos(i,2))+spikeAmplitude(i)*(tFrame/2>abs(f*tFrame-spiketimes(i)));
    images(pos(i,1),pos(i,2)) = images(pos(i,1),pos(i,2))+spikeAmplitude2(i)*(tFrame/2>abs(f*tFrame-spiketimes2(i)));
    images(pos(i,1),pos(i,2)) = images(pos(i,1),pos(i,2))+spikeAmplitude3(i)*(tFrame/2>abs(f*tFrame-spiketimes3(i)));
    images(pos(i,1),pos(i,2)) = (bgF(i)+(images(pos(i,1),pos(i,2)) - bgF(i) - PB(i))*decaytime(i))+PB(i);
    PB(i)= PB(i)*decaytime2(i);
end
tas = conv2(spineshape,images); %Truth Active Spines
tas=tas(1:512,1:512);
tasm = tas>mean(tas(:))+3*std(tas(:));
cm = imread([pt 'SVD2-1AP_Analysis\NS_120181002_1046_e00' t(2:end) '.tif_mask.png']);
% figure;imagesc(cm>0)
diff=(double(cm>0)-double(tasm));
fp(ii)=sum(sum(diff>.5));
fn(ii)=sum(sum(diff<-.5));
figure(3);imagesc(diff);
imagesc(tasm)
drawnow();
end
%%
fpSVD2=fp;
fnSVD2=fn;
%%
fpSVD1=fp;
fnSVD1=fn;
%%
fpSVD3=fp;
fnSVD3=fn;
%%
fpSTD=fp;
fnSTD=fn;
%%
figure;plot(fpSTD);hold on;plot(fpSVD1);plot(fpSVD2);plot(fpSVD3);legend('STD','SVD1','SVD2','SVD3');title('false postive [pixels]'); xlabel('artificial sample Number'); ylabel('misclassified number of pixels');
figure;plot(fnSTD);hold on;plot(fnSVD1);plot(fnSVD2);plot(fnSVD3);legend('STD','SVD1','SVD2','SVD3');title('false negative [pixels]'); xlabel('artificial sample Number'); ylabel('misclassified number of pixels');


%% plot ifo Noise
plate.plateValues=plateNoise;
plate.expwells=[14:23,26:35,38:47,50:59,62:71,74:83];
dd=getPlateValue(plate,1:59); %0:59
%anova1(fnSTD'+fpSTD', dd(:));
figure;semilogx(dd(:),fnSTD'+fpSTD' ,'o');
xlabel ('Noise multiplier');
 ylabel ('# misclassified pixels');
 title('STD');
 x=axis;
hold on,
%anova1(fnSVD2'+fpSVD2, dd(:));
figure;semilogx(dd(:), fnSVD2'+fpSVD2','o');
 xlabel ('Noise multiplier');
 ylabel ('# misclassified pixels');
title('SVD2');
axis(x);
%% boxPlot ifo Noise
plate.plateValues=plateNoise;
plate.expwells=[14:23,26:35,38:47,50:59,62:71,74:83];
dd=getPlateValue(plate,1:59); %0:59
%anova1(fnSTD'+fpSTD', dd(:));
figure;boxplot(fnSTD'+fpSTD', dd(:),'Whisker',100,'Notch','off');
xlabel ('Noise multiplier');
 ylabel ('# misclassified pixels');
 title('STD');
hold on,

%anova1(fnSVD2'+fpSVD2, dd(:));
figure;boxplot(fnSVD2'+fpSVD2, dd(:),'Whisker',100,'Notch','off');
 %xticklabels({'STD', 'SVD2'});
 xlabel ('Noise multiplier');
 ylabel ('# misclassified pixels');
title('SVD2');


%% Boxplot ifo Photo Bleaching
plate.plateValues=platePBA;
plate.expwells=[14:23,26:35,38:47,50:59,62:71,74:83];
dd=getPlateValue(plate,1:59); %0:59
%anova1(fnSTD'+fpSTD', dd(:));
figure;boxplot(fnSTD'+fpSTD',dd(:),'Whisker',100,'Notch','on');
xlabel ('Photo Bleaching multiplier');
 ylabel ('# misclassified pixels');
 title('STD');
hold on,
%anova1(fnSVD2'+fpSVD2, dd(:));
figure;boxplot(fnSVD2'+fpSVD2', dd(:),'Whisker',100,'Notch','on');
 %xticklabels({'STD', 'SVD2'});
 xlabel ('Photo Bleaching multiplier');
 ylabel ('# misclassified pixels');
title('SVD2');
%%
%%
figure;
boxplot([fpSTD' fpSVD2' ],'Whisker',100,'Notch','off');
 xticklabels({'STD', 'SVD2'});
 ylabel ('# misclassified pixels');
title('Method comparison: false positives');
%%
%anova1
figure;
boxplot([fnSTD' fnSVD2'],'Whisker',100,'Notch','off');
 xticklabels({'STD', 'SVD2'});
 ylabel ('# misclassified pixels');
title('Method comparison: false negatives');
%%
figure;
boxplot([fnSTD'+fpSTD' fnSVD2'+fpSVD2' fnSVD1'+fpSVD1' fnSVD3'+fpSVD3'],'Notch','off');
 xticklabels({'STD', 'SVD2' 'SVD1' 'SVD3'});
 ylabel ('# misclassified pixels');
title('Method comparison: false pos.+neg.');

%% Overview
figure;
subplot(2,2,1);
imagesc(log(plateNoise(2:7,2:11)));
axis equal
axis off
title('Log(Noise amplifier)')
colorbar
subplot(2,2,2);
imagesc(log(platePBA(2:7,2:11)));
axis equal
axis off
title('Log(Photo Bleach Amplitude)')
colorbar
subplot(2,2,3);
imagesc(rot90(reshape([2000 fnSTD],10,6)))
title('Error: STD')
c=caxis;
axis equal
axis off
colorbar

%figure;imagesc(reshape([fnSVD2],6,10))
subplot(2,2,4);imagesc(rot90(reshape([0 fnSVD2],10,6)))
title('Error: SVD2')
caxis(c);

axis equal
axis off
colorbar

