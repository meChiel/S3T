% This creates a full 96 well plate of data.
% The well on teh boundaries are not used, and not iamged and so do not 
% have data.


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
%%
% 
% plateOnOff = [...
%     0 0 0 0 0 0 0 0 0 0 0 0;
%     0 0 1 1 1 1 1 1 1 1 1 0;
%     0 0 0 0 0 0 0 0 0 0 0 0;
%     0 0 0 0 0 0 0 0 0 0 0 0;
%     0 0 0 0 0 0 0 0 0 0 0 0;
%     0 0 0 0 0 0 0 0 0 0 0 0;
%     0 0 0 0 0 0 0 0 0 0 0 0;
%     0 0 0 0 0 0 0 0 0 0 0 0;
%     ]; % Transpose to make the serialisation from left to right is done
%     later with rot90.
 
%%

plateNoise = [...
    0 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0.01 .1 .1 .1 1 1 1 10 10 0;
    0 0 0.01 .1 .1 .1 1 1 1 10 10 0;
    0 0 0.01 .1 .1 .1 1 1 1 10 10 0;
    0 0 0.01 .1 .1 .1 1 1 1 10 10 0;
    0 0 0.01 .1 .1 .1 1 1 1 10 10 0;
    0 0 0.01 .1 .1 .1 1 1 1 10 10 0;
    0 0 0 0 0 0 0 0 0 0 0 0;
    ];

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
    ];


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
idx = find(rPlateOnOff==1);
%% Start simulation:

for jj=0:(numOfWells-1)
    nSpikes = 3;
    freqSpikes = 0.2;
    Nspines = 20; % Active spines
    Nspines2 = 20; % Non-active spines
    pos=ceil(512*rand(Nspines,2)); % Spine positions
    pba=rPlatePBA(idx(jj+1));  disp(['Photo Bleaching amplitude: ' num2str(pba)]);
    noiseLevel = rPlateNoise(idx(jj+1)); disp(['Noise:' num2str(noiseLevel)]);
    PB=ones(Nspines,1); % Photo Bleach
    PB2=ones(Nspines,1); % Photo Bleach
    
    bgF=100*ones(Nspines,1); % Background Fluorescence active spines
    bgF2=100*ones(Nspines2,1); % Background Fluorescence non-active spines
    pos2=ceil(512*rand(Nspines2,2)); % Postion of non-active spines
    spiketimes = 1.2*ones(Nspines,1)+0.03*randn(Nspines,1); % SpikeTime + random delay
    spiketimes2 = 6.2*ones(Nspines,1)+0.03*randn(Nspines,1); % SpikeTime + random delay
    spiketimes3 = 11.2*ones(Nspines,1)+0.03*randn(Nspines,1); % SpikeTime + random delay
    %spiketimes3 = 0*ones(Nspines,1)+0.00*randn(Nspines,1); % SpikeTime + random delay
    
    
    
    spikeAmplitude = 500*ones(Nspines,1); % The same amplitude
    spikeAmplitude2 = 500*ones(Nspines,1); % The same amplitude
    spikeAmplitude3 = 1500*ones(Nspines,1); % The same amplitude
    decaytime= 0.75*ones(Nspines,1)-.003*rand(Nspines,1); % Almost all the same decay time
    decaytime2= 0.96*ones(Nspines,1)-.003*rand(Nspines,1); % Photo - bleach decay time.
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
            images(pos(i,1),pos(i,2)) = images(pos(i,1),pos(i,2))+spikeAmplitude(i)*(tFrame/2>abs(f*tFrame-spiketimes(i)));
            images(pos(i,1),pos(i,2)) = images(pos(i,1),pos(i,2))+spikeAmplitude2(i)*(tFrame/2>abs(f*tFrame-spiketimes2(i)));
            images(pos(i,1),pos(i,2)) = images(pos(i,1),pos(i,2))+spikeAmplitude3(i)*(tFrame/2>abs(f*tFrame-spiketimes3(i)));
            images(pos(i,1),pos(i,2)) = (bgF(i)+(images(pos(i,1),pos(i,2)) - bgF(i) - PB(i))*decaytime(i))+PB(i);
            PB(i)= PB(i)*decaytime2(i);
        end
       % image2(:,:,f) = image2(:,:,f)+plateNoise(idx(jj+1))*100*0.5*randn(size(image2(:,:,f)));
        image2(:,:,f) = conv2(spineshape,images);     
        image2(:,:,f) = image2(:,:,f)+background+1*pba*background*PB(i); % PB(i) is buffer going exp from 1 to 0 ;
        image2(:,:,f) = image2(:,:,f)+noiseLevel*50*randn(size(image2(:,:,f)));
        image3(:,:,f) = image2(1:512,1:512,f);
    end
%    figure(1);colormap gray;
%     
%      for f=1:totFrames
%         image(image2(:,:,f)*.10);
%         pause(.0285);
%      end
%     
    %%
    figure(2)
    hold off
    % Plot the response of the first synapse centre
    plot((1:totFrames)*tFrame, squeeze(image2(pos(1,1)+conn(1)/2,pos(1,2)+conn(2)/2,:)));
    hold on;
    % Decay time:
    t=0:0.032:8;plot(t,5*exp(-0.5*(t-1)*pi))
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
               error('tried 2 times but could not write to file')
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
csvwrite([storD '\PlateLayout_PBA.csv'],platePBA);
csvwrite([storD '\PlateLayout_Noise.csv'],plateNoise);
csvwrite([storD '\PlateLayout_On.csv'],plateOnOff);

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
    
