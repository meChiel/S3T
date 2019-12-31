function [a,b,c,p,q]=exp2fitM(x,y)

g1 = @(P,x) (P(1) + P(2) .* exp(P(3)* x));%+P(3).*exp(P(5)*x));
g = @(P,x) (P(1) + P(2) .* exp(P(4)* x)+P(3).*exp(P(5)*x));
%figure;plot(g(P,x));
ampest=max(y)-min(y);
rr=find(y<(min(y)+ampest*1/3),1,'first');
rr2=find(y<(min(y)+ampest*1/2),1,'first');
ss=find(y<(min(y)+ampest*2/3),1,'first');
ss2=find(y==min(y),1,'first');

x00=[x(rr) x(rr2) x(ss) x(ss2)];
y00=[y(rr) y(rr2) y(ss) y(ss2)];
%fun = @(beta,x)(norm(g(P,x)-y) );
pp00 = nlinfit(x00,y00,g1,[min(y),ampest,-1]);
warning('') % Clear last warning message
try
pp1 = nlinfit(x,y,g1,pp00);
    pp = nlinfit(x,y,g,[pp1(1) pp1(2) pp1(2)/10000 pp1(3) pp1(3)*100] );
catch
    pp = [pp00(1) pp00(2) 0 pp00(3) 0];
end
[warnMsg, warnId] = lastwarn;
if ~isempty(warnMsg)
    pp = [pp00(1) pp00(2) 0 pp00(3) 0];
end
a=pp(1);b=pp(2);c=pp(3);p=pp(4);q=pp(5);
end


function test()
% f=@(x) a + b * exp(p * x) + c * exp(q * x);

a=700; b=2; c=1; p=-1; q=-10;
x=0:.1:20;
y =a+ b * exp(p * x)+c * exp(q * x)+ .1*rand(size(x));
[a,b,c,p,q]=exp2fitM(x,y);
BC = real(a') + real(b)' .* exp(real(p)'* x)+real(c)'.*exp(real(q)'*x);
figure;plot(x,y,x,BC)
end
