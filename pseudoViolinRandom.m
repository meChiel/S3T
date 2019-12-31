function [r, ry]=pseudoViolinRandom(y,m,hx)
    m=size(y,2);
if nargin>2
    hx=hx;
else
    hx=10;
end
r=[];
for j=1:m
    n=size(y,1);
    [nx, cc]=hist(y(:,j),hx);
    csnx=cumsum(nx);
    dx=cc(2)-cc(1);
    cc=cc(:)';
    kk=(y(:,j)>[-inf cc(1:end-1)+dx/2]) & (y(:,j)<=[cc(1:end-1)+dx/2 inf]);
    
    [ppx, ppy] = find(kk');
    pppx = ppx;
    %pppx(pppx==0)=1;
    
    [sy, syi] = sort(y);
    violMod = nx(pppx);
    
    syi2=(syi-[-1 csnx])';
    syi3=syi2;
    syi3(syi2<=0)=inf;
    tt=min(syi3);
    
    
    ugn=pppx*0; % Unique in Group Number
    for i=1:max(pppx) % For all groups
        ct=cumsum(pppx==i); % Cumulatively Count the population in that group
        ugn(pppx==i)=ct(pppx==i)-max(ct)/2; % copy the cum counts of that group in the right place in ugn
        %-max/2, to make tree symmetric
    end
    
    if nargin >1
        % rt = repmat(mod((1:n)*6.3,5)'/10.*violMod',1,m);
        % r = repmat(mod(tt,violMod)'/10',1,m);
        rt = ugn'/10;
        
    else
        %r = mod((1:n)*6.3,5)'/10.*violMod';
        %rt = mod(tt,violMod)'/10';
        rt = ugn'/10;
    end
    r(:,j)=rt;
end
ry=cc(pppx);
ry=ry(:);
fff=gcf();


% figure(6)
% plot(0*y+r,ry+rand(size(ry,1),1)*.000002,'.');
% plot(y,ry,'.');
% figure(fff);
end

function test
%% Test PVR
% Check of geen gaten of dubbele punten
% Werkt nog niet voor hx argument en random punten. Raar?
figure();
y=[1:100 50:60 50:60 20+0*(50:60)]';
y=[1:100 50:60 50:60 20+0*(50:60)]';
%y=[rand(1,100)*200 50:60 50:60 20+0*(50:60)]';
m=1;
hx=[50:10:100];
%[r, ry]=pseudoViolinRandom(y,m,hx);
[r, ry]=pseudoViolinRandom(y,m);
plot(0*y+r,ry+rand(size(ry,1),1)*1,'.')
hold on;
plot(y,ry,'.')
legend('Christmas tree?','stair case Line?')

%%
end