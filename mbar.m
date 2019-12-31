function f2=mbar(xx,yy,base,c)
p=[];
for i=1:length(xx)
x = base+0+yy(i)*[0 1 1 0];
y = 0+xx(i)+(xx(2)-xx(1))*[0 0 1 1];
p=[ p; x(:) y(:)];
end
f=reshape(1:length(xx)*4,4,[]);

f2=patch('Faces',f','Vertices',p);
%f2.LineStyle='none';
if nargin>3
f2.FaceColor=c;
f2.EdgeColor=c;
end
hold on
twoSided=1;
if twoSided
    p2=p;
    p2(:,1)=base-(p2(:,1)-base);
    f3=patch('Faces',f','Vertices',p2);
    if nargin>3
        f3.FaceColor=c;
        f3.EdgeColor=c;
    end
end




end
%%
function test()
%% Function Test
figure
mbar(1:100,1:100,50,[0 0 1]);
hold on
mbar((1:100)/3,1:100,150,[1 0 0]);

axis([0 200 0 200]);
end