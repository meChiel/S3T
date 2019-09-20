% [A, fname, FileName, PathName, U, S, V, error]=loadTiff(fname,fastload,frameNumbers)
%fname = '../../data/Experiment 1_iglu spontaneous.tif';
%fname = '../../data/data_endoscope.tif';

function [A, fname, FileName, PathName, U, S, V, error,fps,msg]=loadTiff(fname,fastload,autocorrect,framenumbers)
% Set Fastload Default value
if nargin<2
   fastload=0;
end

% Set autocorrect Default value
if nargin<3
   autocorrect=1;
end
error=0;
U=nan;
S=nan;
V=nan;
%fname = '../../data/Experiment 5_SyG 10AP.tif';
global defaultDir
if nargin<1 || isempty(fname)
    if defaultDir~=0
    [FileName,PathName] = uigetfile('*.tif','Select the Tiff file',defaultDir);
    else
        [FileName,PathName] = uigetfile('*.tif','Select the Tiff file');
    end
    fname = [PathName FileName];
end
bkslsh = strfind(fname,'\');
if (isempty(bkslsh))
    bkslsh = strfind(fname,'/');
end
FileName = fname(bkslsh(end)+1:end);
PathName = fname(1:bkslsh(end));
disp(['Loading: ' fname]);

extra=1; % Provides some animation. Avg movie, avg signal, ...


if extra == 1
%imagesc(imread(fname, 1));
title('Loading ....')
drawnow();
end

if fastload % Fast Load
    if extra==1 
        title(['fastLoading .../'])%num2str(num_images)])
    end
    [A, U, S, V] = fastLoadTiff(fname);
    warning('Using fastload');
    extra=0; %Don't animate with fastload.
    num_images=size(A,3); % If eigs where calculated on a part of the movie, and the 

else % Normal Load
    info = imfinfo(fname);
    num_images = numel(info);
    A=zeros(info(1).Height,info(1).Width,num_images);
    
    for k = 1:num_images
        bbb=imread(fname,k);
        if (size(bbb,3))==1
            A(:,:,k) = bbb;
        else
            disp(['Unsupporte file format: ']);
            disp(['     ' fname] );
            error=1;
            A=nan;
        end
        if extra==1 && mod(k,100)==0
            imagesc(A(:,:,k));
            title(['Loading ' num2str(k) '/'  num2str(num_images)])
            drawnow();
        end
    end
    
    %%
    
    if isfield(info,'Software') %Andor IQ tiff files don't have a Software field, Andor Solis does
        %The script only works for Andor IQ generated tiff files.
        genSoft='Andor Solis';
    else
        genSoft='Andor IQ';        
    end
    
    if strcmp(genSoft,'Andor Solis')
        autocorrect=0;
        disp('Files acquired with Andor Solis can not be checked or autocorrected for skipped frames.');
        fps=nan;
        msg='Not an Andor IQ file and so can not be checked for skipped frames or fps extraction.';
    end
    %%
    % Auto correct for skipped frames
    if autocorrect
        timings=readExactAndorTifTime(fname);
        fps=1./median(diff(timings))*1000;
        [out, ~, cfs] = findSkippedFrames(timings);
        nSkippedFrames = length(out);
        A=frameswap(A,cfs);
        msg = [num2str(nSkippedFrames) ' missing frames fixed.'];
        if nargin<1
            disp(['fps: ' num2str(fps)]);
        end
    end

    
end

%% You want more?

if extra
    %disp('Extra stuff.')
    %% Calculate Average
    title('Loading Done');
    Avg= mean(A,3);
    %figure;
    subplot(4,4,[2:3,6:7])
    imagesc(squeeze(Avg))
    
    %% Look at average reponse:
    for k = 1:num_images
        ss(k) = mean(mean(A(:,:,k)-Avg));
    end
    %fig=figure;
    subplot(4,4,10);
    plot(ss);
   % axis off    
    savesubplot(4,4,10,[fname '_temp']);
    
    mpa = colormap(hot);
    imwrite((Avg-min(min(Avg)))*1.0/(max(max(Avg))-min(min(Avg)))*128,mpa,[fname '_avg.png']);
    %%
    %saveas(gca,[fname '2.png'])
end
