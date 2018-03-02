% Eigen

mY=mean(Y,1);
mmY=mY-mean(mY);
dd=corr(Y',mmY');
dd=sum(bsxfun(@times,Y-mY,Y-mY),2);
figure;imagesc(reshape(dd,512,512))
Y2=bsxfun(@times,Y-mY,dd);
dd2=dd;
%%

Y2=bsxfun(@times,Y2,dd2);
subplot(3,1,1:2)
Y2=Y2/mean(abs(Y2));
mY2=mean(Y2);
mmY2=mY2-mean(mY2);
dd2=corr(Y2',mmY2');
imagesc(reshape(dd2,512,512))
subplot(3,1,3)
plot(mY2)

