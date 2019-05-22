function [tau1, amp, t0]=exp1fit(t,x)
% example : t=0:.1:10;
%           [tau1, amp] = exp1fit(t,10*exp(-t/.5))

tau1 = nan; amp = nan; t0=nan;
[amp, frame]=max(x);
tmax = t(frame);
y20=amp*0.1;
if y20<min(x)
    y20=min(x);
    disp('Used min amp i.s.o. 10%')
end
y80=amp*0.6;
if y80<min(x)
    y80=max(x);
    disp('Used max amp i.s.o. 60%')
end

%frame20 = find(x<=y20, 1,'first');
pointy80='last';%'first'
pointy20='firstAfter80';%'last';%'first';%'firstAfter80'


switch pointy80
    case 'first'
        frame80 = find(x<=y80, 1,'first');
    case 'last'
        frame80 = find(x>y80, 1,'last');
end
if isempty(frame80)
frame80=nan;
end
if ~isnan(frame80)
    switch pointy20
        case 'first'
            frame20 = find(x<=y20, 1,'first');
        case 'last'
            frame20 = find(x>y20, 1,'last');
        case 'firstAfter80'
            frame20 = frame80+find(x(frame80:end)<=y20(frame80:end), 1,'first');
    end
else
    frame20=nan;
end
if isempty(frame20)
frame20=nan;
end


try
    switch pointy20
        case 'first'
            t20=linInt(t(frame20-1),t(frame20),x(frame20-1),x(frame20),y20); %if first
        case 'last'
            t20=linInt(t(frame20),t(frame20+1),x(frame20),x(frame20+1),y20); %if last
        case 'firstAfter80'
            t20=linInt(t(frame20-1),t(frame20),x(frame20-1),x(frame20),y20); %if first
    end
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
    switch pointy80
        case 'first'
            t80=linInt(t(frame80-1),t(frame80),x(frame80-1),x(frame80),y80); %if first
        case 'last'
            t80=linInt(t(frame80),t(frame80+1),x(frame80),x(frame80+1),y80);
    end
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