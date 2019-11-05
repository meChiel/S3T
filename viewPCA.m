% Select different datagroups
figure; 
x=[];
for i=1:5
    N{i}=compounds{i};%'TTX';
    
    %N2='TTX';
    G0 = data{1}.(N{i});
    
    tx0 = tdata(~isnan(G0),:);
    
    x{i}=tx0;
    plot(x{i}(:,2),x{i}(:,9),'.');
    hold on;
end
legend(N)
xlabel('Synapse Amplitude (\DeltaF/F)')
ylabel('\tau')

%%
pp=[];
for i=1:length(x)
    pp= [pp; x{i}];
end


epp=mean(pp);
stdpp=std(pp);
ppn=(pp-epp)./(stdpp+.1);
%%
[U, S, V]=svd(ppn,'econ');

%%
figure;plot(V(:,1))
%%
figure;
tt1=[];
tt2=[];

for i=1:5
    nx=(x{i}-epp)./(stdpp+.1);
    tt1{i}=nx*V(:,1);
    tt2{i}=nx*V(:,2);
    plot(tt1{i},tt2{i},'.');
    hold on;
end
xlabel('PCA1')
ylabel('PCA2')
legend(N)
