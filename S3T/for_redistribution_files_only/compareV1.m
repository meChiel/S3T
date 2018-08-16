[FileNameA,PathNameA] = uigetfile('*.tif','Select the reference experiment');
fnameA = [PathNameA FileNameA];
%%
infoA = imfinfo(fnameA);
num_imagesA = numel(infoA);
A=zeros(infoA(1).Height,infoA(1).Width,num_imagesA);
for k = 1:num_imagesA
    A(:,:,k) = imread(fnameA, k);    
end
%%
[FileNameB,PathNameB] = uigetfile('*.tif','Select the test experiment, please.');
fnameB = [PathNameB FileNameB];
%%
infoB = imfinfo(fnameB);
num_imagesB = numel(infoB);
B=zeros(infoB(1).Height,infoB(1).Width,num_imagesB);
for k = 1:num_imagesB
    B(:,:,k) = imread(fnameB, k);    
end
%% Allign:
align.upBorder =1;
align.leftBorder= 1;%8;
align.rightBorder=1;
align.downBorder=1;%42;
figure;
k=55;imagesc(A(align.downBorder:end-align.upBorder+1,align.rightBorder:end-align.leftBorder+1,k)-B(align.upBorder:end-align.downBorder+1,align.leftBorder:end-align.rightBorder+1,k))
%% Difference of time avg
figure;AM=mean(A,3);BM=mean(B,3);
imagesc(abs(AM(align.downBorder:end-align.upBorder+1,align.rightBorder:end-align.leftBorder+1)-BM(align.upBorder:end-align.downBorder+1,align.leftBorder:end-align.rightBorder+1)))
%% relative diff of time avg
figure;
imagesc(abs(AM(align.downBorder:end-align.upBorder+1,align.rightBorder:end-align.leftBorder+1)-BM(align.upBorder:end-align.downBorder+1,align.leftBorder:end-align.rightBorder+1))./AM(align.downBorder:end-align.upBorder+1,align.rightBorder:end-align.leftBorder+1))

%% Max-min, 
% does not correct for photo-bleaching.
figure;
maxA=max(A,[],3);
minA=min(A,[],3);
imagesc((maxA-minA)./mean(A,3))
%imagesc(abs(AM(downBorder:end-upBorder+1,rightBorder:end-leftBorder+1)-BM(upBorder:end-downBorder+1,leftBorder:end-rightBorder+1))./AM(downBorder:end-upBorder+1,rightBorder:end-leftBorder+1))

%% Plot alligned difference
figure
k=55;imagesc(A(align.downBorder:end-align.upBorder+1,align.rightBorder:end-align.leftBorder+1,k)-B(align.upBorder:end-align.downBorder+1,align.leftBorder:end-align.rightBorder+1,k))
%% Spines
figure; plot(smooth(squeeze(A(218,65,:)),1));
spineRepsonse(:,1)=squeeze(A(218,65,:));
%%
[mouse.X,mouse.Y]=ginput(1);
%%
M=reshape(A(:,:,51:end),[size(A,1),size(A,2),(size(A,3)-50)/5,5]);
MM=mean(M,4);
figure;plot(smooth(squeeze(M(218,65,:,:)),1));
figure;plot(squeeze(M(218,65,:,:)));
figure;plot(smooth(squeeze(MM(218,65,:)),20));

line2=smooth(squeeze(MM(218,65,:)),20);


viewer(MM-mean(MM,3));

%% Exposure time:
%
AqSetup.expTime=0.030056;
AqSetup.freq=1/AqSetup.expTime;
AqSetup.kineticSeriesLength=size(A,3);

%% Fit exp.
%dy=-ay
meanSpineRepsonse(:,1)=squeeze(MM(218,65,:));
msr=meanSpineRepsonse(:,1);
[~,indMSR]=max(smooth(msr,50));

figure; plot(msr);
msr=smooth(msr,50)-min(smooth(msr,50));

ll=-(msr((1:end-1))-msr(2:end))./msr(1:end-1);
figure; plot(ll(indMSR:150));
ay=mean (ll(indMSR:150));

%% Sort the pixels
SA=sort(A,3);
figure; plot(reshape(SA,[],size(A,3))');

%%
SABCK=SA;
SA=SA(1:20,1:20,:);
SA=SA-repmat(SA(:,:,600),1,1,size(SA,3));
figure; plot(reshape(SA,[],size(A,3))')
%%
%figure; hist(reshape(SA,[],size(A,3)))
hh=hist(reshape(SA,[],size(A,3)),1000);
figure;imagesc(hh)
%% Violin plot
% Add the distributionplot dir.
figure;distributionPlot(reshape(SA,[],size(A,3)));

%% A.U.C., P.W.
% Weigh the paper.

%% show identified spines in different colors:
showNeurons

%% Show spikes
figure;plot(neuron.S')

%% Show spike timing:
[idxframe, idxNeuron]=find(0 < neuron.S');
iTime=idxframe*1/neuron.Fs;
%%

figure;plot(idxNeuron,iTime,'*');

remove doubels


%% Count spikes
numbers=unique(idxNeuron);       %list of elements
count=hist(idxNeuron,numbers);   %provides a count of each element's occurrence


figure
bar(accumarray(idxNeuron, 1))

%% Show time constants.
figure;plot(neuron.P.kernel_pars)

%% Count spikes, don't count doubles.
spikeTestFrames= [73,333,600,833,1100];

%figure; imagesc(neuron.S'>0);
maxFiltSize=145;
maxFilt=ordfilt2(neuron.S',maxFiltSize,ones(maxFiltSize,1))>0;
%figure;imagesc(maxFilt);
testIm=full(sparse(ones(length(spikeTestFrames),1),[spikeTestFrames'],ones(length(spikeTestFrames),1),1,size(neuron.C,2)));
figure;imagesc(maxFilt+repmat(testIm',1,size(maxFilt,2)));

didSpike=maxFilt(spikeTestFrames,:);
figure; imagesc(didSpike);
figure;bar(sum(didSpike, 1));
figure;bar(sort(sum(didSpike, 1),'descend' ));
%% Spike ratio:
spikeRatio = sum(didSpike)/length(spikeTestFrames);
figure; plot(spikeRatio);
figure; plot(sort(spikeRatio,'descend'));
