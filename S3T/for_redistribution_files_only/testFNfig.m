y=loadTiff();
%%
y2=y;
%%
ysub=(y(150:354,1:150,:));
%%
y=ysub;
%%
mY=mean(y,3);
%%
chY=bsxfun(@min,y,mY);

%%
figure; 
for i=1:1800
    image(chY(:,:,i)/100); 
    colormap 'gray'
    pause(.01)
end
%%