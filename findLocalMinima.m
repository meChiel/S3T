function [minima]=findLocalMinima(dataY,nbP,range)
% dataY=randn(200,1)+12*sin((1:200)*0.03)';findLocalMinima(dataY,6,4)
% Starts to distribute a number of points nbP equidistant over the entire
% x-range of data and then finds the local minima starting from that point.
% These points can be used to fit a (double) exponential to fix for
% photobleaching.
figure(8);
for i=1:(range+1)
    dataY=[inf; dataY; inf];
end

startX=((range+1):floor(length(dataY)/nbP):(length(dataY)-(range+1)))';
left=1;right=1;
%startXOld=startX+1;
%while startXOld~=startX
while((sum(left)+sum(right))>0)
%startXOld=startX;
    left=dataY(startX)>dataY(startX-1);
    %left=max(left,2*(dataY(startX)>dataY(startX-2)));
    for i=1:range
        left=max(left,i*(dataY(startX)>dataY(startX-i)));
    end
    startX=startX-left;
    
    right=dataY(startX)>dataY(startX+1);
    %right=max(right,2*(dataY(startX)>dataY(startX+2)));
    for i=1:range
        right=max(right,i*(dataY(startX)>dataY(startX+i)));
    end
    startX=startX+right;

    plot(dataY);hold on;plot(startX,dataY(startX),'or');hold off;
    pause(.1)
end
minima.x = startX;
minima.y = dataY(startX);

