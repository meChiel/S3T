dirs='F:\share\toBeProcessed\1 NOW\2-10-2018\NS_2320181002_141908_20181002_144044\eigs';
dirs='Z:\create\_Rajiv_HTS\NS_2018_016542\NS_2420181002_151904_20181002_154040\eigs';
%%
dirs=uigetdir();
%%
csvfiles= dir([dirs '\*eigV1.csv']); clear dd;
for i=1:length(csvfiles)
dd(:,1,i)= csvread([csvfiles(i).folder '\' csvfiles(i).name]);
dd(:,2,i)= csvread([csvfiles(i).folder '\' csvfiles(i).name(1:(end-5)) '2.csv']);
dd(:,3,i)= csvread([csvfiles(i).folder '\' csvfiles(i).name(1:(end-5)) '3.csv']);
dd(:,4,i)= csvread([csvfiles(i).folder '\' csvfiles(i).name(1:(end-5)) '4.csv']);
dd(:,5,i)= csvread([csvfiles(i).folder '\' csvfiles(i).name(1:(end-5)) '5.csv']);
dd(:,6,i)= csvread([csvfiles(i).folder '\' csvfiles(i).name(1:(end-5)) '6.csv']);
end

%% 
figure(1);
for i=1:60
    subplot(6,10,i)
    plot(dd(:,1,i),'r','lineWidth',2);
    hold on;  
    plot(dd(:,2,i),'g');
    plot(dd(:,3,i),'b');
    plot(dd(:,4,i),'k');
    plot(dd(:,5,i),'c');
    plot(dd(:,6,i),'m');
    title(csvfiles(i).name(end-15:end-10));
end
%%

figure(2);
for i=38
    %subplot(6,10,i)
    hold off;
    plot(dd(:,1,i),'r','lineWidth',2);
    hold on;  
    plot(dd(:,2,i),'g');
    plot(dd(:,3,i),'b');
    plot(dd(:,4,i),'k');
    plot(dd(:,5,i),'c');
    plot(dd(:,6,i),'m');
    title(csvfiles(i).name(end-15:end-10));
end
%%
figure(5); hold off;
plot(mean(dd,3));
hold on;
plot(mean(dd,3)+std(dd,[],3),'.')
plot(mean(dd,3)-std(dd,[],3),'.')
