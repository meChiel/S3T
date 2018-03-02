Y2=reshape(Y,[512,512,400]);
sigg=(squeeze(mean(mean(Y2(400:420,240:260,:),1),2)));
%%
figure(1);spectrogram(sigg,kaiser(25,5),24,140,Fs,'yaxis');
%%
[a b]=findpeaks(sigg,'NPeaks',5,'MinPeakDistance',30)