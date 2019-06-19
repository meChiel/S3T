 function [synRegio, synProb] = loadMask(maskFilePath)
        %ok=0;
        
        if (nargin==0)
            if exist('defaultDir','var')
                [maskFilename, maskDir] = uigetfile('*.png',['Select mask:'],[defaultDir '\']);
            else
                [maskFilename, maskDir] = uigetfile('*.png',['Select mask:']);
            end
            maskFilePath = [maskDir '\' maskFilename];
        else
            maskFilePath;
        end
        mask = imread(maskFilePath);
        synProb = double(mask*0);
        [wy, wx] = size(mask);
        synRegio2=[];
        sortedValues = sort(mask(:));
        [lowestNZValueID] = find(0<sortedValues,1);
        lowestNZValue = sortedValues(lowestNZValueID);
        maxValue = max(mask(:));
        ids = maxValue:-1:lowestNZValue;
        imagesc(mask);
        for i=1:length(ids)
            %synRegio{i}.PixelIdxList = find(mask==ids(i));
            synRegio2{i}= find(mask==ids(i));
        end
        for i=1:length(ids)
             [synRegioPixelListX{i}, synRegioPixelListY{i}] = ind2sub([wy,wx],synRegio2{i});
             synRegioPixelList{i} = [synRegioPixelListX{i}, synRegioPixelListY{i}];
        end
        
        if isempty(synRegio2)
            synRegio=[];
        else
           %synRegio3=cell2struct({synRegio2;   synRegioPixelList},{'PixelIdxList','PixelList'},1);
           synRegio3=struct('PixelIdxList',synRegio2,'PixelList',synRegioPixelList);
           synRegio=synRegio3;
        end
            
        %setMask();
        %ok=1;
    end