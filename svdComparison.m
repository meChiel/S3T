
figure(20); 
subplot(2,3,1);
colormap('gray')
stdd=std(data,0,3);

imagesc(stdd);
axis equal, axis off;

subplot(2,3,2);
dd=double(locallapfilt(uint16(stdd),2.8,.8)); 
thh=mean(dd(:))+std(dd(:))*0;
%dd=edge(stdd,'log',0.8,2.8);
%h = fspecial('laplacian',0.9);
h = fspecial('log',32,2.2);
dd=-conv2(stdd,h,'valid');
thh=mean(dd(:))+std(dd(:))*6;
imagesc(dd);
axis equal, axis off;

subplot(2,3,3);
imagesc(thh<dd); colormap('gray')
axis equal, axis off;

subplot(2,3,4);
E1 = reshape(U(:,1),512,512);imagesc(E1);
E2 = reshape(U(:,2),512,512);imagesc(E2);
E3 = reshape(U(:,3),512,512);imagesc(E3);
axis equal, axis off;
%tt=std(U(:,2)*3)<E2;
tt1=E1;
tt2=E2;
tt3=E3;

dd1=-conv2(tt1,h,'valid');
dd2=-conv2(tt2,h,'valid');
dd3=-conv2(tt3,h,'valid');
thh1=mean(dd1(:))+std(dd1(:))*6;
thh2=mean(dd2(:))+std(dd2(:))*6;
thh3=mean(dd3(:))+std(dd3(:))*6;

subplot(2,3,5);imagesc(dd2);colormap('gray');axis equal, axis off;

subplot(2,3,6);imagesc(thh2<dd2);colormap('gray')
axis equal, axis off;

%% Diff mask
figure(21)
I=zeros(size(dd,1),size(dd,2),3);
I(:,:,1)=thh<dd;
I(:,:,2)=thh1<dd1;
subplot(2,3,1);imagesc(I);%colormap('gray')
subplot(2,3,2);
I(:,:,2)=thh2<dd2;
imagesc(I);
subplot(2,3,3);
I(:,:,2)=thh3<dd3;
imagesc(I);

