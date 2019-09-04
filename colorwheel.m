
function cc=colorwheel(alfa)
if nargin ==0
    alfa=0;
end
% Enter a number betweeen 0 and 360 to traverse colorwheel.
% 0 = Red, 120= Green 270 = Blue
%figure;

c=[alfa' alfa'*0+1 alfa'*0+1].*[1/360 .6 0.6];

R=c(:,1);
G=c(:,2);
B=c(:,3);
I(:,:,1)=R;
I(:,:,2)=G;
I(:,:,3)=B;
cc=hsv2rgb(c);
%image(permute(hsv2rgb(c),[1,3,2]))
end