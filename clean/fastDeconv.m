psfinit=fspecial('disk',15);
 [J P] = deconvblind(reshape(U(:,3),512,512),psfinit);
 %% does not work
 psfinit=fspecial('disk',5);
 [J] = deconvlucy(reshape(U(:,3),512,512),psfinit);
 