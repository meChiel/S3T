signal = synsignal(:,3);
fss=fft(signal);
%%
figure;plot(abs(fss))
%%

%%
figure;plot(abs(fss))
%%
fss2=fss;
%fss2(1)=0; % remove mean
% Remove low freq.
sz1=1
fss2(1:sz1)=0;
fss2(end-sz1:end)=0;

%fss2(1)=0;
% Remove high freq.
sz=175;
fss2(400/2-sz:400/2+sz)=0;

figure;plot(real(ifft(fss2)))
hold on;plot(signal-mean(signal))

