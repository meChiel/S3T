function [out, skippedDt, cfs] = findSkippedFrames(timings)
dt = diff(timings);
zeroTiming = [0 cumsum(dt)];
skipped=(median(dt)+6)<dt;
%figure;
plot(skipped);
out = find(skipped);
disp(['Correcting for: '  num2str(length(out)) ' dropped frames.'])
skippedDt = dt(out);
if sum((median(dt)+6)<(skippedDt/2))
    error('more than one frame is skipped in this movie, this is not yet supported to recover automatically.')
end

cfs = sort([1:length(timings) out+.5]);%correction frame stream
