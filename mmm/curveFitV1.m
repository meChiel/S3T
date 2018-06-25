function [parResult, fit] = curveFit1(data,init)
if ~exist('init','var')
    init = [1:4]+8;
end

%evEq= @(x,p) p(1) + p(2)*exp(-((x-p(3))/p(4))) + p(5)*exp(-((x-p(3))/p(6)));
evEq= @(x,p) p(1) + p(2)*x;%+ p(3)*x.^2+ p(4)*x.^3+ p(5)*x.^4+ p(6)*x.^5;

%p=[1:5];
calcR = @(p,data) sqrt(sum((evEq(data.x,p)-data.y).^2));

% calcR(p)
parResult = fminsearch(@(p) calcR(p,data),init,optimset('MaxFunEvals',100000,'MaxIter',100000));
fit = evEq(data.x,parResult);


figure;plot(data.x,data.y);
hold on
plot(data.x,fit);
disp( ['residu' num2str(calcR(parResult,data))]);
norm(evEq(data.x,parResult)-data.y)

end