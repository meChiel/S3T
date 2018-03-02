function [bcresponse, dff, BC, mstart]=linBleachCorrect(signal)

mstart= mean(signal(:,1:30),2);
mend= mean(signal(:,end-30:end),2);
LM=size(signal,2);
BC=(mend(:)-mstart(:))*(1:LM)/LM; % Linear Bleach Correction.
bcresponse = signal-BC;
dff=(signal-BC-repmat(mstart,1,LM))./repmat(mstart,1,LM); % Delta f over f

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
  plot(15, mstart(n),'or','LineWidth',6)
  plot(1:30, mstart(n)*ones(30,1),'k','LineWidth',3)
  plot(ls-15, mend(n),'or','LineWidth',6)
  plot([15, ls-15],[mstart(n) mend(n)],'g','LineWidth',3)
  plot(ls-29:ls, mend(n)*ones(30,1),'k','LineWidth',3)    
  
  subplot(4,4,12)
end
%figure