function [A, U2, S2, V2,sizeA] = fastLoadTiff(pname,onlySVD, accuracy)
% Will load a tiff movie, but will not load the movie raw data, but it's SVD decomposition.
% The SVD decomposition should be available in the eigs subdir.
% Using first 16 eigenvectors it will reconstruct the movie.
%
% If the onlySVD flag is set, the movie reconstruction is not done. A=nan
% This can be usefull if reconstruction is not needed. 
% [~,U,S,V]=fastload(path,1)
%
% Accuracy allows to set a number between 1 and 16 to define the accuracy
% of the reconstruction.


if nargin <3
   accuracy=16;
end
if nargin <2
    onlySVD=0;
end


%[fname, dirname]=uigetfile('*.tif');
[dirname, fname , ext] = fileparts(pname);
fname = [fname ext];
for evnI=1:accuracy
    p = imread([dirname './eigs/' fname '_eigU' num2str(evnI) '.png']);
    U2(:,evnI) = ((double(p(:))-2^15)/length(p(:)));
    V2(:,evnI) = csvread([dirname './eigs/' fname '_eigV' num2str(evnI) '.csv']);
    S2(evnI,evnI) = csvread([dirname './eigs/' fname '_eigS' num2str(evnI) '.csv']);
    
end
sizeA=[size(p,1) size(p,2) size(V2,1)];
if onlySVD
A=nan;
else
A=U2*S2*V2';
A=reshape(A,[size(p,1),size(p,2),size(V2,1)]);
end
%%
% figure(1)
% for i=1:size(V1,1)
%     image(Y(:,:,i)/10);
%     pause(.01)
% end