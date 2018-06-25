% Read the data
 for i=2:11
    nn= num2str(100+i);
    CS{i}=readtable(['Y:\Michiel\AD\CS' nn(2:3) '_AllWells.txt']);
 end

q=(CS{2}.Stimulation==10);
mean(CS{2}.mASR(q))
std(CS{2}.mASR(q))

%%
%stim =  [ 1  
    stim = [ 2        4        ];%8    10    20    40];

%%
clrs=['k', 'k', 'k', 'k', 'b', 'b','b', 'b', 'g', 'g', 'g']
figure;
hold on
clear mA sA
for i=2:11
    %plot(CS{2}.Stimulation(1:end-1), CS{2}.mASR(1:end-1),'*');
    for s=1:size(stim,2)
        q=CS{i}.Stimulation==stim(s);
        mA(s) = mean(CS{i}.mASR(q));
        sA(s) = std(CS{i}.mASR(q));
    end
    %errorbar(stim+i*.1,mA,sA,clrs(i))
   % plot(stim, mA, [clrs(i) 'o']);
    errorbar(stim+i*.02,mA,sA,clrs(i),'lineStyle','none','MarkerSize',8,'Marker','o')
    
    
end

for i=2:11
    q=CS{i}.Stimulation==2 | CS{i}.Stimulation==4;
    plot(CS{i}.Stimulation(q)+i*.02, CS{i}.mASR(q),[clrs(i) '*' ])
    %plot(kk, CS{i}.mASR(ii),'*-')
end

legend('control','control','control','AD','AD','AD','AD','tau','tau','tau')

xlabel ('stimulus')
ylabel('Amplitude')
%plot(CS{3}.Stimulation(1:end-1), CS{3}.mASR(1:end-1),'*')
