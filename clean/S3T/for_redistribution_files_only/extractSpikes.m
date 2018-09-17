%% Folds the multiple spikes of a 5 x 1AP stimulus protocol onto each other fdfd

function spikes=extractSpikes(seqf)
%%
k=90;
spikes=[];
for i=1:5
stf=[6 71 136 200 265]; % SpikeStartFrames
spikes(i,1:k) = seqf(stf(i)+(1:k));
end
figure; plot(spikes');
figure; plot(mean(spikes)');
