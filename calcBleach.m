dd=uigetdir();
%%
pbdf=[];
f=dir([dd '\*raw*']);
for i=1:length(f)
t=readtable([[f(i).folder '\' f(i).name]]);
bf{i}=mean(table2array(t(1:10,2:end)),1); %base fluoresence
pbdf{i}=table2array(t(end,2:end))-bf{i}; % photobleaching
end
%%
pv=[];
bfv=[];
for i=2:length(pbdf)
pv=[pv pbdf{i}];
bfv=[bfv bf{i}];
end
%%
figure;
hist3([pv;bfv]',[100,100])
 xlabel('photoBleach'); ylabel('base fluoresence');
       set(gcf,'renderer','opengl');
       set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');

%%
figure;
loglog(pv,bfv,'o')