function tiffManipulator

%% Define buttons
global fname1 dir1 defaultDir dir2 fname2 fname3 dir3 trace freqEdt extractIndividchkBtn1


bgc = [0.95,0.95,0.96];
fgc = [0.6,0.6,0.6];



f4 = figure('Visible','on','name','Tiff Manipulator',...
    'Color',bgc,...
    'NumberTitle','off');

set(f4,'MenuBar', 'figure');
%set(f4,'MenuBar', 'none');
%set(f2, 'ToolBar', 'auto');
%set(f2, 'ToolBar', 'none');
javaFrame = get(f4,'JavaFrame');
javaFrame.setFigureIcon(javax.swing.ImageIcon('tiffmanipulatorIcon.png'));

openEdt1 = uicontrol('Style', 'edit', 'String', '...',...
    'Position', [20 360 150 30],...
    'Backgroundcolor',fgc,...
    'Callback', @doOpenFile1);

openEdt2 = uicontrol('Style', 'edit', 'String', '...',...
    'Position', [20 320 150 30],...
    'Backgroundcolor',fgc,...
    'Callback', @doOpenFile2);

thresholdField = uicontrol('Style', 'edit', 'String', '...',...
    'Position', [470 60 50 30],...
    'Backgroundcolor',fgc);
    



openBtn1 = uicontrol('Style', 'pushbutton', 'String', 'Open,',...
    'Position', [180 360 50 30],...
    'Backgroundcolor',fgc,...
    'Callback', @doOpenFile1);

openBtn2 = uicontrol('Style', 'pushbutton', 'String', 'Open,',...
    'Position', [180 320 50 30],...
    'Backgroundcolor',fgc,...
    'Callback', @doOpenFile2);

joinBtn = uicontrol('Style', 'pushbutton', 'String', 'Join,',...
    'Position', [250 340 50 30],...
    'Backgroundcolor',fgc,...
    'Callback', @doJoin);



extractBtn1 = uicontrol('Style', 'pushbutton', 'String', 'Extract',...
    'Position', [220 20 50 30],...
    'Backgroundcolor',fgc,...
    'Callback', @doMovieFrameExtractor);


extractIndividchkBtn1 = uicontrol('Style', 'checkbox', 'String', 'Create Individual files',...
    'Position', [370 20 150 30],...
    'Backgroundcolor',fgc);

aboveThresholdchkBtn1 = uicontrol('Style', 'checkbox', 'String', 'Threshold',...
    'Position', [370 60 100 30],...
    'Backgroundcolor',fgc);

openEdt3 = uicontrol('Style', 'edit', 'String', '...',...
    'Position', [20 160 150 30],...
    'Backgroundcolor',fgc,...
    'Callback', @doOpenFile3);

openBtn3 = uicontrol('Style', 'pushbutton', 'String', 'Open,',...
    'Position', [180 160 50 30],...
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
stimOnTimeTxt = uicontrol('Style', 'Text', 'String', '', ...
    'Position', [0 60 20 20],...
    'Backgroundcolor',bgc);


stimOffEdt = uicontrol('Style', 'edit', 'String', '0',...
    'Position', [20 40 50 20],...
    'Backgroundcolor',fgc,...
    'callback', @UpdatePlot);

stimOffTxt = uicontrol('Style', 'Text', 'String', 'Stimulation off Time: (frames)',...
    'Position', [70 40 150 20],...
    'Backgroundcolor',bgc);
stimOffTimeTxt = uicontrol('Style', 'Text', 'String', '', ...
    'Position', [0 40 20 20],...
    'Backgroundcolor',bgc);


freqEdt = uicontrol('Style', 'edit', 'String', '0',...
    'Position', [20 130 50 20],...
    'Backgroundcolor',fgc./fgc,...
    'callback', @UpdatePlot);

freqTxt = uicontrol('Style', 'Text', 'String', 'Freq. Time: (frames/sec)',...
    'Position', [70 130 150 20],...
    'Backgroundcolor',bgc-.0510);

freqEdt.String='33.33334';

stimOffsetEdt = uicontrol('Style', 'edit', 'String', '0',...
    'Position', [20 20 50 20],...
    'Backgroundcolor',fgc,...
    'callback', @UpdatePlot);

stimOffsetTxt = uicontrol('Style', 'Text', 'String', 'stimulation offset (frames)', ...
    'Position', [70 20 150 20],...
    'Backgroundcolor',bgc,...
    'callback', @UpdatePlot);

stimOffsetTimeTxt = uicontrol('Style', 'Text', 'String', '', ...
    'Position', [0 20 20 20],...
    'Backgroundcolor',bgc);

openSettingsBtn1 = uicontrol('Style', 'pushbutton', 'String', 'Load settings', ...
    'Position', [20 100 150 20],...
    'Backgroundcolor',bgc,...
    'callback', @loadSettings);
%%
 function loadSettings(g,f,h)
     [stimCfgFN.name, stimCfgFN.folder]=uigetfile('*.xml','Get stimulation xml file.','L:\beerse\all\Public\Exchange\Camille\20180704\CS01_GluSnFR_1');
     stimCfg=  xmlSettingsExtractor2(stimCfgFN);
     freq = str2num(freqEdt.String);
     stimRepeatsEdt.String=num2str(floor(stimCfg.pulseCount));
     stimOnEdt.String=num2str(floor(freq*stimCfg.pulseWidth/1000));
     stimOffEdt.String=num2str(floor(freq*(1/stimCfg.stimFreq-stimCfg.pulseWidth/1000)));
     stimOffsetEdt.String=num2str(floor(freq*stimCfg.delayTime/1000)); 
    
     stimOnTimeTxt.String = stimCfg.pulseWidth/1000;
     stimOffTimeTxt.String = (1/stimCfg.stimFreq-stimCfg.pulseWidth/1000);
     stimOffsetTimeTxt.String = stimCfg.delayTime/1000;
     

     pause(.5)
     UpdatePlot();
 end

    function doOpenFile1(g,f,h)
        [fname1 dir1]=uigetfile('*.tif','File 1');
        openEdt1.String=fname1 ;
        defaultDir=dir1;
    end
    function doOpenFile2(g,f,h)
        [fname2 dir2]=uigetfile('*.tif','File 2',defaultDir);
         openEdt2.String=fname2 ;
    end

   function doOpenFile3(g,f,h)
        [fname3 dir3]=uigetfile('*.tif','File 3',defaultDir);
         openEdt3.String=fname3 ;
   end

    function doJoin(g,f,h)
        joinBtn.String='busy...';
        pause(.1)
        tiffJoiner(dir1,fname1,fname2)
        joinBtn.String='done';
        
    end

    function doMovieFrameExtractor(g,f,h)
        d=extractIndividchkBtn1.Value;
        if d==0
            movieFrameExtractor([dir3 fname3]);
        else
            movieFrameExtractor2multipleMovies([dir3 fname3]);
        end
    end


    function movieFrameExtractor2multipleMovies(pathname1)
        info1 = imfinfo(pathname1);
        num_images1 = numel(info1);
        
        sx=info1(1).Width;
        sy=info1(1).Height;
        %  sz=sum(trace);
        nM=length(trace);
        if length(trace)~=num_images1
            warning('trace and video does not have he same amount of frames')
            nM=min(length(trace),num_images1);
        end
        sz=str2num(stimOnEdt.String);
        sOff=str2num(stimOffEdt.String);
        nRepeat=str2num(stimRepeatsEdt.String);
        for jj=1:nRepeat
            A=zeros(sx,sy,sz);
            nM=min(sz,num_images1-(jj-1)*(sz+sOff));
            
            for k = 1:nM
                A(:,:,k) = imread(pathname1, (jj-1)*(sz+sOff)+k);
            end
            
            
            %         L=0;
            %         for k = 1:nM
            %             if k==4800
            %                 disp('hey')
            %             end
            %             if mod(k,10)==0
            %              extractBtn1.String=num2str(k);
            %              pause(.01)
            %             end
            %             %disp(num2str(k))
            %             if (trace(k)==1)
            %                 L=L+1;
            %                 A(:,:,L) = imread(pathname1, k);
            %             end
            %         end
            %         A=A(:,:,1:L); %Clip the last part
            
            t = Tiff([pathname1(1:end-4) '_extract_P' num2str(jj) '.tif'],'w');
            t1 = Tiff(pathname1,'r');
            tagstruct.ImageLength = size(A,1)
            tagstruct.ImageWidth = size(A,2)
            tagstruct.Photometric = t1.getTag('Photometric');%Tiff.Photometric.MinIsBlack
            tagstruct.BitsPerSample = t1.getTag('BitsPerSample');
            tagstruct.SamplesPerPixel = t1.getTag('SamplesPerPixel');
            tagstruct.RowsPerStrip = t1.getTag('RowsPerStrip');
            tagstruct.PlanarConfiguration = t1.getTag('PlanarConfiguration');%Tiff.PlanarConfiguration.Chunky
            tagstruct.Software = 'S3T:tiffManipulator';
            
            for k = 1:size(A,3)
                if mod(k,10)==0
                    extractBtn1.String=num2str(k);
                    pause(.01)
                end
                t.setTag(tagstruct)
                
                t.write(uint16(squeeze(A(:,:,k))));
                %t.write(squeeze(A(:,:,k)));
                t.writeDirectory()
            end
            t.close();
            
        end
    end


    function movieFrameExtractor(pathname1)
        info1 = imfinfo(pathname1);
        num_images1 = numel(info1);
        
        sx=info1(1).Width;
        sy=info1(1).Height;
        sz=sum(trace);
        nM=length(trace);
        if length(trace)~=num_images1
            warning('trace and video does not have he same amount of frames')
            nM=min(length(trace),num_images1);
        end
        
        if (aboveThresholdchkBtn1.Value)
            nM=num_images1;
        end
        
        A=zeros(sx,sy,sz);
        L=0;
        
        
        for k = 1:nM
            if k==4800
                disp('hey')
            end
            if mod(k,10)==0 %Show some entertainment
             extractBtn1.String=num2str(k);
             pause(.01)
            end
            %disp(num2str(k))
            
            if (aboveThresholdchkBtn1.Value==0)
                if (trace(k)==1)
                    L=L+1;
                    A(:,:,L) = imread(pathname1, k);
                end
            else
                if(mean(mean(imread(pathname1, k)))>str2num(thresholdField.String));
                    L=L+1;
                    A(:,:,L) = imread(pathname1, k);
                end
            end
        end
        A=A(:,:,1:L); %Clip the last part
        
        t = Tiff([pathname1(1:end-4) '_extract.tif'],'w');
        t1 = Tiff(pathname1,'r');
        tagstruct.ImageLength = size(A,1)
        tagstruct.ImageWidth = size(A,2)
        tagstruct.Photometric = t1.getTag('Photometric');%Tiff.Photometric.MinIsBlack
        tagstruct.BitsPerSample = t1.getTag('BitsPerSample');
        tagstruct.SamplesPerPixel = t1.getTag('SamplesPerPixel');
        tagstruct.RowsPerStrip = t1.getTag('RowsPerStrip');
        tagstruct.PlanarConfiguration = t1.getTag('PlanarConfiguration');%Tiff.PlanarConfiguration.Chunky
        tagstruct.Software = 'S3T:tiffManipulator';
        
        
        for k = 1:size(A,3)
            if mod(k,10)==0 %Show some entertainment
             extractBtn1.String=num2str(k);
             pause(.01)
            end
            t.setTag(tagstruct)
            
            t.write(uint16(squeeze(A(:,:,k))));
            %t.write(squeeze(A(:,:,k)));
            t.writeDirectory()
        end
        t.close();
         extractBtn1.String='Done';
        
    end

    function UpdatePlot(g,f,h)
        
        repeats = str2num(stimRepeatsEdt.String);
        offTime = str2num(stimOffEdt.String);
        onTime = str2num(stimOnEdt.String);
        offsetTime =str2num(stimOffsetEdt.String);
        subplot(10,10,[63:70]);
        trace=[zeros(offsetTime,1); repmat([ones(onTime,1); zeros(offTime,1)],repeats,1)];
        plot(trace);
        xlabel('frames')
    end

end