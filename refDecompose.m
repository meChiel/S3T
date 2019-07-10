[A, fname, FileName, PathName, U, S, V, error]=loadTiff([],1);
Uref=U;
Vref=V;
Sref=S;

%%

[bcresponse, dff, BC, mstart]=findBaseFluorPoints(V(:,1)',2);
Vref=[BC' bcresponse'];

writetable(array2table(Vref),'Vref.csv')
%%

[A]=loadTiff([],0);
us1 = reshape(A,size(A,1)*size(A,2),size(A,3))/Vref(:,1:2)';

%%
figure;imagesc(reshape(U(:,1),512,512))
figure;imagesc(reshape(U(:,2),512,512))
%figure;imagesc(reshape(U(:,3),512,512))


%%

figure;plot(V(:,1))
figure;plot(V(:,2))
figure;plot(V(:,3))