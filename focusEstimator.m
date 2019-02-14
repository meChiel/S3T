a=rand(2000);
%%
figure;
x=[1,2,4,8,16,32,64];
ddd=[];
for j=1:length(x)
    dd=a;
    for i=1:x(j)
        dd=conv2(dd,fspecial('gauss',3),'same');
    end
    
vpdd=dd(64:end-64,64:end-64);
subplot(1,length(x),j);
    imagesc(vpdd)
ddd(j)=std(vpdd(:));
end
figure;plot(x,ddd)
ylabel('STD')
xlabel('# of blur operations')