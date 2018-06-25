function [tau1, amp, t0]=exp1fit(t,x)
% example : t=0:.1:10;
%           [tau1, amp] = exp1fit(t,10*exp(-t/.5))


[amp, frame]=max(x);
tmax = t(frame);
y20=amp*0.1;
if y20<min(x)
    y20=min(x);
    disp('Used min amp i.s.o. 20%')
end
y80=amp*0.6;

frame20 = find(x<=y20,1,'first');
frame80 = find(x<y80,1,'first');

t20=linInt(t(frame20-1),t(frame20),x(frame20-1),x(frame20),y20);
t80=linInt(t(frame80-1),t(frame80),x(frame80-1),x(frame80),y80);

% Calculate tau1
tau1 = (t20-t80)/log(y80/y20);

t0 = t80 + log(y80/amp)*tau1;


    function t3=linInt(t1,t2,y1,y2,y3)
        t3 = t1 + ((y3-y1)/(y2-y1)*(t2-t1));
    end

% Debug plot
%figure
% plot(t,x)
% hold on;
% plot(t,amp*exp(-(t-t0)/tau1),'*')
%pause
end