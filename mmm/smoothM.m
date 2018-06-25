function r=smoothM(a,b)
for i=1:size(a,2)
r(:,i)=conv(a(:,i),ones(b,1),'same');
end