function r=smoothM(a,b)
if nargin<2
    b=5;
end
for i=1:size(a,2)
    r(:,i)=conv(a(:,i),ones(b,1),'same');
end
end