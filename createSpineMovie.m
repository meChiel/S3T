% This creates a full 96 well plate of data.
% The well on the boundaries are not used, and not imaged and so do not 
% have data.
%close all;clear all
function createSpineMovie()

plateOnOff = [...
    0 0 0 0 0 0 0 0 0 0 0 0;
    0 1 1 1 1 1 1 1 1 1 1 0;
    0 1 1 1 1 1 1 1 1 1 1 0;
    0 1 1 1 1 1 1 1 1 1 1 0;
    0 1 1 1 1 1 1 1 1 1 1 0;
    0 1 1 1 1 1 1 1 1 1 1 0;
    0 1 1 1 1 1 1 1 1 1 1 0;
    0 0 0 0 0 0 0 0 0 0 0 0;
    ];

% plateOnOff = [...
%     0 0 0 0 0 0 0 0 0 0 0 0;
%     0 1 1 1 1 1 1 1 1 1 1 0;
%     0 0 0 0 0 0 0 0 0 0 0 0;
%     0 0 0 0 0 0 0 0 0 0 0 0;
%     0 0 0 0 0 0 0 0 0 0 0 0;
%     0 0 0 0 0 0 0 0 0 0 0 0;
%     0 0 0 0 0 0 0 0 0 0 0 0;
%     0 0 0 0 0 0 0 0 0 0 0 0;
%     ]; % Transpose to make the serialisation from left to right is done


%
% 
% plateOnOff = [...
%     0 0 0 0 0 0 0 0 0 0 0 0;
%     0 1 0 0 0 0 0 0 0 0 0 0;
%     0 0 0 0 0 0 0 0 0 0 0 0;
%     0 0 0 0 0 0 0 0 0 0 0 0;
%     0 0 0 0 0 0 0 0 0 0 0 0;
%     0 0 0 0 0 0 0 0 0 0 0 0;
%     0 0 0 0 0 0 0 0 0 0 0 0;
%     0 0 0 0 0 0 0 0 0 0 0 0;
%     ]; % Transpose to make the serialisation from left to right is done
    %later with rot90.
 
%%

plateNoise = [...
    0 0 0 0 0 0 0 0 0 0 0 0;
    0 0.0001 0.001 .01 .1 1 10 100 1000 10000 100000 0;
    0 0.0001 0.001 .01 .1 1 10 100 1000 10000 100000 0;
    0 0.0001 0.001 .01 .1 1 10 100 1000 10000 100000 0;
    0 0.0001 0.001 .01 .1 1 10 100 1000 10000 100000 0;
    0 0.0001 0.001 .01 .1 1 10 100 1000 10000 100000 0;
    0 0.0001 0.001 .01 .1 1 10 100 1000 10000 100000 0;
    0 0 0 0 0 0 0 0 0 0 0 0;
    ]*1+.000;

%% Plate Photo Bleaching Amplitude
platePBA = [...
    0, 0 	0 		0 		0 		0 		0 		0 		0 		0 		0 		0 ;		
    0, 0 	0 		0 		0 		0 		0 		0 		0 		0 		0 		0 ;		
    0, 0.01 0.01 	0.01 	0.01 	0.01 	0.01 	0.01 	0.01 	0.01 	0.01 	0 ;
    0, .1 	.1 		.1 		.1 		.1 		.1 		.1 		.1 		.1 		.1 		0 ;		
    0, 1 	1 		1 		1 		1 		1 		1 		1 		1 		1 		0 ;		
    0, 1 	1 		1 		1 		1 		1 		1 		1 		1 		1 		0 ;		
    0, 10 	10 		10 		10 		10 		10 		10 		10 		10 		10 		0 ;		
    0, 0 	0 		0 		0 		0 		0 		0 		0 		0 		0 		0 ;		
    ]*1.0+.00; %x0 disables photobleach

%% Simulated synapse amplitude
plateAmplitude = [...
    0, 0 	0 		0 		0 		0 		0 		0 		0 		0 		0 		0 ;		
    0, 1 	1 		1 		1 		1 		1 		1 		1 		1 		1 		0 ;		
    0, 1 	1 		1 		1 		1 		1 		1 		1 		1 		1 		0 ;		
    0, 1 	1 		1 		1 		1 		1 		1 		1 		1 		1 		0 ;		
    0, 1 	1.1 	1.2		1.3 	1.4 	1.5 	1.6 	1.70	1.8000	1 		0 ;		
    0, 1 	1.1 	1.2		1.3 	1.4 	1.5 	1.6 	1.70	1.8000	1 		0 ;		
    0, 1 	1.1 	1.2		1.3 	1.4 	1.5 	1.6 	1.70	1.8000	1 		0 ;		
    0, 0 	0 		0 		0 		0 		0 		0 		0 		0 		0 		0 ;		
    ]*0+500.0; %x0 disables 
%% Simulated synapse decay constant

plateDecay = 0.75./[...
    0, 0 	0 		0 		0 		0 		0 		0 		0 		0 		0 		0 ;		
    0, 1 	1.1 	1.2		1.3 	1.4 	1.5 	1.6 	1.70	1.8000	1 		0 ;		
    0, 1 	1.1 	1.2		1.3 	1.4 	1.5 	1.6 	1.70	1.8000	1 		0 ;		
    0, 1 	1.1 	1.2		1.3 	1.4 	1.5 	1.6 	1.70	1.8000	1 		0 ;		
    0, 1 	1 		1 		1 		1 		1 		1 		1 		1 		1 		0 ;		
    0, 1 	1 		1 		1 		1 		1 		1 		1 		1 		1 		0 ;		
    0, 1 	1 		1 		1 		1 		1 		1 		1 		1 		1 		0 ;		
    0, 0 	0 		0 		0 		0 		0 		0 		0 		0 		0 		0 ;		
    ]*0+0.75; %x0 disables 

%% Compound 1 conc.
plateComp1 = [...
    0, 0 	0 		0 		0 		0 		0 		0 		0 		0 		0 		0 ;		
    0, 0 	0.01 	0.1		1 		10 		100 	1000	10000	100000	0 		0 ;		
    0, 0 	0.01 	0.1		1 		10 		100 	1000	10000	100000	0 		0 ;		
    0, 0 	0.01 	0.1		1 		10 		100 	1000	10000	100000	0 		0 ;		
    0, 0 	0 		0 		0 		0 		0 		0 		0 		0 		0 		0 ;		
    0, 0 	0 		0 		0 		0 		0 		0 		0 		0 		0 		0 ;		
    0, 0 	0 		0 		0 		0 		0 		0 		0 		0 		0 		0 ;		
    0, 0 	0 		0 		0 		0 		0 		0 		0 		0 		0 		0 ;		
    ]*0+1.0; %x0 disables 


%% Compound 2 conc.
plateComp2 = [...
    0, 0 	0 		0 		0 		0 		0 		0 		0 		0 		0 		0 ;		
    0, 0 	0 		0 		0 		0 		0 		0 		0 		0 		0 		0 ;		
    0, 0 	0 		0 		0 		0 		0 		0 		0 		0 		0 		0 ;		
    0, 0 	0 		0 		0 		0 		0 		0 		0 		0 		0 		0 ;		
    0, 0 	0.01 	0.1		1 		10 		100 	1000	10000	100000	0 		0 ;		
    0, 0 	0.01 	0.1		1 		10 		100 	1000	10000	100000	0 		0 ;		
    0, 0 	0.01 	0.1		1 		10 		100 	1000	10000	100000	0 		0 ;		
    0, 0 	0 		0 		0 		0 		0 		0 		0 		0 		0 		0 ;		
    ]*0+1.0; %x0 disables 



%%

%%

numOfWells = sum(plateOnOff(:));

fs=30; % Frames per second
totalTime=17;% recording time in seconds

tic
storD=uigetdir([],'Select directory to store artificial data.');

%% The Andor software starts from the buttom left of the plate to go up
% Later, left to right. To get the same file numbering, we also simulate
% this. And start at the bottom left.

rPlateOnOff=rot90(plateOnOff,-1);
rPlatePBA=rot90(platePBA,-1);
rPlateNoise=rot90(plateNoise,-1);
rPlateAmplitude=rot90(plateAmplitude,-1);
rPlateDecay=rot90(plateDecay,-1);
idx = find(rPlateOnOff==1);
%% Start simulation:
Nspines = 20; % Active spines
Nspines2 = 20; % Non-active spines

fixedPos=ceil(412*rand(Nspines,2))+50;
fixedPos2=ceil(512*rand(Nspines2,2));
for jj=0:(numOfWells-1)
    Amp = rPlateAmplitude(idx(jj+1));
    Decay = rPlateDecay(idx(jj+1));
    nSpikes = 3;
    freqSpikes = 0.2;
    pos=ceil(512*rand(Nspines,2)); % Spine positions
    pos=ceil(412*rand(Nspines,2))+50; % Spine positions not at border
    pos=fixedPos;
    pba=rPlatePBA(idx(jj+1));  disp(['Photo Bleaching amplitude: ' num2str(pba)]);
    noiseLevel = rPlateNoise(idx(jj+1)); disp(['Noise:' num2str(noiseLevel)]);
    PB=pba * ones(Nspines,1); % Photo Bleach
    PB2=pba * ones(Nspines,1); % Photo Bleach
    
    bgF=500*ones(Nspines,1); % Background Fluorescence active spines
    bgF2=500*ones(Nspines2,1); % Background Fluorescence non-active spines
    pos2=ceil(512*rand(Nspines2,2)); % Postion of non-active spines
    pos2=fixedPos2;
    
    spiketimes = 2.2*ones(Nspines,1)+0.00*randn(Nspines,1); % SpikeTime + random delay
    spiketimes2 = 7.2*ones(Nspines,1)+0.00*randn(Nspines,1); % SpikeTime + random delay
    spiketimes3 = 12.2*ones(Nspines,1)+0.00*randn(Nspines,1); % SpikeTime + random delay
    %spiketimes3 = 0*ones(Nspines,1)+0.00*randn(Nspines,1); % SpikeTime + random delay
    
    spikeAmplitude = Amp*ones(Nspines,1); % Amplitude for all synapses of spike 1
    spikeAmplitude2 = Amp*ones(Nspines,1); % Amplitude for all synapses of spike 2
    spikeAmplitude3 = Amp*3*ones(Nspines,1); % Amplitude for all synapses of spike 3
    decaytime= Decay*ones(Nspines,1)-.000*rand(Nspines,1); % Almost all the same decay time
    decaytime2= 0.96*ones(Nspines,1)-.000*rand(Nspines,1); % Photo - bleach decay time.
    %dy=-0.05*y=> exp(-0.5*t/pi)
    backSeed=rand(516,516);
    
    [X,Y]=meshgrid(-20:20,-20:20);
    spineshape=(X.*X+Y.*Y)<10; % Binary shaped synapses
    spineshape=exp(-(X.*X+Y.*Y)/18); % Gaussian shaped synapse
    % spineshape=...
    %     [0 0 1 0 0;
    %      0 1 1 1 0;
    %      1 1 1 1 1;
    %      0 1 1 1 0;
    %      0 0 1 0 0];
    
    
    conn=(size(spineshape)-1);
    sX=(512+conn(1));
    sY=(512+conn(2));
    [X,Y]=meshgrid(1:sX,1:sY);
    sc=1;
    background=.000005*(((X.*X*0.01*sc-200).*(X*sc-200)+Y*sc.*X.*Y*sc));%+(X*sc-20).*Y));
    background(1:512,1:512)=background(1:512,1:512)+double(imread('background.bmp'))*500;
%%% Creates a plateau in the image
    %background= 500*double(background>100)+background;
    %background=.000000*(((X.*X*0.01*sc-200).*(X*sc-200)+Y*sc.*X.*Y*sc));%+(X*sc-20).*Y));
    
    tFrame=1/fs;
    totFrames=floor(totalTime/tFrame);
    images=zeros(512,512);
    image2=zeros(sX,sY,totFrames);
    image3=zeros(512,512,totFrames);
    for i=1:length(pos)
        images(pos(i,1),pos(i,2)) = bgF(i)+PB(i);
    end
    for f=1:totFrames
        for i=1:length(pos2) % For non active spines
            images(pos2(i,1),pos2(i,2)) = (PB2(i))+(bgF2(i));
            PB2(i)= PB2(i)*decaytime2(i);
        end
        for i=1:length(pos) % For active spines
            %images(pos(i,1),pos(i,2))=images(pos(i,1),pos(i,2))+bgF(i);
            images(pos(i,1),pos(i,2)) = images(pos(i,1),pos(i,2))+spikeAmplitude(i)*(tFrame/2>abs(f*tFrame-spiketimes(i))); %First spike
            images(pos(i,1),pos(i,2)) = images(pos(i,1),pos(i,2))+spikeAmplitude2(i)*(tFrame/2>abs(f*tFrame-spiketimes2(i))); %Second spike
            images(pos(i,1),pos(i,2)) = images(pos(i,1),pos(i,2))+spikeAmplitude3(i)*(tFrame/2>abs(f*tFrame-spiketimes3(i))); %Thirth spike
            images(pos(i,1),pos(i,2)) = (bgF(i)+(images(pos(i,1),pos(i,2)) - bgF(i) - PB(i))*decaytime(i))+PB(i); % Background fluoresence + photobleaching
            PB(i)= PB(i)*decaytime2(i);
        end
        image2(:,:,f) = conv2(spineshape,images);     
        image2(:,:,f) = image2(:,:,f)+background+1*pba*background*PB(i); % PB(i) is buffer going exp from 1 to 0 ;
        image2(:,:,f) = image2(:,:,f).*(1+noiseLevel/10*randn(size(image2(:,:,f)))/pi);
        image3(:,:,f) = image2(1:512,1:512,f);
    end
%    figure(1);colormap gray;
%     
    hold off
     if 0
         for f=1:totFrames
        image(image3(:,:,f)*.10);
        title(['creating movie: ' num2str(jj) ' frame:' num2str(f) '/' num2str(totFrames)]);
        pause(.0285);
     end
%     
     end
    %%
    %figure(2)
    hold off
    % Plot the response of the first synapse centre
    plot((1:totFrames)*tFrame, squeeze(image2(pos(1,1)+conn(1)/2,pos(1,2)+conn(2)/2,:)));
    hold on;
    % Decay time:
   % t=0:0.032:8;plot(t,5*exp(-0.5*(t-1)*pi))
    
    pause(0.5);
    %% Export the movie:
    %image2=conv2(images,spineshape);
    ID = num2str(10000+jj);
   % mkdir(['E:/simulated_exp' ] );
    %mkdir(['E:/simulated_exp' ID(2:end) '/GT'] );
    
  if(~isdir ([storD '/GT\']))
    mkdir([storD '/GT'] );
  end
    ffname=[storD '/NS_120181002_1046_e' ID(2:end)  '.tif'];
   % imwrite(uint16(image3(:,:,1)/1024),ffname)
    
   try
      imwrite(uint16(image3(:,:,1)*4),ffname)
   catch
       pause(1);
       disp ('trying imwrite again');
       imwrite(uint16(image3(:,:,1)*4),ffname)
   end
   for i=2:totFrames
       try
          imwrite(uint16(image3(:,:,i)*4),ffname,'WriteMode','append')
       catch
           pause(0.01);
           disp('trying imwrite append again');
           try
               pause(1);
               imwrite(uint16(image3(:,:,i)*4),ffname,'WriteMode','append');
           catch(e)
               try
                   pause(1);
                   imwrite(uint16(image3(:,:,i)*4),ffname,'WriteMode','append');
               catch(e)
                   try
                       pause(1);
                       imwrite(uint16(image3(:,:,i)*4),ffname,'WriteMode','append');
                   catch(e)
                       error('tried 4 times but could not write to file')
                   end
               end
               
           end
       end
    
    
%        image(image2(:,:,i)/20);        
        %imwrite(image2(:,:,i)/1024, ['E:/simulated_e' ID(2:end) '/frame' num2str(i) '.png'],'BitDepth',16);
 %       pause(.01)
    end
    %save(['E:/simulated_e' ID(2:end) '/GT/groundTruth' ID(2:end) '.mat'])
    clear image2 image3;
    save([storD '/GT/groundTruth' ID(2:end) '.mat'])
    
end
toc
%% Convert png seqs to tif
%!"C:\Users\SA-PRD-Synapse\Documents\ij150-win-jre6\ImageJ.exe" --headless --console -macro ./png2tif.ijm 
%!%systemdrive%%homepath%\Documents\ij150-win-jre6\ImageJ.exe" --headless --console -macro ./png2tif.ijm 
%'folder=../folder1 parameters=a.properties output=../samples/Output'

%% Create Meta data files
%csvwrite([storD '\PlateLayout_PBA.csv'],platePBA);
%csvwrite([storD '\PlateLayout_Noise.csv'],plateNoise);
csvwrite([storD '\PlateLayout_On.csv'],plateOnOff);
csvwrite([storD '\PlateLayout_Compound1.csv'],plateComp1);
csvwrite([storD '\PlateLayout_Compound2.csv'],plateComp2);

%% Create Andor Meta data file.

andorText = ['Well ' num2str(numOfWells) '\r\n-----------\r\n\r\n Repeat - Well\r\n']; 

%layout = [1:12;13:24;25:36;37:48;49:60;61:72;73:84;85:96]';
%fliplr
andorPlateLayout = ([1:12;13:24;25:36;37:48;49:60;61:72;73:84;85:96]');
idx = find(rPlateOnOff==1);

for i=1:numOfWells
    andorText = [andorText '\t Well ' num2str(andorPlateLayout ((idx(i)))) '\r\n \t\t XY 1- \r\n'];
end

   andorText = [andorText '\r\n \r\nCamera Exposure Time (s) - ' num2str(1/fs) ];
fid = fopen([storD '\NS_120181002_1046.txt'],'w');
fprintf(fid,andorText,'%s');
fclose(fid);

%% Create Analysis file



anTxt=[...
'<Name>Stimulation Frequency (Hz)</Name>\n'...
'<Val>0.2</Val>\n'...
'\n'...
'<Name>Delay Time (ms)</Name>\n'...
'<Val>1000</Val>\n'...
'\n'...
'<Name>Pulse count</Name>\n'...
'<Val>2</Val>\n'...
'\n'...
'<Name>Partial Stimulation Frequency (Hz)</Name>\n'...
'<Val>0</Val>\n'...
'\n'...
'<Name>Partial Delay Time (ms)</Name>\n'...
'<Val>0</Val>\n'...
'\n'...
'<Name>Partial Pulse count</Name>\n'...
'<Val>1</Val>\n'...
'\n'...
'<Name>Frame Selection</Name>\n'...
'<Val>[1:end]</Val>\n'...
'\n'...
'<Name>Mask Creation Time Projection</Name>\n'...
'<Val>SVD</Val>\n'...
'\n'...
'<Name>Eigenvalue Number</Name>\n'...
'<Val>2</Val>\n'...
'\n'...
'<Name>Reuse Mask</Name>\n'...
'<Val>0</Val>\n'...
'\n'...
'<Name>Reload Movie</Name>\n'...
'<Val>1</Val>\n'...
'\n'...
'<Name>Fast Load</Name>\n'...
'<Val>0</Val>\n'...
'\n'...
'<Name>Photo Bleaching</Name>\n'...
'<Val>linInt</Val>\n'...
'\n'...
'<Name>Write SVD</Name>\n'...
'<Val>1</Val>\n'...
'\n'...
'<Name>duty Cycle (frames)</Name>\n'...
'<Val>0</Val>\n'...
'\n'...
'<Name>Partial Duty Cycle (frames)</Name>\n'...
'<Val>0</Val>\n'...
'\n'...
'<Name>Skip Movie</Name>\n'...
'<Val>0</Val>\n'...
'\n'...
'<Name>Cell Body Type</Name>\n'...
'<Val>0</Val>\n'...
'\n'...
'<Name>Analysis Type</Name>\n'...
'<Val>0</Val>\n'...
'\n\n'...
'<Name>Number Average Samples</Name>\n\n'...
'<Val></Val>\n'...
...
...%'Camera Exposure Time (s) - 0.03030\n'...
]

   analysisText = [anTxt '\r\n \r\nCamera Exposure Time (s) - ' num2str(1/fs) ];
fid = fopen([storD '\1AP_Analysis.xml'],'w');
fprintf(fid,analysisText,'%s');
fclose(fid);

    
