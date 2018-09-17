function [bcresponse, dff, BC, mstart] = linMinBleachCorrect(signal)
%
%

LM=size(signal,2);
avgSampleSize=floor(LM/4);
aSS = avgSampleSize;

[mstart, mstartInd]= min(signal(:,1:aSS),[],2);
[mend, mendInd]= min(signal(:,(end-aSS):end),[],2);
mendInd = mendInd+LM-aSS; 
BC = (mend(:)-mstart(:))./(mendInd-mstartInd)*(1:LM); % Linear Bleach Correction.
bcresponse = signal-BC;
dff = (signal-BC-repmat(mstart,1,LM))./repmat(mstart,1,LM); % Delta f over f

% Debug
debug = 1;
n=1;
if debug
  %figure;
  subplot(4,4,4)
  cla
        
  ls = size(signal,2);
  plot(signal(n,:),'LineWidth',3)
  hold on
  plot(aSS/2, mstart(n),'or','LineWidth',6)
  plot(1:aSS, mstart(n)*ones(aSS,1),'k','LineWidth',3)
  plot(ls-aSS/2, mend(n),'or','LineWidth',6)
  plot([aSS/2, ls-aSS/2],[mstart(n) mend(n)],'g','LineWidth',3)
  plot(ls-(aSS-1):ls, mend(n)*ones(aSS,1),'k','LineWidth',3)    
  
  subplot(4,4,12)
end
%figure