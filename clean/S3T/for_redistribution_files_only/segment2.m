function [synProb] = segment2(data,EVN,pathname)
%global data;
[U, S, V] = calcEigY(data);%source,event);%,handles);
%% mirror eigen for + stimulation
for ii=1:6
    nBlack = sum(U(:,ii)<mean(U(:,ii)));
    nWhite = sum(U(:,ii)>mean(U(:,ii)));
    if (nBlack<nWhite)
        thesign = -1;
    else
        thesign = 1;
    end
    U(:,ii) = thesign .*U(:,ii);
    V(:,ii) = thesign .*V(:,ii);
    %synProb = (-1*(sign(V(1,EVN)).*synProb));
end
   wx = size(data,2); wy = size(data,1);
synProb=reshape(U(:,EVN),[wy,wx]);
% EVN=1; %Eigen vector number


synapseBW = reshape(((U(:,EVN))>(std(U(:,EVN))*3)),wy,wx); % Assume first frame, the synapses do no peak. V(1,2) gives direction of 2nd U(:,2).
subplot(4,4,16);imagesc(synapseBW);colormap('gray');

[dirname, fname,ext] = fileparts(pathname);
if ~isdir([dirname './eigs/'])
    mkdir([dirname './eigs/'])
end
for evnI=1:16
    imwrite(reshape(uint16(U(:,evnI)*length(U)+2^15),[wy,wx]),[dirname './eigs/' fname '_eigU' num2str(evnI) '.png'],'BitDepth',16);
    csvwrite([dirname './eigs/' fname '_eigV' num2str(evnI) '.csv'], V(:,evnI));
    csvwrite([dirname './eigs/' fname '_eigS' num2str(evnI) '.csv'],S(evnI,evnI));
end

for evnI=1:16
    p = imread([dirname './eigs/' fname '_eigU' num2str(evnI) '.png']);
    U2(:,evnI) = ((double(p(:))-2^15)/length(p(:)));
    V2(:,evnI) = csvread([dirname './eigs/' fname '_eigV' num2str(evnI) '.csv']);
    S2(evnI,evnI) = csvread([dirname './eigs/' fname '_eigS' num2str(evnI) '.csv']);
end

%    pause();
%  s  = regionprops(synapseBW(:,:),'PixelList','PixelIdxList');

end
function rmvBkGrnd(source,event,handles)
subplot(4,4,16);
tophat(); warning('tophat ipo freqfilter')
% freqfilter2D();

setTvalue((std(synProb(:))*2));
threshold(TValue);
cleanBW();
%savesubplot(4,4,16,[pathname '_mask']);
imwrite(synapseBW,[pathname '_mask.png']);
subplot(4,4,4);
end
function setTvalue(tvalue)
TValue = tvalue;
thresTxt.String = num2str(TValue);
end
function threshold(source,event,handles)
TValue = str2double(thresTxt.String);
synapseBW = synProb > TValue;
pause(.5);
imagesc(synapseBW);
end

function cleanBW(source,event,handles)
warning('close sz 2 changed to 1')
synapseBW = imerode(synapseBW,strel('disk',1));
synapseBW = imdilate(synapseBW,strel('disk',1));
%warning('erode size hacked to 8')
pause(.5);
imagesc(synapseBW);
end

function [Ub, Sb, Vb] = calcEigY(data)
[U, S, V] = svd(reshape(data,[],size(data,3)),'econ');
Ub=U;
Sb=S;
Vb=V;
Sx=size(data,1);Sy=size(data,2);
imageEigen(U,S,V,Sx,Sy);
end

function imageEigen(U,S,V,Sx,Sy)
% Sx and Sy the x and y size of the image.
subplot(4,4,[2:3, 6:7]);
imagesc(reshape(U(:,2),Sx,Sy));colormap('gray');
subplot(4,4,10);
imagesc(reshape(U(:,1),Sx,Sy));colormap('gray');
title('eig 1')
subplot(4,4,11);
imagesc(reshape(U(:,2),Sx,Sy));colormap('gray');
title('eig 2')
subplot(4,4,14);
imagesc(reshape(U(:,3),Sx,Sy));colormap('gray');
title('eig 3')

subplot(4,4,4);
hold off;
plot(V(:,1));
title('eig 1')
subplot(4,4,8);
hold off;
plot(V(:,2));
title('eig 2')
subplot(4,4,12);
hold off;
plot(V(:,3));
title('eig 3')
end
