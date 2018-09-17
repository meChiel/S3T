global stimLstX
global stimLstY
global data
global responses



[x, y]=ginput(1);
currentDataX =data{1}.(stimLstX.Value);
currentDataY =data{1}.(stimLstY.Value);
[m, mi]=min(sum([x-currentDataX y-currentDataY].^2,2));
[responseFile, responsePath]=uigetfile('*.csv');
responses = csvread([responsePath responseFile]);
subplot(4,4,5)
plot(responses (mi,:))

