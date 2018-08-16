%defaultDir = './';
function processSingleCoverslipExperiment()
global defaultDir ;
fps = 32.808 ;
                [C10dirname] = uigetdir(defaultDir,'Select control 10AP dir:');
                defaultDir =  [C10dirname '\..'];
                [C1dirname]  = uigetdir(defaultDir,'Select control 1AP dir:');
                defaultDir =  [C1dirname '\..'];
                 [M3dirname]  = uigetdir(defaultDir,'Select 3min. Compound 1AP dir:');
                defaultDir =  [M3dirname '\..'];
                [M5dirname]  = uigetdir(defaultDir,'Select 5min. Compound 1AP dir:');
                defaultDir =  [M5dirname '\..'];
                [M10dirname] = uigetdir(defaultDir,'Select 10min. Compound 1AP dir:');
                defaultDir =  [M10dirname '\..'];
                 [M15dirname] = uigetdir(defaultDir,'Select 15min. Compound 1AP dir:');
                defaultDir =  [M15dirname '\..'];
                [M20dirname] = uigetdir(defaultDir,'Select 20min. Compound 1AP dir:');
                defaultDir =  [M20dirname '\..'];
                 [M30dirname] = uigetdir(defaultDir,'Select 30min. Compound 1AP dir:');
                defaultDir =  [M30dirname '\..'];
                
                [M60dirname] = uigetdir(defaultDir,'Select 60min. Compound 1AP dir:');
                defaultDir =  [M60dirname '\..'];
                
                
                
                
                C10expnm{1} = dir ([C10dirname '\*.tif']);
                C1expnm{1} = dir ([C1dirname '\*.tif']);
                M3expnm{1} = dir ([M3dirname '\*.tif']);
                M5expnm{1} = dir ([M5dirname '\*.tif']);
                M10expnm{1} = dir ([M10dirname '\*.tif']);
                M15expnm{1} = dir ([M15dirname '\*.tif']);
                M20expnm{1} = dir ([M20dirname '\*.tif']);
                M30expnm{1} = dir ([M30dirname '\*.tif']);
                
                M60expnm{1} = dir ([M60dirname '\*.tif']);
               %% 
                pathname = [C10expnm{1}.folder '\' C10expnm{1}.name];
                A=loadTiff(pathname);
                
                EVN=2;
                stimFreq = 0.25;%Hz
                OnOffset=50;
                NOS = 1;        % Number of Stimuli
                

                processMovie(A,pathname,0,fps,EVN,stimFreq,OnOffset,NOS);
                pathname = [C1expnm{1}.folder '\' C1expnm{1}.name];
                A=loadTiff(pathname);
                
                EVN=2;
                stimFreq = 0.125;%Hz
                OnOffset=150;
                NOS = 4;        % Number of Stimuli

                processMovie(A,pathname,0,fps,EVN,stimFreq,OnOffset,NOS);
                
                pathname = [M3expnm{1}.folder '\' M3expnm{1}.name];
                processMovie(loadTiff(pathname),pathname,0,fps,EVN,stimFreq,OnOffset,NOS);
                pathname = [M5expnm{1}.folder '\' M5expnm{1}.name];
                processMovie(loadTiff(pathname),pathname,0,fps,EVN,stimFreq,OnOffset,NOS);
                pathname = [M10expnm{1}.folder '\' M10expnm{1}.name];
                processMovie(loadTiff(pathname),pathname,0,fps,EVN,stimFreq,OnOffset,NOS);
                pathname = [M15expnm{1}.folder '\' M15expnm{1}.name];
                processMovie(loadTiff(pathname),pathname,0,fps,EVN,stimFreq,OnOffset,NOS);
                pathname = [M20expnm{1}.folder '\' M20expnm{1}.name];
                processMovie(loadTiff(pathname),pathname,0,fps,EVN,stimFreq,OnOffset,NOS);
                pathname = [M30expnm{1}.folder '\' M30expnm{1}.name];
                processMovie(loadTiff(pathname),pathname,0,fps,EVN,stimFreq,OnOffset,NOS);
                
                pathname = [M60expnm{1}.folder '\' M60expnm{1}.name];
                processMovie(loadTiff(pathname),pathname,0,fps,EVN,stimFreq,OnOffset,NOS);
                
                
      
end