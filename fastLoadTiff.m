function A = fastLoadTiff(pname);

%[fname, dirname]=uigetfile('*.tif');
[dirname, fname , ext] = fileparts(pname);
fname = [fname ext];
for evnI=1:16
    p = imread([dirname './eigs/' fname '_eigU' num2str(evnI) '.png']);
    U2(:,evnI) = ((double(p(:))-2^15)/length(p(:)));
    V2(:,evnI) = csvread([dirname './eigs/' fname '_eigV' num2str(evnI) '.csv']);
    S2(evnI,evnI) = csvread([dirname './eigs/' fname '_eigS' num2str(evnI) '.csv']);
end

A=U2*S2*V2';
A=reshape(A,[size(p,1),size(p,2),size(V2,1)]);
%%
% figure(1)
% for i=1:size(V1,1)
%     image(Y(:,:,i)/10);
%     pause(.01)
% end