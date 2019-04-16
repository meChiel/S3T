function [tau1, amp, t0]=exp1fit(t,x)
% example : t=0:.1:10;
%           [tau1, amp] = exp1fit(t,10*exp(-t/.5))

tau1 = nan; amp = nan; t0=nan;
[amp, frame]=max(x);
tmax = t(frame);
y20=amp*0.1;
if y20<min(x)
    y20=min(x);
    disp('Used min amp i.s.o. 20%')
end
y80=amp*0.6;
if y80<min(x)
    y80=max(x);
    disp('Used max amp i.s.o. 80%')
end

%frame20 = find(x<=y20, 1,'first');
frame20 = find(x<=y20, 1,'first');
if isempty(frame20)
frame20=nan;
end
%frame80 = find(x<y80, 1,'first');
frame80 = find(x>y80, 1,'last');
if isempty(frame80)
frame80=nan;
end
try
    t20=linInt(t(frame20-1),t(frame20),x(frame20-1),x(frame20),y20);
catch
    try 
        t20=t(frame20);
        warning('something is wrong with the interpolation');
    catch
        t20=nan;
    end
    % probaly frame20=1 and frame20-1 = 0 x(frame20-1)=> Subscript indices must either be real positive integers or logicals.
end
try
    t80=linInt(t(frame80),t(frame80+1),x(frame80),x(frame80+1),y80);
    
catch
    try
        t80=t(frame80);
        warning('something is wrong with the interpolation');
    catch
        t80=nan;
    end

    % probaly frame80=1 and frame80-1 = 0 x(frame80-1)=> Subscript indices must either be real positive integers or logicals.
end


% Calculate tau1
tau1 = (t20-t80)/log(y80/y20);

t0 = t80 + log(y80/amp)*tau1;


    function t3=linInt(t1,t2,y1,y2,y3)
        try
            t3 = t1 + ((y3-y1)/(y2-y1)*(t2-t1));
        catch
            t3=t1;%
            warning('something is wrong with the interpolation')
        end
    end

% Debug plot
% figure(5)
% plot(t,x)
% hold on;
% plot(t,amp*exp(-(t-t0)/tau1),'*')
% plot([t20 t20],[0 amp]);
% plot([t80 t80],[0 amp]);
% pause(.1)
%pause
end