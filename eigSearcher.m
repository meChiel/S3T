dirs='F:\share\toBeProcessed\1 NOW\2-10-2018\NS_2320181002_141908_20181002_144044\eigs';
dirs='Z:\create\_Rajiv_HTS\NS_2018_016542\NS_2420181002_151904_20181002_154040\eigs';
%%
dirs=uigetdir('F:\share\Rajiv\Data for Michiel\');
%%
csvfiles= dir([dirs '\*eigV1.csv']); clear dd;
for i=1:length(csvfiles)
dd(:,1,i)= csvread([csvfiles(i).folder '\' csvfiles(i).name]);
dd(:,2,i)= csvread([csvfiles(i).folder '\' csvfiles(i).name(1:(end-5)) '2.csv']);
dd(:,3,i)= csvread([csvfiles(i).folder '\' csvfiles(i).name(1:(end-5)) '3.csv']);
dd(:,4,i)= csvread([csvfiles(i).folder '\' csvfiles(i).name(1:(end-5)) '4.csv']);
dd(:,5,i)= csvread([csvfiles(i).folder '\' csvfiles(i).name(1:(end-5)) '5.csv']);
dd(:,6,i)= csvread([csvfiles(i).folder '\' csvfiles(i).name(1:(end-5)) '6.csv']);
dd(:,7,i)= csvread([csvfiles(i).folder '\' csvfiles(i).name(1:(end-5)) '7.csv']);
dd(:,8,i)= csvread([csvfiles(i).folder '\' csvfiles(i).name(1:(end-5)) '8.csv']);
end

%% 
figure(1);
for i=1:length(csvfiles)%60
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
for i=1
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

figure(2);
for i=1
    subplot(8,1,1)
    hold off;
    plot(dd(:,1,i),'k','lineWidth',3);
    axis([0 600 -0.3 0.3])
    ylabel('eig 1');
    %hold on;  
    subplot(8,1,2)
    plot(dd(:,2,i),'k','lineWidth',3);
    ylabel('eig 2');
    subplot(8,1,3)
    plot(dd(:,3,i),'k','lineWidth',3);
    ylabel('eig 3');
    subplot(8,1,4)
    plot(dd(:,4,i),'k','lineWidth',3);
    ylabel('eig 4');
    subplot(8,1,5)
    plot(dd(:,5,i),'k','lineWidth',3);
    ylabel('eig 5');
    subplot(8,1,6)
    plot(dd(:,6,i),'k','lineWidth',3);
    ylabel('eig 6');
    subplot(8,1,7)
    plot(dd(:,7,i),'k','lineWidth',3);
    ylabel('eig 7');
    subplot(8,1,8)
    plot(dd(:,8,i),'k','lineWidth',3);
    ylabel('eig 8');
    title(csvfiles(i).name(end-15:end-10));
end
%%
figure(5); hold off;
plot(mean(dd,3));
hold on;
plot(mean(dd,3)+std(dd,[],3),'.')
plot(mean(dd,3)-std(dd,[],3),'.')
