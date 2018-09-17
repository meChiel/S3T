

[FileNames,PathName] = uigetfile('*.tif','Select the MATLAB code file','MultiSelect','on');


for i=1:length(FileNames)
    FileName=FileNames{i};
    fname = [PathName FileName];
    info = imfinfo(fname);
    num_images = numel(info);
    %A=zeros(info(1).Height,info(1).Width,num_images);
    subdirname=['JPG_' FileName];
    v = VideoWriter([fname '.mj2'],'Motion JPEG 2000');%'MPEG-4');
    open(v);

    mkdir([PathName '/' subdirname '/']);
    for k = 1:num_images
        A = imread(fname, k);   
        A=A/2^16;
        %A=double(A)/2^16*4;
        writeVideo(v,A)
        %A(:,:,k) = imread(fname, k);    
        %imwrite(A,[PathName '/' subdirname '/' FileName num2str(k) '.jpg'],'jpg','Comment','My JPEG file','BitDepth',8);%,'Mode','lossless');    
    end
    close(v);
end


%Create a VideoWriter object for a new uncompressed AVI file for RGB24 video.

%Open the file for writing.


%Write the image in A to the video file.

%writeVideo(v,A)


