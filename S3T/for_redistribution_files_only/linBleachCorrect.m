function [bcresponse, dff, BC, mstart]=linBleachCorrect(signal)
% Bleach Corrected response
% Delta f/f response
% BC: Bleach Correction
% mStart: mean value at the start of the trace, Base level

avgSampleSize=3;
aSS = avgSampleSize;

mstart= mean(signal(:,1:aSS),2);
mend= mean(signal(:,end-aSS:end),2);

LM=size(signal,2);
BC=(mend(:)-mstart(:))*(1:LM)/LM; % Linear Bleach Correction.
bcresponse = signal-BC;
dff=(signal-BC-repmat(mstart,1,LM))./repmat(mstart,1,LM); % Delta f over f

% Debug
debug = 0;
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