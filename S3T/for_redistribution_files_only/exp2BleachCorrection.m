function [bcresponse, dff, BC, mstart]=exp2BleachCorrection(signal)
% bcresponse: Returns Bleach corrected Response 
% dff: delta f / f
% BC: bleach correction
% mstart: the samples used at the start of the exp fit.

avgSampleSize=30;
aSS = avgSampleSize;
LM=size(signal,2);

%mmstart= mean(signal(:,1:aSS),2);

mmend= mean(signal(:,end-aSS:end),2);

x=[(1:aSS*1) (LM-(aSS*1)):LM];
if isempty(signal)
    signal=nan*ones(1,size(signal,2));
    a=nan; b=nan; c=nan; p=nan; q=nan;
else
for i=1:size(signal,1)
    mstart= signal(i,1:aSS*1);
    
    mend= signal(i,end-(aSS*1):end);

    y=[mstart mend];

[a(i),b(i),c(i),p(i),q(i)]=exp2fit(x,y);
end
end
BC = real(a') + real(b)' .* exp(real(p)'* (1:LM))+real(c)'.*exp(real(q)'*(1:LM)); % using Matlab * expansion
%BC=(mend(:)-mstart(:))*(1:LM)/LM; % Linear Bleach Correction.
bcresponse = signal-BC;
%dff=(signal-BC-repmat(mmend,1,LM))./(repmat(mmend,1,LM)+real(a')); % Delta f over f
dff=(signal-BC)./(real(a')); % Delta f over f

% There is a regularisation between the a value which is the 2exp term
% and the more robust mend value. Both estimates are averaged to become a
% stable number also when the 2exp crashes.


% Debug
debug = 1;
n=1;
if debug
  %figure;
  subplot(4,4,4)
  cla
        
  ls = size(signal,2);
  hold off

  plot(signal(n,:),'LineWidth',3)
  hold on
  plot(BC(n,:),'g','LineWidth',3)
  
%   plot(aSS/2, mstart(n),'or','LineWidth',6)
%   plot(1:aSS, mend(n)*ones(aSS,1),'k','LineWidth',3)
%   plot(ls-aSS/2, mend(n),'or','LineWidth',6)
%  % plot([aSS/2, ls-aSS/2],[mstart(n) mend(n)],'g','LineWidth',3)
%   plot(ls-(aSS-1):ls, mend(n)*ones(aSS,1),'k','LineWidth',3)    
  
  subplot(4,4,12)
end