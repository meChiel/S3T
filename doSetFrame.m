function doSetFrame(d,r,e)
global slider U S V sizeA ax
t=floor(slider.Value/100*length(V)+1);
S2=ones(size(S));p1=2;p2=3;p3=4:4;
% subplot(1,2,1)
cf1=reshape(U(:,:)*S*V(t,:)',sizeA(1),sizeA(2)); % Reconstruct the entire curent frame.
cf1=cf1/5000;
cf1(cf1>1)=1;
cf1(cf1<0)=0; colormap('gray');
image(cf1*64);
axis equal
axis off
drawnow();
%subplot(1,2,2)

cf(:,:,1)=5e3*reshape(U(:,p1)*S2(p1,p1)*V(t,p1)',sizeA(1),sizeA(2)); %reconstruct the entire curent frame.
cf(:,:,2)=0.5+1e3*reshape(U(:,p2)*S2(p2,p2)*V(t,p2)',sizeA(1),sizeA(2)); %reconstruct the entire curent frame.
cf(:,:,3)=0.5+2e3*reshape(U(:,p3)*S2(p3,p3)*V(t,p3)',sizeA(1),sizeA(2)); %reconstruct the entire curent frame.
cf=cf;
cf(cf>1)=1;
cf(cf<0)=0;
image(cf*1,'parent',ax)
axis equal
axis off
drawnow();
end
