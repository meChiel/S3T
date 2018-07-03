function tiffManipulator


global fname1 dir1 defaultDir dir2 fname2 trace


bgc = [0.95,0.95,0.96];
fgc = [0.6,0.6,0.6];



f4 = figure('Visible','on','name','Tiff Manipulator',...
    'Color',bgc,...
    'NumberTitle','off');

%set(f4,'MenuBar', 'figure');
set(f4,'MenuBar', 'none');
%set(f2, 'ToolBar', 'auto');
%set(f2, 'ToolBar', 'none');
javaFrame = get(f4,'JavaFrame');
javaFrame.setFigureIcon(javax.swing.ImageIcon('my_icon.png'));

openEdt1 = uicontrol('Style', 'edit', 'String', '...',...
    'Position', [20 260 150 30],...
    'Backgroundcolor',fgc,...
    'Callback', @doOpenFile1);

openEdt2 = uicontrol('Style', 'edit', 'String', '...',...
    'Position', [20 220 150 30],...
    'Backgroundcolor',fgc,...
    'Callback', @doOpenFile2);



openBtn1 = uicontrol('Style', 'pushbutton', 'String', 'Open,',...
    'Position', [180 260 50 30],...
    'Backgroundcolor',fgc,...
    'Callback', @doOpenFile1);

openBtn2 = uicontrol('Style', 'pushbutton', 'String', 'Open,',...
    'Position', [180 220 50 30],...
    'Backgroundcolor',fgc,...
    'Callback', @doOpenFile2);

joinBtn = uicontrol('Style', 'pushbutton', 'String', 'Join,',...
    'Position', [250 240 50 30],...
    'Backgroundcolor',fgc,...
    'Callback', @doJoin);



extractBtn1 = uicontrol('Style', 'pushbutton', 'String', 'Extract',...
    'Position', [220 20 50 30],...
    'Backgroundcolor',fgc,...
    'Callback', @doExtract);

openEdt3 = uicontrol('Style', 'edit', 'String', '...',...
    'Position', [20 120 150 30],...
    'Backgroundcolor',fgc,...
    'Callback', @doOpenFile3);

openBtn3 = uicontrol('Style', 'pushbutton', 'String', 'Open,',...
    'Position', [180 120 50 30],...
    'Backgroundcolor',fgc,...
    'Callback', @doOpenFile3);

stimRepeatsEdt = uicontrol('Style', 'edit', 'String', '1',...
    'Position', [20 80 50 20],...
    'Backgroundcolor',fgc,...
    'callback', @UpdatePlot);

stimRepeatsTxt = uicontrol('Style', 'text', 'String', 'stimulation Repeats ',...
    'Position', [70 80 150 20],...
    'Backgroundcolor',bgc);

stimOnEdt = uicontrol('Style', 'edit', 'String', '0',...
    'Position', [20 60 50 20],...
    'Backgroundcolor',fgc,...
    'callback', @UpdatePlot);

stimOnTxt = uicontrol('Style', 'text', 'String', 'Stimulation On Time:(frames)',...
    'Position', [70 60 150 20],...
    'Backgroundcolor',bgc);

stimOffEdt = uicontrol('Style', 'edit', 'String', '0',...
    'Position', [20 40 50 20],...
    'Backgroundcolor',fgc,...
    'callback', @UpdatePlot);

stimOffTxt = uicontrol('Style', 'Text', 'String', 'Stimulation off Time: (frames)',...
    'Position', [70 40 150 20],...
    'Backgroundcolor',bgc);


stimOffsetEdt = uicontrol('Style', 'edit', 'String', '0',...
    'Position', [20 20 50 20],...
    'Backgroundcolor',fgc,...
    'callback', @UpdatePlot);


stimOffsetTxt = uicontrol('Style', 'Text', 'String', 'stimulation offset (frames)', ...
    'Position', [70 20 150 20],...
    'Backgroundcolor',bgc,...
    'callback', @UpdatePlot);


    function doOpenFile1(g,f,h)
        [fname1 dir1]=uigetfile('*.tif','File 1');
        openEdt1.String=fname1 ;
        defaultDir=dir1;
    end
    function doOpenFile2(g,f,h)
        [fname2 dir2]=uigetfile('*.tif','File 2',defaultDir);
         openEdt2.String=fname2 ;
    end
    function doJoin(g,f,h)
        tiffJoiner(dir1,fname1,fname2)
    end

    function doMovieFrameExtractor(g,f,h)
        movieFrameExtractor([dirname3 fname3]);
    end


    function movieFrameExtractor(pathname1)
        info1 = imfinfo(pathname1);
        num_images1 = numel(info1);
        
        sx=size();
        sy=size();
        sz=sum(trace);
        A=zeros(sx,sy,sz);
        L=0;
        for k = 1:num_images1
            if (trace(k)==1)
                L=L+1;
                A(:,:,L) = imread(fname1, k);
            end
        end
        
        t = Tiff([pathname1 '_extract'],'w');
        t1 = Tiff(fname1,'r');
        tagstruct.ImageLength = size(A,1)
        tagstruct.ImageWidth = size(A,2)
        tagstruct.Photometric = t1.getTag('Photometric');%Tiff.Photometric.MinIsBlack
        tagstruct.BitsPerSample = t1.getTag('BitsPerSample');
        tagstruct.SamplesPerPixel = t1.getTag('SamplesPerPixel');
        tagstruct.RowsPerStrip = t1.getTag('RowsPerStrip');
        tagstruct.PlanarConfiguration = t1.getTag('PlanarConfiguration');%Tiff.PlanarConfiguration.Chunky
        tagstruct.Software = 'S3T:tiffManipulator';
        
        
        for k = 1:size(A,3)
            t.setTag(tagstruct)
            
            %t.write(uint16(squeeze(A(:,:,k))));
            t.write(squeeze(A(:,:,k)));
            t.writeDirectory()
        end
        t.close();
        
        
        
        

        
        
        
        
        
    end

    function UpdatePlot(g,f,h)
        
        repeats = str2num(stimRepeatsEdt.String);
        offTime = str2num(stimOffEdt.String);
        onTime = str2num(stimOnEdt.String);
        offsetTime =str2num(stimOffsetEdt.String);
        subplot(10,10,[93:100]);
        trace=[zeros(offsetTime,1); repmat([ones(onTime,1); zeros(offTime,1)],repeats,1)];
        plot(trace);
        xlabel('frames')
    end

end