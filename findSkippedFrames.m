function [out, skippedDt, cfs] = findSkippedFrames(timings)
dt = diff(timings);
zeroTiming = [0 cumsum(dt)];
skipped=floor((dt+6)./prctile(dt,15))-1;%Calculate the numbers of skipped frames, 6ms as std
% Median changed into prctile because, sometimes there are alot of frames skipped.
% min is also an option but then you get really the left tail side of the normal
% distribution around the dt.And you want the mean.
%figure;
if min(skipped)<0
    error('something wrong with timing extraction')
end
ms=max(skipped);
plot(skipped);
out = find(skipped);
% out1 = find(skipped==1);
% out2 = find(skipped==2);
% out3 = find(skipped==3);
% out4 = find(skipped==4);
if ms>30
    warning([num2str(ms) 'consecutive frames where lost, interpolation for recovery might make no sense any more.'])
end
N = 1:ms;
tout=[];
for i=1:length(N)
    n=N(i);
    outx = find(skipped==n);
    tt=[];
    for j=1:n
        tt= [tt outx+j/(n+1)];
    end
    tout=[tout tt];
end
out10 = find(skipped>30);
if sum(out10)
    warning ('More than 10 consecutive frames are lost')
end
disp(['Correcting for: '  num2str(length(out)) ' dropped frames.'])
skippedDt = dt(out);
if sum((median(dt)+6)<(skippedDt/2))
   warning('More than one consecutive frame is skipped in this movie, this is not yet supported to recover automatically.')
   warning('Some implementation is done, but not double checked for validity. But seems OK for now.')
   %pause(3);
end
%cfs = sort([1:length(timings) out1+.5 out2+1/3 out2+2/3 out3+1/4 out3+2/4 out3+3/4 out4+1/5 out4+2/5 out4+3/5 out4+4/5]);%correction frame stream
cfs = sort([1:length(timings) tout]);%correction frame stream
