function [bcresponse, dff, BC, mstart]=autoPWLinFit(seq,doPlot)
% Does an automatic piecwise linear fit for non montone parts of the curve.
% When rico>0, find make interval longer.

if nargin<2
    doPlot=0;
end
seq=seq(:);
% calculate noise ratio
r=sort(seq);
noiseRange=std(r(1:ceil(length(r)*0.05)));

% Start piecewise linear fit.
% Fit using all points in 2*sigma

%allPoints = (1:length(seq))';
L=0;
rangeMean=seq(1);
k=5;
PLF=[]; % Piecewise Linear Fit
LMSrico=[seq(1) 0];
goodRico=LMSrico;
while((k+L)<length(seq))
    %allPoints = k+(0:L)';
    %  rangeMean=(goodRico(2)*allPoints+goodRico(1));
    %  pseq=seq(k+(0:L));
    %  points = allPoints(pseq<(rangeMean+noiseRange*2)); %*1.00001 to compensate rounding errors
    %  minPoints = seq(points);
    bp=k+(-4:0);
    ep=k+(L-4:L);
    tp=[bp ep];
    LMSricoB=[bp'*0+1 bp']\seq(bp');%begin
    mb=mean(seq(bp'));
    me=mean(seq(ep'));
    LMSricoE=[ep'*0+1 ep']\seq(ep');%end
    LMSricoT=[tp'*0+1 tp']\seq(tp');%total
    if mb<=me %(LMSricoB(1) < LMSricoE(1))% ||  (LMSricoE(2)>0) || (LMSricoT(2)>0) || (abs(LMSricoB(2)-LMSricoE(2))>0.15)
        L=L+1;
        allPoints = k+(0:L)';
        %rangeMean = (LMSricoT(2)*allPoints+LMSricoT(1));
    else
        PLF= [PLF (LMSricoT(2)*(k:(k+ceil(L/1)))+LMSricoT(1))]; % Piecewise linear fit
        if doPlot
            figure(1);hold off;plot(seq);hold on; plot(PLF);
            plot(tp,seq(tp'),'*')
        end
        %pause;
        goodRico=LMSrico;
        k=k+ceil(L/1);
        L=5;
    end
end
if isempty(PLF)
    PLF=seq(1);
end
ldiff=length(seq)-length(PLF);
PLF=[PLF PLF(end)*ones(1,ldiff)];
PLF=PLF(1:length(seq));
%PLF=smooth(PLF,0.3,'loess');
x=(1:length(PLF))/length(PLF);
y=PLF;
% [a,b,c,p,q]=exp2fit(x,y-500);
% BC = real(a') + real(b)' .* exp(real(p)'* x)+real(c)'.*exp(real(q)'*x);

bcresponse=seq(:)-PLF(:);
dff=(seq(:)-PLF')./PLF'; BC=PLF; mstart=PLF(1);
if doPlot
    figure(6);plot(x,y,x,BC)
end

    function test()
        %%
        t1= 0.1*exp(0:-.01:-18);
        t2= [zeros(1,60) exp(0:-.01:-18)];
        t3= [zeros(1,400) exp(0:-.01:-18)];
        t=t1(1:1800)+t2(1:1800)+t3(1:1800)+0.01*randn(1,1800)+500;
        figure;plot(t);
        [bcresponse, dff, BC, mstart]=autoPWLinFit(t);
        figure;plot(bcresponse)
        figure;plot(smooth(BC,0.99,'loess'))
        hold on;plot(t1+500)
        hold on;plot(smooth(BC,1))
        plot(t);
    end
end

