[FileNames,PathName] = uigetfile('*.tif','Select the MATLAB code file','MultiSelect','on');

for i=1:length(FileNames)
    FileName=FileNames{i};
    fname = [PathName FileName];
    info = imfinfo(fname);
    num_images = numel(info);
    %A=zeros(info(1).Height,info(1).Width,num_images);
    subdirname=['JPG_' FileName];
    mkdir([PathName '/' subdirname '/']);
    for k = 1:num_images
        A = imread(fname, k);   
        A=double(A)/2^16*4;
        %A(:,:,k) = imread(fname, k);    
        imwrite(A,[PathName '/' subdirname '/' FileName num2str(k) '.jpg'],'jpg','Comment','My JPEG file','BitDepth',8);%,'Mode','lossless');    
    end
end