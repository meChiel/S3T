d=[];
for i=1:9
   eval( ['d(:,:,i)=' 'r03c11f14p0' num2str(i) '_ch3sk1fk1fl1;']);
end
d(:,:,10)=r03c11f14p10_ch3sk1fk1fl1;

%%
figure; imagesc(d(:,:,5));
%%
e=d(1600:end,1600:end,:);


%%
% duplicate 
% = 0.5µm in Z
ff=[];
for i=1:(10*5-1)
    ff(:,:,i)= e(:,:,floor(i/5)+1);
end
%%
BWF=[];
for i=1:10
    I= e(:,:,i)/16000;
    T = adaptthresh(I, 0.000000000099002);
    BWF(:,:,i)= imbinarize(I,T);
end

%%
BWF = adaptthresh(ff/1600,'neigh',[3 3 3],'Fore','bright');
%%
figure(1);
imagesc(double(BWF(:,:,5)))
