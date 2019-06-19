function fhandles=segGUIV1(myDir,headless)
global Version
Version = 'V0.86-Rel';
%% Much better dataviewer
% full export

fhandles{1}=@foldData;
fhandles{2}=@foldData2;
%% Feature requests:
% AllSynapse file.
% export % - explanation of the SVD components
% Singular values?
% Export specific collumns from export Table/csv.
% Spontanious activity
% Integrate plate view.
% Go multi-plate view.
% Allow other segmentation methods, e.g. std., correlation, clustering,
% kalman, subtract avg first 10 frames. (Tsnee, Umap, cohonen maps, clustering, ...)
% Fine tune mask segmentation: threshold, filters
% Temporal filtering,	
% - SVD components.
% Log spatio- temporal threshold value in process file.
% Check errors in filter-mechanism synapseDetails.
%%
disp(['S3T: Stimulated Synapse Segmentation Tool ' Version]);
disp('------------------------------------------------------');
try
    fid = fopen('asciNeuron.txt', 'r');
    neuronText = fread(fid, inf, 'uint8=>char')';
    fclose(fid);
    disp(neuronText);
catch
    disp('no asciNeuron found');
end
disp(['                                                    S3T: Stimulated Synapse Segmentation Tool ' Version]);
disp('                                                     ---------------------------------------------------');

%% Define global values
global controlResponse
global data;
global fNmTxt dNmTxt prjTxt thresTxt; % Text field in UI for file-name.
global synapseBW; % The BW figure with synapses=1, no-synapse=0
global fname pathname dirname; % Data location
global synRegio; % Regionprops return
global U S V; % eigv decomposition
global m; %This is the struct where all the main(m) window buttons and variables should be in.
global wx wy wt;
global synsignal;
global EVN eigTxt; % Defines wich eigen value is used to create the mask
global synProb; % Image before threshold for segmentation.
global TValue;  % Threshold value
global dt fps fpsTxt;
global maskRegio;
global stimulationStartTime;
global stimFreq NOS OnOffset;
global stimFreqtxt NOStxt OnOffsettxt;
global stimFreqtxt2 NOStxt2 %OnOffsettxt2;
global reuseMask reuseMaskChkButton fastLoad fastLoadChkButton segmentCellBodiesChkButton segmentCellBodies loadAnalysisChkButton; 
global pauseCB;
global nSynapses;
global sig2rb sig3rb sigOthRB otherSigmaValueEdit;
global tempSig2rb tempSig3rb tempSigOtherRB tempOtherSigmaValueEdit tempSigNoneRB;
global debug 
global dataFrameSelectionTxt PhotoBleachingTxt reloadMovie writeSVD skipMovie;
global TSpAPA TSpAPAi
global synSTD; 

% For experiment:
global C1Data C1pathname C1fname C1dirname                                 % Control 1AP
global C10Data C10pathname C10fname C10dirname                             % Control 10AP
global M5Data M5pathname M5fname M5dirname                                 % 5min. after drug addition
global M3Data M3pathname M3fname M3dirname  
global M15Data M15pathname M15fname M15dirname  
global M10Data M10pathname M10fname M10dirname                             % 10min. after drug addition
global M20Data M20pathname M20fname M20dirname                             % 20min. after drug addition
global M30Data M30pathname M30fname M30dirname                             % 20min. after drug addition
global ASR mASR miASR stdSR mstdSR swASR stdswASR AR mAR miAR AR1 rAR RSTmean RSTABSmean res
global defaultDir
global sliderBtn synSliderBtn
global bgc fullVersion;
global preCommand postCommand;
global maskTimeProjectionMethod;
global NumbAvgSamples;
maskTimeProjectionMethod='SVD';
preCommand = 'disp(''precommand'')';
postCommand = 'disp(''postCommand'')';
%% Set default values on load
stimFreq = 0.2;
NOS = 3; % Number of stimuli
OnOffset = 50;
EVN = 2; % Eigen Value Number
%warning('Eigen Value Hack 2->1')
fps = 33;
dt = 1/fps;
debug = 0;
dutyCycleOnFrames = 0;
setNumbAvgSamples(30);
setPhotoBleachingTxt('linInt');
setwriteSVD(1);
 
%% For post-processing
%% Set default values on load
stimFreq2 = 0;
NOS2 = 0; % Number of stimuli
m.OnOffset2 = 0;


%% Create a figure and axes
if ~exist('headless','var')
        startUp();
else
    if headless~=1
        startUp();
    end
end
%pause(5);
if nargin>0
    processDirAndSubDirs(myDir);
end
    function startUp()
        fullVersion = 0;
        bgc=[.35 .35 .38];
        %bgc=[.95 .95 .95];
        f2 = figure('Visible','on','name','S3T: Stimulated Synapse Segmentation Tool',...
            'Color',bgc,...
            'NumberTitle','off',...
            'KeyPressFcn', @keyPress);
        set(f2,'MenuBar', 'figure');
        %set(f2,'MenuBar', 'none');
        %set(f2, 'ToolBar', 'auto');
        %set(f2, 'ToolBar', 'none');
        %%%    javaFrame = get(f2,'JavaFrame');
        %%%   javaFrame.setFigureIcon(javax.swing.ImageIcon('my_icon.png'));
        
    pp= uicontrol('Style', 'Frame', 'String', ' ',...
        'Position', [10 by(-9.2) 170 140],...
        'BackgroundColor',bgc, 'ForegroundColor',[.05 .05 .08]);% ,...
    %'EdgeColor',[.15 .05 .08] );
    
    
    pp= uicontrol('Style', 'Frame', 'String', ' ',...
        'Position', [10 by(1.5) 170 190],...
        'BackgroundColor',bgc, 'ForegroundColor',[.05 .05 .08]);% ,...
    %'EdgeColor',[.15 .05 .08] );
    
    
    pp= uicontrol('Style', 'Frame', 'String', ' ',...
        'Position', [10 by(14)-5 170 100],...
        'BackgroundColor',bgc, 'ForegroundColor',[.05 .05 .08]);% ,...
    %'EdgeColor',[.15 .05 .08] );
    
    
    pp= uicontrol('Style', 'Frame', 'String', ' ',...
        'Position', [10 by(20)-5 170 100],...
        'BackgroundColor',bgc, 'ForegroundColor',[.05 .05 .08]);% ,...
    %'EdgeColor',[.15 .05 .08] );
    
    uicontrol('Style', 'text','String', 'Threshold Settings',...
        'FontWeight','normal','FontAngle','normal','FontSize',10,...
        'Position', [30 by(-15)+10 130 20],...
        'BackgroundColor',bgc);
    
    uicontrol('Style', 'text', 'String', 'Analysis Settings',...
        'FontWeight','normal','FontAngle','normal','FontSize',10,...
        'Position', [30 by(-7.5) 130 20],...
        'BackgroundColor',bgc);
    
    uicontrol('Style', 'text','String', 'post-Processing',...
        'FontWeight','normal','FontAngle','normal','FontSize',10,...
        'Position', [30 by(10) 130 20],...
        'BackgroundColor',bgc);
    
    uicontrol('Style', 'text','String', 'Analysis Tools',...
        'FontWeight','normal','FontAngle','normal','FontSize',10,...
        'Position', [20 by(16) 130 20],...
        'BackgroundColor',bgc);
    
    if fullVersion
            createListArray();
        end
        function createListArray()
            lstY=460;
            stimLst = uicontrol('Style', 'popup', 'String',  {'Spontanious','1 x 10AP','5 x 1AP','10 x 1AP'},...
                'Position', [0 lstY+40 250 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08] );
            labelLst = uicontrol('Style', 'popup', 'String',  {'SyGCaMP','PSD','iGlSnFr','Artificial'},...
                'Position', [0 lstY+20 250 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08] );
            expLst = uicontrol('Style', 'popup', 'String',  {'Control','5 min','10 min','20 min'},...
                'Position', [0 lstY+0 250 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08] );
            magnificationLst = uicontrol('Style', 'popup', 'String',  {'60X','40X','10X','100X'},...
                'Position', [0 lstY+60 250 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08] );
            lst5 = uicontrol('Style', 'popup', 'String',  {'file ... ','NSaaa','NSaaa','NSaaa'},...
                'Position', [0 lstY+80 250 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08] );
           
        end
      
        function createPushButtons
            
            
            %             ffig = uicontrol('Style', 'pushbutton', 'String', 'popFig',...
            %                 'Position', [1760 740 20 20],...
            %                 'Callback', @popFig);
            
            
            
            fNmTxt = uicontrol('Style', 'Text', 'String', 'no File loaded',...
                'Backgroundcolor',bgc,...
                'Position', [15 by(-23) 200 20] ); % file name
            
            dNmTxt = uicontrol('Style', 'Text', 'String', 'no Dir set',...
                'Backgroundcolor',bgc,...
                'FontSize',7,...
                'Position', [15 by(-20) 200 60] ); % Dir Name
            %prjTxt = uicontrol('Style', 'Text', 'String', 'no prj set',...
            prjTxt = uicontrol('Style', 'Text', 'String', ' ',...
                'Backgroundcolor',bgc,...
                'Position', [15 by(-19) 200 20] );
            
            foldButtons()
            function foldButtons()
                
                NOStxt = uicontrol('Style', 'Edit', 'String', num2str(NOS),...
                    'Position', [20 by(-4) 25 20],...
                    'Callback', @doSetNOS);
                uicontrol('Style', 'text', 'String', 'Number of Stim.',...
                    'Position', [70 by(-4) 100 20],'BackgroundColor',bgc);
                stimFreqtxt = uicontrol('Style', 'Edit', 'String', num2str(stimFreq),...
                    'Position', [20 by(-3) 25 20],...
                    'Callback', @doSetStimFreq);
                uicontrol('Style', 'text', 'String', 'Stim. freq.(Hz)',...
                    'Position', [70 by(-3) 100 20],'BackgroundColor',bgc);
                OnOffsettxt = uicontrol('Style', 'Edit', 'String', num2str(OnOffset),...
                    'Position', [20 by(-2) 25 20],...
                    'Callback', @doSetOnOffset);
                uicontrol('Style', 'text', 'String', 'Stim. delay (fr.)',...
                    'Position', [70 by(-2) 100 20],'BackgroundColor',bgc);
                
                
                
               NOStxt2 = uicontrol('Style', 'Edit', 'String', num2str(NOS2),...
                    'Position', [45 by(-4) 25 20],...
                    'Callback', @doSetNOS2);
               % uicontrol('Style', 'text', 'String', 'Number of Stim.',...
               %     'Position', [270 by(-4) 100 20]);
                stimFreqtxt2 = uicontrol('Style', 'Edit', 'String', num2str(stimFreq2),...
                    'Position', [45 by(-3) 25 20],...
                    'Callback', @doSetStimFreq2);
               % uicontrol('Style', 'text', 'String', 'Stim. freq. (Hz)',...
               %     'Position', [270 by(-3) 100 20]);
                m.OnOffsettxt2 = uicontrol('Style', 'Edit', 'String', num2str(m.OnOffset2),...
                    'Position', [45 by(-2) 25 20],...
                    'Callback', @doSetOnOffset2);
                %uicontrol('Style', 'text', 'String', 'Stim. delay (frames)',...
                %    'Position', [270 by(-2) 100 20]);
            end
            
            
            dirProcessBtn = uicontrol('Style', 'pushbutton', 'String', 'Process',...
                'FontSize',10,...
                ...%'FontWeight','bold',...
                'Position', [20 by(4) 150 40],...
                'Backgroundcolor',[0.28,0.3,0.5],...
                'Foregroundcolor',[0.8,0.8,0.8],...
                'Callback', @doProcessDir);
            
            
            fpsTxt = uicontrol('Style', 'Edit', 'String', num2str(fps),...
                'Position', [20 by(-5) 50 20],'Callback', @doSetFPS);
            
            
         
            
            setFPSBtn = uicontrol('Style', 'text', 'String', 'fps',...
                'Position', [20+50 by(-5) 50 20],...
                'BackgroundColor',bgc);
            
            
            
          plateLayoutBtn = uicontrol('Style', 'pushbutton', 'String', 'plate Layout',...
            'Position', [30 by(12) 120 20],...
            'BackgroundColor',bgc,...
            'Callback', @PlateLayout2);
        
        spBlue=[0.50,0.55,0.75];
        
            readResultsBtn = uicontrol('Style', 'pushbutton', 'String', 'Generate Results',...
            'Position', [30 by(13) 120 20],...
            'Backgroundcolor',spBlue,...
            'Callback', @doReadResults);
        
        overviewGeneratorBtn = uicontrol('Style', 'pushbutton', 'String', 'Generate Overview(s) ',...
            'Position', [30 by(14) 120 20],...
            'Backgroundcolor',spBlue,...
            'Callback', @doOverviewGenerator);
     
        analysisBtn = uicontrol('Style', 'pushbutton',  'String', {'Create Analysis Cfg'},...
            'Position', [30 by(-6)+4 120 20],...
            'BackgroundColor',bgc,...
            'Callback', @doAnalysisCfgGenerator);
        
        
         dataViewerBtn = uicontrol('Style', 'pushbutton', 'String', 'data Viewer',...
            'Position', [30 by(18) 120 20],...
            'BackgroundColor', [0.50,0.60,0.65],...
            'Callback', @doDataViewer);
        
           
        viewTracesBtn = uicontrol('Style', 'pushbutton', 'String', 'View traces',...
            'BackgroundColor', [0.50,0.60,0.65],...
            'Position', [30 by(19) 120 20],...
            'Callback', @doviewTraces);
       projViewerBtn = uicontrol('Style', 'pushbutton', 'String', 'View Projects',...
            'BackgroundColor', [0.50,0.60,0.65],...
            'Position', [30 by(20) 120 20],...
            'Callback', @doProjViewer);
        
            
            
%            r1 = rectangle(...
 %               'Position', [20+50 by(-5) 200 200]...
  %              );
           % annotation(f2,'rectangle',...
   % 'Position',[70 by(-5) 200 200]);

            
       
            if fullVersion
                loadDefaultBtn = uicontrol('Style', 'pushbutton', 'String', 'loadDefault!',...
                    'Backgroundcolor',bgc,...
                    'Position', [45 by(1) 10 20],...
                    'Callback', @loadDefault);
            end
            
            
            if (fullVersion)
                btn2 = uicontrol('Style', 'pushbutton', 'String', 'Segment!',...
                    'Position', [5 by(4) 50 20],...
                    'Backgroundcolor',bgc,...
                    'Callback', @segment);
                
                
                btn3 = uicontrol('Style', 'pushbutton', 'String', 'Background!',...
                    'Position', [5 by(5) 50 20],...
                    'Backgroundcolor',bgc,...
                    'Callback', @bg);
                
                btn4 = uicontrol('Style', 'pushbutton', 'String', 'eigy!',...
                    'Position', [20 by(6) 50 20],...
                    'Backgroundcolor',bgc,...
                    'Callback', @eigy);
            end
            optionsBtn = uicontrol('Style', 'pushbutton', 'String', 'Options',...
                'Position', [20 by(0) 50 20],...
                'Backgroundcolor',bgc,...
                'Callback', @dispOptions);
            %dispOptions();
            
        end
        createPushButtons();
        createCheckBoxes();
        
        function createCheckBoxes()
            %             rbgCB = uicontrol('Style','checkbox','Value',1,...
            %                 'Position',[70 by(9)+2.5 40 15],'String','');
            
            %             pauseCB = uicontrol('Style','checkbox','Value',0,...
            %                 'Position',[170 by(19)+2.5 60 15],'String','Pause');
           
            
             fastLoadChkButton = uicontrol('Style','checkbox','Value',0,...
                'Position',[70 by(1)+2.5 100 15],'String','Fast Load','Backgroundcolor',bgc);
            
             loadAnalysisChkButton = uicontrol('Style','checkbox','Value',1,...
                'Position',[70 by(-1)+2.5 100 15],'String','Load Analysis'...
            ,   'Callback', @grayOutSettings,...
            'Backgroundcolor',bgc);
          
            reuseMaskChkButton = uicontrol('Style','checkbox','Value',0,...
                'Position',[70 by(0)+2.5 100 15],'String','Reuse Mask','Backgroundcolor',bgc);
        end
        
        createRadioButtons1();
        createRadioButtons2();
        
        function createRadioButtons1()
            rb1title = uicontrol('Style', 'Text', 'String',  {'Spatial'},...
                'Position', [15 700 40 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08]);
           
           % buttonGroup1 = uibuttongroup(f2,'Position',[137 113 123 85]);  
           GE = char(hex2dec('03C3'));
            sig2rb = uicontrol('Style', 'radiobutton', 'String',  {['2' GE]},...
                'Position', [20 680 100 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],'callback',@set2sigma,...
                 'ToolTipString','Mask created by setting threshold at 2 sigma, sigma is the std of the time projected picture');
          
            sig3rb = uicontrol('Style', 'radiobutton', 'String',  {['3' GE]},...
                'Position', [20 660 100 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],'callback',@set3sigma,...
                'ToolTipString','Mask created by setting threshold at 3 sigma, sigma is the std of the time projected picture');
            sigOthRB = uicontrol('Style', 'radiobutton', 'String',  {':'},...
                'Position', [20 640 100 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],'callback',@setOtherSigma);
            otherSigmaValueEdit = uicontrol('Style', 'edit', 'String',  {'...'},...
                'Position', [35 640 25 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],'callback',@checkFixedThresholdValue);
            
            sig2rb.Value=1;
        end
        function createRadioButtons2()
            
           rb2title = uicontrol('Style', 'Text', 'String',  {'/ Temporal Threshold'},...
                'Position', [65 700 105 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08]);
             GE = char(hex2dec('03C3'));
           % buttonGroup1 = uibuttongroup(f2,'Position',[137 113 123 85]);  
            tempSig2rb = uicontrol('Style', 'radiobutton', 'String',  {['2' GE]},...
                'Position', [75 680 50 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],'callback',@setTemp2sigma,...
                 'ToolTipString','Mask created by filtering out synapses with less than 3 sigma reponse. Sigma is calculated as the std of the first 10 samples; =AvgSamples');
            tempSig3rb = uicontrol('Style', 'radiobutton', 'String',  {['3' GE]},...
                'Position', [75 660 50 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],'callback',@setTemp3sigma,...
                'ToolTipString','Mask created by filtering out synapses with less than 2 sigma reponse. Sigma is calculated as the std of the first 10 samples; =AvgSamples');
         
            tempSigOtherRB = uicontrol('Style', 'radiobutton', 'String',  {'Oth.'},...
                'Position', [75 640 50 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],'callback',@setTempOtherSigma,...
                'ToolTipString','Mask created by filtering out synapses with less than value reponse.');
      
            
            tempSigNoneRB = uicontrol('Style', 'radiobutton', 'String',  {'None'},...
                'Position', [75 620 50 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],'callback',@setTempNoneSigma,...
                'ToolTipString','No filtering based on temporal behavior of the synapses is done.');
         
            tempOtherSigmaValueEdit = uicontrol('Style', 'edit', 'String',  {'...'},...
                'Position', [90 640 25 25], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],'callback',@checkTempFixedThresholdValue);
            
            tempSig2rb.Value=1;
        end
        
        function setTemp2sigma(g,h,e)
            tempSig2rb.Value=1;
            tempSig3rb.Value=0;
            tempSigOtherRB.Value=0;
            tempSigNoneRB.Value=0;
        end
        function setTemp3sigma(g,h,e)
            tempSig2rb.Value=0;
            tempSig3rb.Value=1;
            tempSigOtherRB.Value=0;
            tempSigNoneRB.Value=0;
        end
        function setTempOtherSigma(g,h,e)
            tempSig2rb.Value=0;
            tempSig3rb.Value=0;
            tempSigOtherRB.Value=1;
            tempSigNoneRB.Value=0;
        end
        function setTempNoneSigma(g,h,e)
            tempSig2rb.Value=0;
            tempSig3rb.Value=0;
            tempSigOtherRB.Value=0;
            tempSigNoneRB.Value=1;
        end
        
        function set2sigma(g,h,e)
            sig2rb.Value=1;
            sig3rb.Value=0;
            sigOthRB.Value=0;
        end
        function set3sigma(g,h,e)
            sig2rb.Value=0;
            sig3rb.Value=1;
            sigOthRB.Value=0;
        end
        function setOtherSigma(g,h,e)
            sig2rb.Value=0;
            sig3rb.Value=0;
            sigOthRB.Value=1;
        end
        thresTxt = uicontrol('Style', 'Edit', 'String', 'no threshold set',...
            'Position', [20 by(1) 50 20]);
        
        author();
        function author()
            pos = get(f2, 'Position'); %// gives x left, y bottom, width, height
            figWidth = pos(3);
            figHeight = pos(4);
            txt2 = uicontrol('Style', 'Text', 'String', ['S3T: ' Version ', M. Van Dyck (UAntwerpen)'],...
                'Position', [-30 -5 200 20],'Backgroundcolor',bgc); %[figWidth-40 -5 200 20]
        end
        
        grayOutSettings();
        defaultDir  = 'E:\share\Data\Rajiv';
    end
    function y = by(k) % calculate y coordinate of button
        nBtnsY = 20; % Number of buttons
        yoff = 30; % Offset bottom
        y = 20*nBtnsY-k*20+yoff;
    end
    function dispOptions(e,v,h)
        
        segmentCellBodiesChkButton = uicontrol('Style','checkbox','Value',0,...
            'Position',[70 by(2)+2.5 100 15],'String','segment Cell Bodies',...
            'Callback',@doSetCellBody);
        
%         btn77 = uicontrol('Style', 'pushbutton', 'String', 'processDirs',...
%             'Position', [160 by(5) 50 20],...
%             'Callback', @processDirs);
        
        thresTxt = uicontrol('Style', 'Edit', 'String', 'no threshold set',...
            'Position', [70 by(8) 50 20]);
   
        eigTxt = uicontrol('Style', 'Edit', 'String', num2str(EVN),...
            'Position', [70 by(7) 50 20],'Callback',@changeEig);
        
        
        loadTiff22Btn = uicontrol('Style', 'pushbutton', 'String', 'File',...
            'Position', [5 by(1) 50 20],...
            'Callback', @loadTiff22);
        
        btnDir = uicontrol('Style', 'pushbutton', 'String', 'Dir',...
            'Position', [5 by(3) 50 30],...
            'Callback', @setDir);
        
        prjDir = uicontrol('Style', 'pushbutton', 'String', 'Project',...
            'Position', [5 by(4) 50 20],...
            'Callback', @setPRJ);
        
        playBtn = uicontrol('Style', 'pushbutton', 'String', 'play',...
            'Position', [60 by(5) 50 20],...
            'Callback', @playMov);
        
        fijimeBtn = uicontrol('Style', 'pushbutton', 'String', 'ImageJ',...
            'Position', [110 by(5) 50 20],...
            'Callback', @fijime);
        thresholdBtn = uicontrol('Style', 'pushbutton', 'String', 'threshold',...
            'Position', [20 by(8) 50 20],...
            'Callback', @doThreshold);
        thresholdBtn = uicontrol('Style', 'pushbutton', 'String', '3sig',...
            'Position', [170 by(8) 50 20],...
            'Callback', @doThreeSigThreshold);
        cleanBtn = uicontrol('Style', 'pushbutton', 'String', 'clean',...
            'Position', [70+50 by(8) 50 20],...
            'Backgroundcolor',bgc,...
            'Callback', @cleanBW);
        freqfilter2DBtn = uicontrol('Style', 'pushbutton', 'String', '2D freq filter',...
            'Position', [170+50 by(8) 50 20],...
            'Callback', @freqfilter2D);
        rmBkgrndBtn = uicontrol('Style', 'pushbutton', 'String', 'rmvBkGrnd!',...
            'Position', [20 by(9) 50 20],...
            'Callback', @rmvBkGrnd);
        subtractBckgrndBtn = uicontrol('Style', 'pushbutton', 'String', 'Black!',...
            'Position', [70 by(9) 50 20],...
            'Callback', @subtractBlackLevel);
        topHatBtn = uicontrol('Style', 'pushbutton', 'String', 'Tophat',...
            'Position', [217 by(9) 50 20],...
            'Callback', @tophat);
        thresholdBtn = uicontrol('Style', 'pushbutton', 'String', '2sig',...
            'Position', [170 by(9) 50 20],...
            'Callback', @doTwoSigThreshold);
        detectIslandsBtn = uicontrol('Style', 'pushbutton', 'String', 'detect Islands',...
            'Position', [5 by(10) 50 20],...
            'Callback', @detectIslands);
        
        loadMaskBtn = uicontrol('Style', 'pushbutton', 'String', 'load Mask',...
            'Position', [155 by(10) 50 20],...
            'Callback', @doloadMask);
        exportMaskBtn = uicontrol('Style', 'pushbutton', 'String', 'exp. Mask',...
            'Position', [105 by(10) 50 20],...
            'Callback', @doExportMask);
        
        btn7 = uicontrol('Style', 'pushbutton', 'String', 'saveROIs!',...
            'Position', [5+50 by(10) 50 20],...
            'Backgroundcolor',bgc,...
            'Callback', @saveROIs);
        
        btn9 = uicontrol('Style', 'pushbutton', 'String', 'extractSignals!',...
            'Position', [5 by(11) 50 20],...
            'Backgroundcolor',bgc,...
            'Callback', @extractSignals);
        
        
        btnFold = uicontrol('Style', 'pushbutton', 'String', 'fold spikes',...
            'Position', [150 by(12) 50 20],...
            'Callback', @doMultiResponseto1);
        
        btn10 = uicontrol('Style', 'pushbutton', 'String', 'signalPlot!',...
            'Position', [5 by(12) 50 20],...
            'Backgroundcolor',bgc,...
            'Callback', @signalPlot);
        
        btn11 = uicontrol('Style', 'pushbutton', 'String', 'heatMeMap!',...
            'Position', [55 by(12) 50 20],...
            'Callback', @heatMeMap);
        
        avgSynBtn = uicontrol('Style', 'pushbutton', 'String', 'avg Synapse Response',...
            'Position', [100 by(12) 50 20],...
            'Callback', @avgSynapseResponse);
        
        avgAnalyseBtn = uicontrol('Style', 'pushbutton', 'String', 'Analyze AVG',...
            'Position', [150 by(13) 50 20],...
            'Callback', @analyseAvgResponse);
        
        
        exportSynapseHeatmapBtn = uicontrol('Style', 'pushbutton', 'String', 'exportSynapseHeatmap',...
            'Position', [100 by(13) 50 20],...
            'Callback', @exportSynapseHeatmap);
        
        analyseBt = uicontrol('Style', 'pushbutton', 'String', 'Analyze All',...
            'Position', [150 by(14) 50 20],...
            'Callback', @analyseSingSynResponse);
        
        
        exportSynapseSignalsBtn = uicontrol('Style', 'pushbutton', 'String', 'exportSynapseSignals',...
            'Position', [100 by(14) 50 20],...
            'Callback', @exportSynapseSignals);
        
        
        createProjectionButtons()
        function createProjectionButtons
            
            segmentBtn = uicontrol('Style', 'pushbutton', 'String', 'segment2!',...
                'Position', [20 by(7) 50 20],...
                'Callback', @segment2);
            
            if fullVersion
                btn28 = uicontrol('Style', 'pushbutton', 'String', 'NMF',...
                    'Position', [70 by(7) 50 20],...
                    'Callback', @doNMF);
            end
            
            changeBtn = uicontrol('Style', 'pushbutton', 'String', 'change',...
                'Position', [170+50 by(7) 50 20],...
                'Callback', @changeZ);
            
            maxProjectionBtn = uicontrol('Style', 'pushbutton', 'String', 'max Z',...
                'Position', [70+50 by(7) 50 20],...
                'Callback', @maxZ);
            
            meanProjectionBtn = uicontrol('Style', 'pushbutton', 'String', 'mean Z',...
                'Position', [170 by(7) 50 20],...
                'Callback', @meanZ);
            
        end
        
        
        
        %         goBtn = uicontrol('Style', 'pushbutton', 'String', 'Process...!',...
        %             'Position', [5 by(15) 100 60],...
        %             'BackgroundColor',[.7 .5 .5],...
        %             'Callback', @go);
        
        doProcessMovieBtn = uicontrol('Style', 'pushbutton', 'String', 'Process...!',...
            'Position', [5 by(15) 100 60],...
            'BackgroundColor',[.7 .5 .5],...
            'Callback', @doProcessMovie);
        
        
        
        sliderBtn = uicontrol('Style', 'slider', 'String', 'Process...!',...
            'Position', [200 by(15) 100 10],...
            'BackgroundColor',[.7 .5 .5],...
            'Callback', @slide);
        
        synSliderBtn = uicontrol('Style', 'slider', 'String', 'Process...!',...
            'Position', [200 by(16) 100 10],...
            'BackgroundColor',[.7 .5 .5],...
            'Callback', @synSlider);
        
        
        doseResponseBtn = uicontrol('Style', 'pushbutton', 'String', 'dose ResponseBtn',...
            'Position', [5 by(16) 50 20],...
            'Callback', @doseResponse);
        
        btn12 = uicontrol('Style', 'pushbutton', 'String', 'Peakfinder!',...
            'Position', [5 by(17) 50 20],...
            'Callback', @peakfinder);
        
        btn13 = uicontrol('Style', 'pushbutton', 'String', 'Load Experiment',...
            'Position', [55 by(17) 50 20],...
            'Callback', @experimentLoader);
        
        btn14 = uicontrol('Style', 'pushbutton', 'String', 'Batch Experiments',...
            'Position', [105 by(17) 50 20],...
            'Callback', @batchExperiments);
        
        

        stimLoadBtn = uicontrol('Style', 'pushbutton', 'String', 'Load Stim',...
            'Position', [55 by(19) 50 20],...
            'Callback', @doStimCfgLoad);
        
        
        AnalysisLoadBtn = uicontrol('Style', 'pushbutton', 'String', 'Load Analysis',...
            'Position', [105 by(19) 50 20],...
            'Callback', @doLoadAnalysisSettings);
        
        
        
        viewTracesBtn = uicontrol('Style', 'pushbutton', 'String', 'View traces',...
            'Position', [155 by(19) 50 20],...
            'Callback', @doviewTraces);
        
        
        viewMetaDataBtn = uicontrol('Style', 'pushbutton', 'String', 'View Meta Data',...
            'Position', [205 by(19) 50 20],...
            'Callback', @doMetaDataImporter);
        
    end

    function doMetaDataImporter(a,b,c)
        metaDataImporter();
    end

    function doViewMetaData(s,e,h)
        analysisCfgGenerator();
    end



    function doProjViewer(s,e,h)
        projViewer();
    end


    function doviewTraces(s,e,h)
        viewTraces();
    end


    function doAnalysisCfgGenerator(s,e,h)
        analysisCfgGenerator();
    end

    function changeEig(s,e,h)
        EVN = str2num(eigTxt.String);
    end
    function doDataViewer(s,e,h)
        dataViewer();
    end
    function doOverviewGenerator(s,e,h) 
        %goDeep(@overviewGenerator,'\*.png');
        rootdir=uigetdir(defaultDir);
         goAllSubDir(@overviewGenerator,'\*.png',rootdir);
%         goDeep(@overviewGenerator,'\*mask.png',rootdir);
%         goDeep(@overviewGenerator,'\*align.png',rootdir);
%         goDeep(@overviewGenerator,'\*analysis.png',rootdir);
%         goDeep(@overviewGenerator,'\*temp.png',rootdir);
%         goDeep(@overviewGenerator,'\*signals.png',rootdir);
    end
    function doReadResults(s,e,h)
        try
            rootdir=uigetdir(defaultDir);
        catch
             rootdir=uigetdir();
        end
        goDeep(@plateMetaDataConverter,'\barcode.txt',rootdir);
        pause(.5);
        goDeep(@readResults,'\*analysis.txt',rootdir);
    end

    function doSetOnOffset(s,e,h)
        setOnOffset(str2double(OnOffsettxt.String));
    end
    function setOnOffset(OnOffsetTemp)
        OnOffset= OnOffsetTemp;
        OnOffsettxt.String = num2str(OnOffset);
    end

    function doSetOnOffset2(s,e,h)
        setOnOffset2(str2double(m.OnOffsettxt2.String));
    end
    function setOnOffset2(OnOffsetTemp)
        m.OnOffset2= OnOffsetTemp;
        m.OnOffsettxt2.String = num2str(m.OnOffset2);
    end

    function doSetStimFreq(s,e,h)
        setStimFreq(str2double(stimFreqtxt.String));
    end
    function setStimFreq(stimFreq2)
        stimFreq= stimFreq2;
        stimFreqtxt.String = num2str(stimFreq);
    end

    function doSetStimFreq2(s,e,h)
        setStimFreq2(str2double(stimFreqtxt2.String));
    end
    function setStimFreq2(stimFreqTemp)
        stimFreq2= stimFreqTemp;
        stimFreqtxt2.String = num2str(stimFreq2);
    end

    function doSetNOS(s,e,h) % Number of Stimuli
        setNOS( str2double(NOStxt.String));        
    end
    function setNOS(NOSTemp) % Number of Stimuli
        NOS = NOSTemp;
        NOStxt.String = num2str(NOS);
    end

    function doSetNOS2(s,e,h) % Number of Stimuli
        setNOS2( str2double(NOStxt2.String));        
    end
    function setNOS2(NOSTemp) % Number of Stimuli
        NOS2 = NOSTemp;
        NOStxt2.String = num2str(NOS2);
    end


    
    function setDutyCycleOnFrames(a)
        dutyCycleOnFrames=a;
    end


    function doSetCellBody(h,g,f)
        setCellBody(segmentCellBodiesChkButton.Value);
    end

    function setCellBody(a)
        segmentCellBodies=a;
    end

    function doSetFPS(s,e,h)
     setFPS(str2double(fpsTxt.String));
    end


    function setFPS(fps2)
        fps=fps2;
        dt=1/fps;
        fpsTxt.String = num2str(fps);
    end
    function slide(s,e)
        imagesc(data(:,:,floor(sliderBtn.Value*size(data,3))+1));
    end

    function doThreeSigThreshold(source,event,handles)
        threesigma = mean(synProb(:))+3*std(synProb(:));
        setTvalue(threesigma);
        doThreshold();
    end
    function doTwoSigThreshold(source,event,handles)
        twosigma = mean(synProb(:))+2*std(synProb(:));
        setTvalue(twosigma);
        doThreshold();
    end
    function changeZ(source,event,handles)
        synProb = mean(abs(bsxfun(@min,data,mean(data,3))),3);
        pause(.5);
        imagesc(synProb);
    end
    function meanZ(source,event,handles)
        synProb = mean(data,3);
        pause(.5);
        imagesc(synProb);
    end
    function maxZ(source,event,handles)
        synProb = max(data,[],3);
        pause(.5);
        imagesc(synProb);
    end
    function tophat(source,event,handles)
        if 0
        doLaplaceFilter();
        else
        se = strel('disk',5);
        %synProb = imadjust(imtophat(synProb ,se));
        synProb = imsharpen(synProb,'Radius',16,'Amount',40);% ,'roberts');
        end
        imagesc(synProb);
        pause(.5);
        
    end
    function doLaplaceFilter(s,e,h)
        synProb = laplaceFilter(synProb );
    end

    function synProb = laplaceFilter(synProb)
        sigma=.1;
        alpha=4;
        % Geen goed idee, scaling depnds on range, 
        Msp = max(synProb(:));
        msp = min(synProb(:));
        Msp = 1;
        msp = -1;
        
        synProb16 = int16((synProb-msp)/(Msp-msp+1e-6)*2^15);
        
        
        B =locallapfilt(synProb16 ,sigma,alpha,'NumIntensityLevels', 100);
        psnr_denoised = psnr(B, synProb16)
        imagesc(B);
        
        synProb =double(B)*((Msp-msp+1e-6)+msp)/2^15;
    end

    function go(source,event,handles)
        if exist(dirname)
            if (dirname~=0)
                arg.pdir = dirname;
                dataGo(arg);
            else
                dataGo();
            end
        else
            dataGo()
        end
    end
    function playMov(source,event,handles)
        maxData=max(data(:));
        pause(.5)
        for (i=1:size(data,3))
            image(data(:,:,i)/maxData*64*2);
            drawnow();
        end
    end
    function extractSignals(source,event,handles)
        s2=synRegio;
        synsignal=[];
        spaceTimeSTD=zeros(1,length(s2));
        spaceMeanTimeSTD=zeros(1,length(s2));
        meanSpaceTimeSTD=zeros(1,length(s2));
        synProbSTD=zeros(1,length(s2));
        laplaceSynProbSTD=zeros(1,length(s2));
        
        lpsynProb = laplaceFilter(synProb);
        rframes=reshape(data,wx*wy,[]);
        rsynProb= reshape(synProb,wx*wy,[]);
        rlpsynProb = reshape(lpsynProb,wx*wy,[]);
        
        for j=1:length(s2)
            mask=zeros(wy,wx);
            % pixl=s2(j).PixelList;
            
            pixlid=s2(j).PixelIdxList;
            ss=rframes(pixlid,:); % synapseSignals
            synsignal(:,j) = mean(ss,1);
            spaceTimeSTD(:,j) = std(ss(:));
            spaceMeanTimeSTD(:,j) = std(mean(ss,2));
            meanSpaceTimeSTD(:,j) = std(mean(ss,1));
            synProbSTD(:,j) = std(rsynProb(pixlid));
            laplaceSynProbSTD(:,j) = std(rlpsynProb(pixlid));
        end
        if length(s2)==0
            disp('No synapses found, combining all pixels into 1 big synapse.');
            rframes=reshape(data,wx*wy,[]);
            ss= rframes(:,:);
            synsignal(:,1) = mean(ss,1);
            spaceTimeSTD = std(ss(:));
            spaceMeanTimeSTD = std(mean(ss,2));
            meanSpaceTimeSTD = std(mean(ss,1));
            synProbSTD = std(rsynProb(:));
            laplaceSynProbSTD = std(rlpsynProb(:));
        end
        synSTD.spaceTimeSTD = spaceTimeSTD;
        synSTD.spaceMeanTimeSTD = spaceMeanTimeSTD;
        synSTD.meanSpaceTimeSTD = meanSpaceTimeSTD;
        synSTD.synProbSTD=synProbSTD;
        synSTD.laplaceSynProbSTD=laplaceSynProbSTD;
    end
    function synSlider(s,e)
        % Should be a slider to browse trough different synapse scahpe and
        % responses.
        
    end
    function heatMeMap(source,event,handles)
        %dffSign = dff(smoothM(synsignal,3)');
        dffSign = dff(synsignal');
        subplot(4,4,12)
        pause(.5)
        imagesc(dffSign);colormap('hot');
        cmh=colormap(hot);
        imwrite(dffSign*100,cmh,[pathname(1:end-4) '_hsignals.png']);
        %savesubplot(4,4,12,[pathname(1:end-4) '_signals']);
    end
    function signalPlot(source,event,handles)
        pause(.5)
        subplotNr=16;
        subplot(4,4,subplotNr);
        plot(bsxfun(@plus,4*dff(synsignal')',1*(1:size(synsignal,2))));
        drawnow();
        %plot(bsxfun(@plus,(synsignal')',1000*(1:size(synsignal,2))));
        savesubplot(4,4,subplotNr,[pathname(1:end-4) '_signals']);
        ttdffs = tempThreshold(dff(synsignal'))';
        if ~isempty(ttdffs)
            plot(bsxfun(@plus,4* ttdffs,1*(1:size(ttdffs,2))));
        else
            hold off
            plot(0);
        end
        drawnow();
        savesubplot(4,4,subplotNr,[pathname(1:end-4) '_signalsAT']); % AT: After Threshold
    end
    function exportSynapseSignals (source,event,handles)
        %         pause(.5)
        %         subplot(4,4,16);
        %         plot(bsxfun(@plus,4*dff(synsignal')',1*(1:size(synsignal,2))));
        if ~isdir([dirname 'output\'])
            mkdir([dirname 'output\']);
        end
        if ~isdir([dirname 'output\SynapseDetails\'])
            mkdir([dirname 'output\SynapseDetails\']);
        end
        
        [dfftempThresSignals, thresKeepIdx] = tempThreshold(dff(synsignal')); % For synapse Traces
        synsignal = synsignal(:,thresKeepIdx); % Here synsignal is Thresholded.
        synSTD.laplaceSynProbSTD=synSTD.laplaceSynProbSTD(thresKeepIdx);
        synSTD.meanSpaceTimeSTD=synSTD.meanSpaceTimeSTD(thresKeepIdx);
        synSTD.spaceMeanTimeSTD=synSTD.spaceMeanTimeSTD(thresKeepIdx);
        synSTD.spaceTimeSTD=synSTD.spaceTimeSTD(thresKeepIdx);
        synSTD.synProbSTD=synSTD.synProbSTD(thresKeepIdx);
        
        if   ~isempty(synRegio) 
            synRegio=synRegio(thresKeepIdx); % Here the mask is adjusted.
        end
        rawTempThresSignals = synsignal'; % For Raw Synapse Traces.
        
        
     %   if size(dfftempThresSignals,1)==0
     %       dfftempThresSignals=zeros(1,size(dfftempThresSignals,2));
     %   end
        tvec=(dt*(1:size(rawTempThresSignals,2))');
        dffr=[tvec,dfftempThresSignals'];
        r=[tvec,rawTempThresSignals'];
        tableLabels{1}='time';
        for i=1:size(rawTempThresSignals,1)
            tableLabels{i+1}=['syn' num2str(i)];
        end
        t =array2table(dffr,'VariableNames',tableLabels);
        t2=array2table(r,'VariableNames',tableLabels);
        
        writetable(t,[dirname 'output\SynapseDetails\' fname(1:end-4) '_synTraces.csv']);
        writetable(t2,[dirname 'output\SynapseDetails\' fname(1:end-4) '_RawSynTraces.csv']);
        %csvwrite([dirname 'output\SynapseDetails\' fname(1:end-4) '_synapses.csv'],tempThresSignals');
        
        %plot(bsxfun(@plus,(synsignal')',1000*(1:size(synsignal,2))));
    end

    function [b, keptIdx, removedIdx]=tempThreshold(a)
        b=a;
        removedIdx=[];
        keptIdx=1:size(a,1);
        numberOfSynapsesDeleted=0;
        th=nan; % Initialise th for the case there are no synapses found.
        if tempSig2rb.Value
            Nsigma = 2;
        end
        if tempSig3rb.Value
            Nsigma = 6;
            disp('sigma hacked to 6')
        end
       if size(a,2)<10
           warning('not enough samples to estimate temporal sigma.')
       end
        if tempSig2rb.Value ||  tempSig3rb.Value
            for i=size(a,1):-1:1 %(SYNAPSES,TIME)
                th=(mean(a(i,1:NumbAvgSamples))+Nsigma*std(a(i,1:NumbAvgSamples)));
                if th>max(a(i,:))
                    removeSynapse();
                end
            end
        end
        
        if tempSigOtherRB.Value
            th=str2double(tempOtherSigmaValueEdit.String);
            for i=size(a,1):-1:1 %(SYNAPSES,TIME)
                if th>max(a(i,:))
                    removeSynapse();
                end
            end
        end
        
        if tempSigNoneRB.Value
        % Do nothing, just move a to b
        th=-inf;
        end
        
        disp([num2str(numberOfSynapsesDeleted) ' Synapses removed due to not reaching temporal threshold: ' num2str(th)]);
        function removeSynapse()
                    
                    b(i,:)=[];
                    keptIdx(i)=[];
                    removedIdx=[removedIdx, i];
                    %disp(['Synapse ' num2str(i) ' removed: not reaching temporal threshold.']);
                    numberOfSynapsesDeleted = numberOfSynapsesDeleted + 1;
           
        end
    end

    function detectIslands(s,e)
        synRegio  = regionprops(synapseBW(:,:),'PixelList','PixelIdxList');
    end
    function [ROIs] = saveROIs(source,event,handles)
        %% Mask van regioprops van s wordt ge-exporteerd in ROI subdir.
        mkdir([dirname 'ROI']);
        for i=1:length(synRegio)
            pixlid=synRegio(i).PixelIdxList;
            ROI = zeros(wy,wx);
            ROI(pixlid)=1;
            imwrite(ROI, [dirname '\ROI\' fname '_M' num2str(i) '.png'],'bitdepth',2);
        end
    end
    function [data22, fname] = bg(source,event,handles)
        %% From first 5 and last 5 frames:
        % Select darkest 1/400 pixels
        % and average.
        [sortedData, bgIndx1]=sort(data(1:(wx*wy)*5));
        bg1 = mean(sortedData(1:floor(end/4)));                             % Background Intensity
        f1 = mean(sortedData(floor(end/10):end));                           % Foreground Intensity
        
        [i1, i2, i3] = ind2sub( [wy,wx,5], bgIndx1);
        li1 = length(i1); % Number of pixels in 5 frames
        li1o4 = floor(li1/5); % pixels/frames??
        D2=reshape(data,[],size(data,3));
        dxy=sub2ind([wy, wx],i1(1:li1o4/20),i2(1:li1o4/20)); % First 5000 pixels
        darkProfiles = (D2(dxy,1:size(data,3)));
        plot(mean(darkProfiles));hold off;
        [dx, dy]=ind2sub([wy,wx],dxy);
        hold on;plot(dx,dy,'r.');
        
        sortedData2=sort(data((end-(wy*wx)*5):end)); % Last frames
        bg2 = mean(sortedData2(1:floor(end/4))); % Take darkest ones
        f2 = mean(sortedData2(floor(end/10):end)); % Take brightest ones
        
        
        [bg, bgI] = mink(reshape(data,[],size(data,3)),floor(wy*wx*.04)); % Take 10% darkest pixels in each frame
        mbg = mean(bg);
        [fg, fgI] = maxk(reshape(data,[],size(data,3)),floor(wy*wx*.01)); % Take 10% darkest pixels in each frame
        mfg = mean(fg);
        bh=hist(bgI(:),1:(wy*wx));
        fh=hist(fgI(:),1:(wy*wx));
        %figure;
        imagesc(reshape(fh,wy,wx));
        figure;imagesc(reshape(bh,wy,wx));
        
        avg = mean(reshape(data,[],size(data,3)));
        %figure;
        subplot(4,4,12);
        plot(mbg);hold on
        plot(mfg,'r');
        plot(avg,'g');
        legend('Background','Foreground','Average');
    end
    function doNMF(source,event,handles)
        x = reshape(data,[],size(data,3))';
        opt = statset('maxiter',5000,'display','final');
        [w,h] = nnmf(x,5,'rep',10,'opt',opt,'alg','mult');
        opt = statset('maxiter',10000,'display','final');
        [w,h] = nnmf(x,5,'w0',w,'h0',h,'opt',opt,'alg','als');
        %[w,h] = nnmf(reshape(data,[],size(data,3)),6);
        U=h',V=w;
        
        imageEigen;
    end
    function segment2(source,event,handles)
        
        if ~exist('maskTimeProjectionMethod','var')
            maskTimeProjectionMethod=('SVD');
            warning('maskTimeProjectionMethod was not set!');
        end
        switch maskTimeProjectionMethod
            case 'SVD'        
        
        %global data;
        [U, S, V] = doeigy();%source,event);%,handles);
        %% mirror eigen for + stimulation
        for ii=1:6
            nBlack = sum(U(:,ii)<mean(U(:,ii)));
            nWhite = sum(U(:,ii)>mean(U(:,ii)));
            
            nWhite = abs(prctile(V(:,ii),01.0)); %We expect the distribution of the response to be shifted/more tailed towards the side where reponse is positive. 
            nBlack = abs(prctile(V(:,ii),99.0));
            
            if (nBlack<nWhite)
                thesign = -1;
            else
                thesign = 1;
            end
%             if ii==1
%                 thesign=-1*thesign; %Flip the first eigvector, since we expect here the response to be mainly above 0.
%             end
            
            
            U(:,ii) = thesign .*U(:,ii);
            V(:,ii) = thesign .*V(:,ii);
            %synProb = (-1*(sign(V(1,EVN)).*synProb));
        end
        if ~isdir([dirname './eigs/'])
            mkdir([dirname './eigs/'])
        end
       % writeSVD=1;
        if writeSVD
            for evnI=1:16
                imwrite(reshape(uint16(U(:,evnI)*length(U)+2^15),[wy,wx]),[dirname './eigs/' fname '_eigU' num2str(evnI) '.png'],'BitDepth',16);
                csvwrite([dirname './eigs/' fname '_eigV' num2str(evnI) '.csv'], V(:,evnI));
                csvwrite([dirname './eigs/' fname '_eigS' num2str(evnI) '.csv'],S(evnI,evnI));
            end
        end
        if EVN==0
            EVNtxt= (inputdlg('Which Eigen Vector to use','EigenVector',1,{'2','1'}));
            EVN=str2num(EVNtxt{1});
        end
        
        res = zeros(16,1);
%         tic
%         for evnI = 1:16
%           res(evnI) = norm(reshape(data-reshape(U(:,1:evnI)*S(1:evnI,1:evnI)*V(:,(1:evnI))',size(data)),1, []))/norm(data(:))*100;
%         end
%         toc
        tic
        rdata=data;
        for evnI = 1:16
            rdata = rdata - reshape(U(:,evnI)*S(evnI,evnI)*V(:,(evnI))',size(data)); 
            res(evnI) = norm(reshape(rdata,1,[])) /norm(data(:))*100;
        end
        toc
        
        synProb = reshape(U(:,EVN),[wy,wx]);
        % EVN=1; %Eigen vector number
       % Thresholding is done later.
        % synapseBW = reshape(((U(:,EVN))>(std(U(:,EVN))*3)),wy,wx); % Assume first frame, the synapses do no peak. V(1,2) gives direction of 2nd U(:,2).
       % subplot(4,4,16);imagesc(synapseBW);colormap('gray');
        
        
        %% Read Eig
%         for evnI=1:16
%             p = imread([dirname './eigs/' fname '_eigU' num2str(evnI) '.png']);
%             U2(:,evnI) = ((double(p(:))-2^15)/length(p(:)));
%             V2(:,evnI) = csvread([dirname './eigs/' fname '_eigV' num2str(evnI) '.csv']);
%             S2(evnI,evnI) = csvread([dirname './eigs/' fname '_eigS' num2str(evnI) '.csv']);
%         end
%         
    %    pause();
        %  s  = regionprops(synapseBW(:,:),'PixelList','PixelIdxList');
            case 'STD'
                synProb= std(data,0,3);
                S=zeros(32:32);
        end    
    end


    function rmvBkGrnd(source,event,handles)
        subplot(4,4,16);
        tophat(); disp('tophat ipo freqfilter')
       % freqfilter2D();
       
       % Set the threshold.
       if sig2rb.Value      % Sigma 2 Radio Button
         setTvalue(mean(synProb(:))+2*std(synProb(:)));
       else
           if sig3rb.Value % Sigma 3 Radio Button
               setTvalue(mean(synProb(:))+3*std(synProb(:)));
           else
               if sigOthRB.Value % Other Sigma Radio Button
                   setTvalue(str2double(otherSigmaValueEdit.String));
               end
           end
       end
       
       
      %  setTvalue((std(synProb(:))*2));
        doThreshold(TValue);
        cleanBW();
        %savesubplot(4,4,16,[pathname '_mask']);
       % This is bin, mask=obsolete, new mask has numbers 
       % written later
       % imwrite(synapseBW,[pathname '_mask.png']);
        subplot(4,4,4);
    end
    function grayOutSettings(source,event,handles)
        if loadAnalysisChkButton.Value==1
            set( NOStxt,'enable', 'off');
            set(fpsTxt,'enable', 'off');
            set(stimFreqtxt,'enable', 'off');
            set(OnOffsettxt,'enable','off');
            set( NOStxt2,'enable', 'off');
            set(stimFreqtxt2,'enable', 'off');
            set(m.OnOffsettxt2,'enable','off');
              
                
                  
           
        else
            set(NOStxt,'enable','on');           
            set(fpsTxt,'enable','on');           
            set(stimFreqtxt,'enable','on');           
            set(OnOffsettxt,'enable','on');
            set( NOStxt2,'enable', 'on');
            set(stimFreqtxt2,'enable', 'on');
            set(m.OnOffsettxt2,'enable','on');
            
            
             
%             set(NOStxt,'BackgroundColor',bgc);
%             set(fpsTxt,'BackgroundColor',bgc);
%             set(stimFreqtxt,'BackgroundColor',bgc);
%             set(OnOffsettxt,'BackgroundColor',bgc);
           
        end
        drawnow();
        
    end
    function checkFixedThresholdValue(f,g,h)
        otherSigmaValueEdit.String=num2str(str2double(otherSigmaValueEdit.String));
    end
    function setTvalue(tvalue)
        TValue = tvalue;
        thresTxt.String = num2str(TValue);
    end
    function doThreshold(source,event,handles)
        TValue = str2double(thresTxt.String);
        synapseBW = synProb > TValue;
        imagesc(synapseBW);
        pause(.5);
    end
    function cleanBW(source,event,handles)
        if segmentCellBodies
            synapseBW = imerode(synapseBW,strel('disk',6));
            synapseBW = imdilate(synapseBW,strel('disk',6));
            warning('erode size hacked to 8')
        else
            disp('close sz 2 changed to 1 in cleanBW')
            synapseBW = imerode(synapseBW,strel('disk',1));
            synapseBW = imdilate(synapseBW,strel('disk',1));
        end
        imagesc(synapseBW);
        pause(.5);
    end
    function [Ub, Sb, Vb] = doeigy(source, event, handles)
        [Ub, Sb, Vb] = calcEigY(data);
    end
    function [Ub, Sb, Vb] = calcEigY(data)
        [U, S, V] = svd(reshape(data,[],size(data,3)),'econ');
        Ub=U;
        Sb=S;
        Vb=V;
        imageEigen(Ub,Sb,Vb);
    end
    function doImageEigen(source, event, handles)
        imageEigen(U,S,V);
    end
    function imageEigen(U,S,V)
        subplot(4,4,[2:3, 6:7]);
        imagesc(reshape(U(:,2),size(data,1),size(data,2)));colormap('gray');
        subplot(4,4,3);
        imagesc(reshape(U(:,1),size(data,1),size(data,2)));colormap('gray');
        title('eig 1')
        subplot(4,4,7);
        imagesc(reshape(U(:,2),size(data,1),size(data,2)));colormap('gray');
        title('eig 2')
        subplot(4,4,11);
        imagesc(reshape(U(:,3),size(data,1),size(data,2)));colormap('gray');
        title('eig 3')
        subplot(4,4,15);
        imagesc(reshape(U(:,4),size(data,1),size(data,2)));colormap('gray');
        title('eig 4')
        
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
        subplot(4,4,16);
        plot(V(:,4));
        title('eig 4')
    end
    function loadDefault(source,event,handles)
        pathname = 'E:\share\data\Rajiv\20171027\plate 1\row B\NS_120171027_105928_20171027_110118\NS_120171027_105928_e0006.tif';
        [data, pathname, fname, dirname] = loadTiff(pathname);
        wx = size(data,2); wy = size(data,1); wt = size(data,3);
        fNmTxt.String=fname;
        subplot(1,2,1);
        imagesc(data(:,:,1));
        colormap('gray')
        axis equal;
        axis off;
        title(fname)
    end
    function loadTiff22(source,event,handles)
        %global data;
        %global fNmTxt;
        
        title('loading')
        if (fastLoadChkButton.Value)
            [data, pathname, fname, dirname, U, S, V] = loadTiff([],fastLoadChkButton.Value);
            imageEigen(U,S,V); % Display Eigenvectors
        else
            [data, pathname, fname, dirname] = loadTiff([],fastLoadChkButton.Value);
        end
        disp(pathname);
        wx = size(data,2); wy = size(data,1);wt = size(data,3);
        fNmTxt.String=fname;
        dNmTxt.String=dirname;
        defaultDir=dirname;
        
        subplot(1,2,1);
        imagesc(data(:,:,1));
        colormap('gray')
        axis equal;
        axis off;
        title(fname)
    end
    function setDir(source,event)
        [dirname] = uigetdir(defaultDir,'Select the dir to process');
        dNmTxt.String = dirname;
    end
    function [data2, fname] = segment(source,event)
        %global data;
        
        subplot(4,4,[6:7,10:11]);
        mdata1=reshape(mean(linBleachCorrect(reshape(data,wx*wy,[])),2),[wy,wx]);
        mdata2=mean(data,3);
        
        %%% Show some data: Animate
        imagesc(mdata1);
        axis equal;
        axis off;
        title('Segmented')
        subplot(4,4,[8,12]);
        
        imagesc(mdata2);
        %imagesc(dff(mdata,3)));
        
        axis equal;
        axis off;
        title('Segmented')
    end
    function peakfinder(source,event)
        B=ordfilt2(reshape(U(:,1),wy,wx),9,ones(3,3)); % local max filter
        imagesc(B)
        %find()%waar maximum zit.
    end
    function processExperiment(source,event)
        processExperiment();
    end
    function batchLoader(source,event)
        B=ordfilt2(reshape(U(:,1),wy,wx),9,ones(3,3)); % local max filter
        imagesc(B)
        %find()%waar maximum zit.
    end



    function experimentLoader(source,event)
        global fNmTxt10APC fNmTxt1APC fNmTxt5M fNmTxt10M fNmTxt20M
        
        tmpDir =  defaultDir;
        f3 = figure('name','experiment Loader',...
            'NumberTitle','off');
        set(f3,'MenuBar', 'none'); % figure / none
        set(f3, 'ToolBar', 'auto');
        javaFrame = get(f3,'JavaFrame');
        javaFrame.setFigureIcon(javax.swing.ImageIcon('my_icon.png'));
        btn6 = uicontrol('Style', 'pushbutton', 'String', 'load 10AP Control',...
            'Position', [20 260 150 20],...
            'Callback', @load10APControl);
        fNmTxt10APC = uicontrol('Style', 'Text', 'String', 'no File loaded',...
            'Position', [175 260 200 20] );
        
        btn6b = uicontrol('Style', 'pushbutton', 'String', 'load 1AP Control',...
            'Position', [20 240 150 20],...
            'Callback', @load1APControl);
        fNmTxt1APC = uicontrol('Style', 'Text', 'String', 'no File loaded',...
            'Position', [175 240 200 20] );
        btn7 = uicontrol('Style', 'pushbutton', 'String', 'load 5min',...
            'Position', [20 220 150 20],...
            'Callback', @load5min);
        fNmTxt5M = uicontrol('Style', 'Text', 'String', 'no File loaded',...
            'Position', [175 220 200 20] );
        btn8 = uicontrol('Style', 'pushbutton', 'String', 'load 10min',...
            'Position', [20 200 150 20],...
            'Callback', @load10min);
        fNmTxt10M = uicontrol('Style', 'Text', 'String', 'no File loaded',...
            'Position', [175 200 200 20] );
        btn9 = uicontrol('Style', 'pushbutton', 'String', 'load 20min',...
            'Position', [20 180 150 20],...
            'Callback', @load20min);
        fNmTxt20M = uicontrol('Style', 'Text', 'String', 'no File loaded',...
            'Position', [175 180 200 20] );
        
        btn10 = uicontrol('Style', 'pushbutton', 'String', 'processExperiment',...
            'Position', [20 130 150 50],...
            'Callback', @processExperiment);
        
        
        %B=ordfilt2(reshape(U(:,1),512,512),9,ones(3,3)); % local max filter
        %imagesc(B)
        %find()%waar maximum zit.
        
        function load10APControl(source,event)
            [C10Data, C10pathname, C10fname, C10dirname] = loadTiff();
            fNmTxt10APC.String = C10fname;
            defaultDir = C10dirname;
        end
        
        
        function load1APControl(source,event)
            [C1Data, C1pathname, C1fname, C1dirname] = loadTiff();
            fNmTxt1APC.String = C1fname;
            defaultDir = C1dirname;
        end
        function load5min(source,event)
            [M5data, M5pathname, M5fname, M5dirname] = loadTiff();
            fNmTxt5M.String = M5fname;
            defaultDir = M5dirname;
        end
        function load10min(source,event)
            [M10data, M10pathname, M10fname, M10dirname] = loadTiff();
            fNmTxt10M.String = M10fname;
            defaultDir = M10dirname;
        end
        function load20min(source,event)
            [M20data, M20pathname, M20fname, M20dirname] = loadTiff();
            fNmTxt20M.String = M20fname;
            defaultDir = M20dirname;
        end
        
        function processExperiment(source,event)
            % segment based on 10AP
            % extract signals from synpses
            % Extract control 1AP synsignals
            % Extract 5 min 1AP synsiglas
            % Extract 10 min 1AP synsignals
            % Extract 20 min 1AP synsignals
            
        end
    end


    function keyPress(src, e)
        disp(e.Key);
        switch e.Key
            case 'p' 
                disp('starting doProcessing');
                doProcessDir();
                
            case 'd'
                disp('starting doProcessing');
                doProcessDir();
                
        end
    end
    function avgSynapseResponse(source,ev)
        
     % Some pixel averages:
        rAR = mean(reshape(data,wx*wy,[]),1); % Average over all pixels, average Response
        dd=mean(reshape(data,wx*wy,[]),1);
        mdd=multiResponseto1(dd,0);
        AR = dff(dd); % Average over all pixels, average Response
        [TSpAPA , TSpAPAi] = max(mdd); %Temporal spike Averaged Pixel Amplitude
        
        
        nSynapses = size(synsignal,2);
        hold off
     
        if ~isempty(synsignal)
            ASR = mean(dff(synsignal'),1); % Average over all synapses
            
%                imageMetrics(5).name = 'Temporal spike Averaged Pixel Amplitude';
        
%         imageMetrics(5).value= TSpAPA;
%         imageMetrics(6).name = 'Temporal spike Averaged Pixel Amplitude Index';
%         imageMetrics(6).value= TSpAPAi;
            
            
            disp('AR1 disabled in AVGSynapseResponse ;') ; AR1=AR*0;%      AR1 = mean(dff(reshape(data,wx*wy,[]),1)); % Average over all pixels, average Response
            
           
            stdSR = std(dff(synsignal'),1); %stdSR for all points in time
            mstdSR = max(stdSR);
            
            synapseSize=zeros(1,length(synRegio));
            for i=1:length(synRegio)
                synapseSize(i)=length(synRegio(i).PixelList);
            end
            
            swASR = sum(repmat(synapseSize',1,size(synsignal,1)) .*  dff(synsignal'),1)/sum(synapseSize); % size weighted average over all synapses
      
            
        else
            ASR=zeros(1,size(synsignal,1));
            AR=zeros(1,size(synsignal,1));
            stdSR = zeros(1,size(synsignal,1));
            mstdSR = 0;
            swASR = zeros(1,size(synsignal,1));
            AR1=zeros(1,size(synsignal,1));
            invalidate();
        end
        tvec = (dt*(1:size(ASR,2))');
        r = [tvec,ASR',AR',swASR',rAR',AR1'];
        t = array2table(r,'VariableNames',{'time','SynapseAverage',...
            'PixelAverage','SWSynapseAverage','rawAverageResponse','AverageResponse1'});
        writetable(t,[dirname 'output\' fname(1:end-4) '_traces.csv']);
    end

    function analyseSingSynResponse(s,e,v)
    %    stimulationStartTime = 1.0;
    %    stimulationStartFrame = floor(stimulationStartTime /dt);
    
    % Initialise output variables for when there are no synapses found.
    mSigA=nan; miSigA=nan; synapseSize=nan; noiseSTD=nan; aboveThreshold=nan; UpHalfTime=nan;    DownHalfTime=nan;    tau1=nan;
    amp=nan;      error=nan; xCentPos=nan; yCentPos=nan; synapseNbr=nan; bbox=[nan,nan,nan,nan]; AUC=nan; nAUC=nan;
    rawBaseFluor=nan; rawMaxFluor=nan; rawDFluor=nan; rawDFF=nan;
    
    dffsynsignal=dff(synsignal')';
        for i=1:size(dffsynsignal,2)
            if isempty(synsignal)
            	rawFoldedData=nan*ones(size(dffsynsignal)); %When no synapses
                centre = nan;
            xCentPos(i) = nan;
            yCentPos(i) = nan;
            bbox(i,1:2)= nan;
            bbox(i,3:4)= nan;
            synapseSize(i) = nan;
        
            else
                rawFoldedData=mean(foldData(synsignal(:,i)),2);
                centre = mean(synRegio(i).PixelList,1);
            xCentPos(i) = centre(2); 
            yCentPos(i) = centre(1);
            bbox(i,1:2)=max(synRegio(i).PixelList,[],1);
            bbox(i,3:4)=min(synRegio(i).PixelList,[],1);
            synapseSize(i) = length(synRegio(i).PixelList);
        
            end
            
            if size(rawFoldedData)>=30
                rawBaseFluor(i) = mean(rawFoldedData(1:30));
            else
                rawBaseFluor(i) = mean(rawFoldedData(:));
            end
            rawMaxFluor(i)= max(rawFoldedData);
            rawDFluor(i) = rawMaxFluor(i)-rawBaseFluor(i);
            rawDFF(i) = rawDFluor(i)/rawBaseFluor(i);
            
            signal = dffsynsignal(:,i);
            synapseNbr(i) = i;
            
            
            
            signal = multiResponseto1(signal,0);
            [mSig, miSig] = max(signal,[],1); % Find max ampl of the Average Synaptic Response
            mSigA(i)=mSig;
            miSigA(i)=miSig;
            AUC(i) = sum((signal>0).*signal);
            nAUC(i) = sum((signal<0).*signal);
            noiseSTD(i) = std(signal(1:5)); % Calculate noise power (std).
            aboveThreshold(i) = mSig>(2*noiseSTD(i));
            
            
       %     upframes = miSig-stimulationStartFrame;
       %     upResponse = signal(stimulationStartFrame:miSig);
       %     expdata.x = (0:(length(upResponse)-1))*dt;
       %     expdata.y = upResponse;
            %[expEqUp, fitCurve1] = curveFitV1(expdata,[.22 100 0 2 -1 2]);
            
            
            if 1 %length(expdata.x(:))<=4000000
                expEqUp =[0 0 0 0] ;
         %       disp(['No synapse up kinetcis fit for: ' fname 'Synapse' num2str(i)]);
                tau1(i)=0; amp(i)=0; t0(i)=0;
            else
                [tau1(i), amp(i), t0(i)] = exp1fit(expdata.x,expdata.y);
                %            [fitCurve1] = fit(expdata.x(:),expdata.y(:),'exp2');%[.22 100 0 2 -1 2]);
                %            expEqUp = coeffvalues(fitCurve1);
                hold on;
                %plot(miASR*dt+expdata.x, amp*exp(-expdata.x/tau1));
                plot(miSig*dt+t0+expdata.x, amp*exp(-expdata.x/tau1));
                %temp.     plot(expdata.x+stimulationStartTime, fitCurve1(expdata.x));
            end
            %downResponse = ASR(miASR:miASR+floor(3.0/dt));
            downResponse = signal(miSig:end);
            expdata.x = (0:(length(downResponse)-1))*dt;
            expdata.y = downResponse;
            %[expEqDown, fitCurve2] = curveFitV1(expdata,[0 1 0 2 1 2]);
            
            if length(expdata.x(:))<=4
                expEqDown =[0 0 0 0] ;
                disp(['No down kinetics fit for: ' fname]);
                tau1(i)=0; amp(i)=0;t0(i)=0;
            else
                [tau1(i), amp(i), t0(i)] = exp1fit(expdata.x,expdata.y);
                %            [fitCurve2] = fit(expdata.x(:),expdata.y(:),'exp2');
                %            expEqDown = coeffvalues(fitCurve2);
%                 hold off;
%                 %plot(miASR*dt+expdata.x, fitCurve2(expdata.x));
%                 %plot(miASR*dt+expdata.x, amp*exp(-expdata.x/tau1));
%                 plot(miSig*dt+expdata.x,expdata.y);
%                 hold on;
%                 plot(miSig*dt+t0(i)+expdata.x, amp(i)*exp(-expdata.x/tau1(i)));
%                 drawnow();%pause(.5)
            end
        end
        UpHalfTime=tau1*0; DownHalfTime=tau1*0;
        error=tau1*0;
        
        t =     array2table([...
            mSigA'     miSigA' synapseSize' noiseSTD' aboveThreshold' ...
            UpHalfTime'    DownHalfTime'    tau1'    amp'      error',...
            xCentPos', yCentPos', synapseNbr', bbox(:,2), bbox(:,1),...
            bbox(:,4), bbox(:,3), AUC', nAUC', rawBaseFluor',...
            rawMaxFluor', rawDFluor', rawDFF',...
        synSTD.spaceTimeSTD'  synSTD.spaceMeanTimeSTD' synSTD.meanSpaceTimeSTD' ...
         synSTD.synProbSTD'  synSTD.laplaceSynProbSTD'  ...
         ],...
            'VariableNames',{'maxSyn', 'miSyn', 'synapseSize', 'noiseSTD', 'aboveThreshold', 'UpHalfTime', 'downHalfTime', 'tau1', 'ampSS', 'error','xCentPos','yCentPos', 'synapseNbr', 'bboxUx','bboxUy','bboxDx','bboxDy','AUC','nAUC', 'rawBaseFluor', 'rawMaxFluor', 'rawDFluor', 'rawDFF'...
             'spaceTimeSTD',  'spaceMeanTimeSTD', 'meanSpaceTimeSTD', 'synProbSTD', 'laplaceSynProbSTD'});
        
        if(~isdir ([dirname 'output\']))
            mkdir ([dirname 'output\']);
        end
        if (~isdir ([dirname 'output\SynapseDetails']))
            mkdir ([dirname 'output\SynapseDetails']);
        end
        writetable(t,[dirname 'output\SynapseDetails\' fname(1:end-4) '_synapses']);
        disp([dirname 'output\SynapseDetails\' fname(1:end-4) '_synapses.txt']);disp(['created']);
        
    end
    function analyseAvgResponse(s,e)
        % Amplitude
        error =0; % Indicates if something was wrong with the data or dataprocessing
        [mASR, miASR] = max(ASR); % Find max ampl of the Average Synaptic Response
        [mswASR, miswASR] = max(swASR); % Find max ampl of the Average Synaptic Response
        [mAR, miAR] = max(AR); % Find max ampl of the Average Response
        
        stimulationStartTime = 1.0;
        stimulationStartFrame = floor(stimulationStartTime /dt);
        
        pause(.5);
        subplot(4,4,8)
        cla
        plot(dt*(((1:length(ASR))-1)), ASR);
     % If you want to see the pixel average
     % hold on;
     % plot(dt*(((1:length(AR))-1)), AR);
        xlabel(['Time(s) (' num2str(fps) 'fps)'])
        ylabel('\Delta F/F0');
        title('Analysis')
        text(miASR/fps,mASR*1.05 ,['max: ' num2str(mASR)],'HorizontalAlignment','center');
        % Area under the curve
        AUC = sum(ASR.*(ASR>0));        
        nAUC = sum(ASR.*(ASR<0));
        TempSynSTD = std(ASR);
        text(miASR/fps,mASR*0.7 ,{'AUC:', num2str(AUC)},'HorizontalAlignment','center');
        
        
%         Calculate Pixel averaged kinetics
%         upframesPA = miAR-stimulationStartFrame;
%         upResponsePA = AR(stimulationStartFrame:miAR);
%         expdataPA.x = (0:(length(upResponsePA)-1))*dt;
%         expdataPA.y = upResponsePA;

        downResponse = AR(miAR:end); %Average Response
        expdataPA.x = (0:(length(downResponse)-1))*dt;
        expdataPA.y = downResponse;
        
        [tau1PA, ampPA, t0PA] = exp1fit(expdataPA.x,expdataPA.y); % (PA)Pixel Average
        if isempty(tau1PA)
            tau1PA=0;
            error=1;
        end
        if isempty(t0PA)
            t0PA=0;
            error=1;
        end
        
        
        AUCPA = sum(AR.*(AR>0)); % Area under curve Pixel Average
        nAUCPA = sum(AR.*(AR<0)); % negative values Area Under Curve Pixel average
     
        
        % Calculate Synapse averaged kinetics
        upframes = miASR-stimulationStartFrame;
        upResponse = ASR(stimulationStartFrame:miASR);
        expdata.x = (0:(length(upResponse)-1))*dt;
        expdata.y = upResponse;
        %[expEqUp, fitCurve1] = curveFitV1(expdata,[.22 100 0 2 -1 2]);
        
        if length(expdata.x(:))<=4000000
            expEqUp =[0 0 0 0] ;
            % disp(['No up kinetcis fit for: ' fname]);
            tau1=0; amp=0;
        else
            [tau1, amp, t0] = exp1fit(expdata.x,expdata.y);
            %            [fitCurve1] = fit(expdata.x(:),expdata.y(:),'exp2');%[.22 100 0 2 -1 2]);
            %            expEqUp = coeffvalues(fitCurve1);
            hold on;
            %plot(miASR*dt+expdata.x, amp*exp(-expdata.x/tau1));
            plot(miASR*dt+t0+expdata.x, amp*exp(-expdata.x/tau1));
            %temp.     plot(expdata.x+stimulationStartTime, fitCurve1(expdata.x));
        end
        %downResponse = ASR(miASR:miASR+floor(3.0/dt));
        downResponse = ASR(miASR:end);
        expdata.x = (0:(length(downResponse)-1))*dt;
        expdata.y = downResponse;
        %[expEqDown, fitCurve2] = curveFitV1(expdata,[0 1 0 2 1 2]);
        
        if length(expdata.x(:))<=4
            expEqDown =[0 0 0 0] ;
            disp(['No down kinetics fit for: ' fname]);
            tau1=0; amp=0;
        else
            [tau1, amp, t0] = exp1fit(expdata.x,expdata.y);
            %            [fitCurve2] = fit(expdata.x(:),expdata.y(:),'exp2');
            %            expEqDown = coeffvalues(fitCurve2);
            hold on;
            %plot(miASR*dt+expdata.x, fitCurve2(expdata.x));
            %plot(miASR*dt+expdata.x, amp*exp(-expdata.x/tau1));
            plot(miASR*dt+t0+expdata.x, amp*exp(-expdata.x/tau1));
        end
        
        %% First order exponentials:
        % Kinetics:
        % UP
        upIC50 = find(ASR>(mASR/2),1,'first');
        if length(upIC50)~=1 % Detect problems when no spike is detected.
            UpHalfTime=nan;
            upFrames=nan;
            upIC50=nan;
            upIC50=nan;
            
        else
            if upIC50<2 % Detect if spike is in first frame.
                upIC50=2;
                % Omit first part and try again:
                upIC50 = 15-1+find(ASR(15:end)>(mASR/2),1,'first');
                
                warning(['spontanious activity in: ' fname ' de-stabilised UP Spike Rate detection'])
            end
            if length(upIC50)~=1 % Detect problems when no spike is detected.
                UpHalfTime=0;
                upFrames=1;
                upIC50=2;
                error=1;
            else
                framePart = (mASR/2-ASR(upIC50-1)) / (ASR(upIC50)-ASR(upIC50-1)) * 1; % Lin. interpolat betwen frames
                upFrames = upIC50 -1 +framePart -1;
                UpHalfTime = upFrames * dt;
                % text(UpHalfTime,mASR*0.5 ,['UP_{50}: ' num2str(UpHalfTime)],'HorizontalAlignment','right');
                if length(UpHalfTime)~=1
                    disp('something weird is happenning');
                    %   dbstop;
                end
                %text(UpHalfTime,0.0 ,{'UP_{50}: ', [num2str(UpHalfTime) 's']},'HorizontalAlignment','Left','VerticalAlignment','Top','FontSize',8,'Rotation',-45);
                % text(UpHalfTime,0.0 ,{[num2str(UpHalfTime) 's']},'HorizontalAlignment','Left','VerticalAlignment','Top','FontSize',8,'Rotation',-45);
            end
        end
        
        % Down
        downIC50 = find(ASR>(mASR/2),1,'last');
        if length(downIC50) == 0
            miASR=nan;
            DownHalfTime=nan;
            downFrames=nan;
            framePart=nan;
        else
            if downIC50 == length(ASR)
                downIC50 = downIC50 -1;
                disp(['Down slope in:' fname ' is not finished before end.' ] )
            end
            framePart = (mASR/2-ASR(downIC50+1)) / (ASR(downIC50)-ASR(downIC50+1)) * 1; % Lin. interpolat between frames
            downFrames = downIC50 + 1 - framePart -1;
            DownHalfTime = downFrames * dt;
            %text(DownHalfTime,mASR*0.5 ,['DOWN_{50}: ' num2str(DownHalfTime)],'HorizontalAlignment','left');
            %text(DownHalfTime,0.0 ,{'DOWN_{50}: ', [num2str(DownHalfTime) 's']},'HorizontalAlignment','left','VerticalAlignment','Top','FontSize',8,'Rotation',-45);
            text(DownHalfTime,0.0 ,{ ['    ' num2str(DownHalfTime) 's']},'HorizontalAlignment','left','VerticalAlignment','Bottom','FontSize',8,'Rotation',-45);
            
            %text(miASR*dt,0.0 ,{'T_{max}: ', [num2str(miASR*dt) 's']},'HorizontalAlignment','left','VerticalAlignment','Top','FontSize',8,'Rotation',-45);
            text(miASR*dt,0.0 ,{ [num2str(miASR*dt) 's']},'HorizontalAlignment','left','VerticalAlignment','Top','FontSize',8,'Rotation',-45);
        end
        
        % Lines
        
        hold on;
        plot([UpHalfTime DownHalfTime],[mASR mASR],'color',0.3*[1 1 1]); % Top line
        plot([UpHalfTime UpHalfTime ],[mASR 0],'color',0.3*[1 1 1]); % Up line
        plot([DownHalfTime DownHalfTime],[mASR 0],'color',0.3*[1 1 1]); % Down line
        plot([(miASR-1)/fps (miASR-1)/fps],[mASR 0],'color',0.3*[1 1 1]); % Max vert line
        plot([0 (length(ASR)-1)/fps],[0 0],'color',0.0*[1 1 1]); % X axis
        %% Fit exponentials:
        if 0
            % Down: Goes to 0 and take 50% point.
            plot(miASR*dt+(0:100)*dt,mASR*exp(-(0:100)*dt/DownHalfTime/exp(-.5)/.5),'r');
            
            % Up: Use 50% and total amplitude point.
            %plot(1+(0:100)*dt,mASR*1.3*(1-exp(-(0:100)*dt/UpHalfTime/.606*2)),'r');
            % Find exp amplitude term
            UpHalfTime/exp(-.5)/.5;
            % plot(1+(0:100)*dt, mASR*(1-exp(-(0:100)*dt/UpHalfTime/exp(-.5)/.5)),'r');
            ampSS = (1-exp(-miASR*dt/UpHalfTime/exp(-.5)/.5));
            %  plot(1+(0:100)*dt, ampSS*(1-exp(-(0:100)*dt/UpHalfTime/exp(-.5)/.5)),'r');
            
            
            tau1 = -(UpHalfTime-1)/log(-mASR/2 /ampSS +1);
            % plot(1+(0:100)*dt,ampSS*(1-exp(-(0:100)*dt/tau1)),'k');
            
            ampSS = mASR/(1-exp(-((miASR-1)*dt-1)/tau1)) ;
            %plot(1+(0:100)*dt,ampSS*(1-exp(-(0:100)*dt/tau1)),'c');
            
            for i=1:100 %OK, this is stupid slow implementation, but it works.
                tau1 = -(UpHalfTime-1)/log(-mASR/2 /ampSS +1) ;
                ampSS = mASR/(1-exp(-((miASR-1)*dt-1)/tau1)) ;
            end
            nCurvePoints=(2*(miASR-upIC50));
            % Subplot(4,4,15)
            plot(stimulationStartTime + (0:nCurvePoints)*dt,ampSS*(1-exp(-(0:nCurvePoints)*dt/tau1)),'m');
            % Tau1
            text(4,ampSS ,{'( \tau_1, A_{SS} )', [ '(' num2str(tau1) 's, ' num2str(ampSS) ')' ]},'HorizontalAlignment','center','VerticalAlignment','Middle','FontSize',12,'Rotation',90);
            
        end
        
        %% Image Metrics
        imageMetrics=calcImageMetrics(data);
        
        
        %% res metric
        resNames=[];
        SNames=[];
        for i=1:16
            resNames{i} = ['res' num2str(i)];
            SNames{i} = ['S' num2str(i)];
        end
        %% Export analysis data
        savesubplot(4,4,8,[pathname '_analysis']);
        if isempty(res)
            res=nan*zeros(16,1);
        end
         if isempty(S)
            S=nan*zeros(16,16);
        end
        try
        t =array2table([...
            mASR mstdSR miASR  mswASR ...
            miswASR fps UpHalfTime DownHalfTime tau1 amp ...
            nSynapses AUC nAUC tau1PA ampPA t0PA RSTmean ...
            RSTABSmean error TempSynSTD ...
            TSpAPA TSpAPAi ...
            ,[imageMetrics.value], res' diag(S(1:16,1:16))'],...
            'VariableNames',{...
            'peakAmp', 'mstdSR', 'miASR', 'sizeWeightedMASR', ...
            'swmiASR', 'fps', 'UpHalfTime', 'downHalfTime', 'tau1', 'ampSS', ...
            'nSynapses','AUC','nAUC' , 'tau1PA', 'ampPA', 't0PA' ,'RSTmean',...
            'RSTABSmean','error','TempSynSTD',...
            'TSpAPA', 'TSpAPAi'...
             imageMetrics.name resNames{:} SNames{:}} );
        catch
            error('no analysis file could be created.')
        end
        %t =array2table([mASR miASR fps UpHalfTime DownHalfTime expEqUp expEqDown error ],'VariableNAmes',{'mASR', 'miASR', 'fps', 'UpHalfTime', 'downHalfTime', 'expEqy0', 'upA1', 'upx0', 'upT1', 'expEqdwny0', 'dwnA1', 'dwnx0', 'dwnT1','error'});
        %t =array2table([mASR miASR fps UpHalfTime DownHalfTime expEqUp expEqDown ],'VariableNAmes',{'mASR', 'miASR', 'fps', 'UpHalfTime', 'downHalfTime', 'expEqy0', 'upA1', 'upx0', 'upT1', 'upA2', 'upT2', 'expEqdwny0', 'dwnA1', 'dwnx0', 'dwnT1', 'dwnA2', 'dwnT2'});
        if ~isdir([dirname 'output\']);
            mkdir ([dirname 'output\']);
        end
        writetable(t,[dirname 'output\' fname(1:end-4) '_analysis']);
        disp([dirname 'output\' fname(1:end-4) '_analysis.txt']);disp([ 'created']);
        subplot(4,4,15)
        
    end


 function imageMetrics=calcImageMetrics(data)  
        %% Image Metrics
        Tavg = mean(data,3);
        imageMetrics(1).name = 'SpatSTD';
        imageMetrics(1).value=  std(Tavg(:));
        imageMetrics(2).name = 'LapSpatSTD';
        lap = double(locallapfilt(uint16(Tavg),0.3,0.1));
        imageMetrics(2).value= std(lap(:));
        imageMetrics(3).name = 'SpatTempSTD';
        imageMetrics(3).value= std(data(:));
        imageMetrics(4).name = 'PATempSTD';
        imageMetrics(4).value= std(AR);
        
        % Focus measures:
        
        
        
        fmeasureMethods={...
'ACMO'... %: Absolute central moment (Shirvaikar2004)
'BREN'... %: Brenner's focus measure (Santos97)
'CONT'... %: Image contrast (Nanda2001)
'CURV'... %: Image curvature (Helmli2001)
'DCTE'... %: DCT Energy measure (Shen2006)
'DCTR'... %: DCT Energy ratio (Lee2009)
'GDER'... %: Gaussian derivative (Geusebroek2000)
'GLVA'... %: Gray-level variance (Krotkov86)
'GLLV'... %: Gray-level local variance (Pech2000)
'GLVN'... %: Gray-level variance normalized (Santos97)
'GRAE'... %: Energy of gradient (Subbarao92)
'GRAT'... %: Thresholded gradient (Santos97)
'GRAS'... %: Squared gradient (Eskicioglu95)
'HELM'... %: Helmli's measure (Helmli2001)
'HISE'... %: Histogram entropy (Krotkov86)
'HISR'... %: Histogram range (Firestone91)
'LAPE'... %: Energy of Laplacian (Subbarao92)
'LAPM'... %: Modified laplacian (Nayar89)
'LAPV'... %: Variance of laplacian (Pech2000)
'LAPD'... %: Diagonal Laplacian (Thelen2009)
'SFIL'... %: Steerable filters-based (Minhas2009)
'SFRQ'... %: Spatial frequency (Eskicioglu95)
'TENG'... %: Tenegrad (Krotkov86)
'TENV'... %: Tenengrad variance (Pech2000)
'VOLA'... %: Vollat's correlation-based (Santos97)
...%'WAVS'... %: Wavelet sum (Yang2003)
...%'WAVV'... %: Wavelet variance (Yang2003)
...%'WAVR'... %: Wavelet ratio (Xie2006)
            };
        
        for i=1:length(fmeasureMethods)
        imageMetrics(4+i).name = ['FM_' fmeasureMethods{i}];
        imageMetrics(4+i).value= nan;%fmeasure(Tavg,fmeasureMethods{i})
        
        end
        disp('metrics disabled l:1879');
        pause(1);
        
 end
     
    function freqfilter2D(s,e)
        % Remove slow changing gradients over field of view
        % Typically a result from less lightning by the lens.
        
        sz=20; %%This should be based on picture width, pixel resolution
        st2x=wx-sz;
        st2y=wy-sz;
        %EVN=1;
        
        ffU2 = fft2(synProb);
        ffU2(1:sz,1:sz)=0;
        ffU2(st2y:wy,1:sz)=0;
        ffU2(st2y:wy,st2x:wx)=0;
        ffU2(1:sz,st2x:wx)=0;
        
        % Remove Noise, while we're at it.
        
        sz=50; %This should be based on picture width, pixel resolution
        %st2=512/2-sz;
        
        %         ffU2(sz:(512/2),sz:512/2)=0;
        %         ffU2(sz:(512/2),(512/2):(st2+512/2))=0;
        %         ffU2((512/2):(st2+512/2),(512/2):(st2+512/2))=0;
        %         ffU2((512/2):(st2+512/2),sz:(512/2))=0;
        
        ffU2(1:wy,sz:(wx-sz))=0;
        ffU2(sz:(wy-sz),1:wx)=0;
        
        GG = fftshift(ffU2);
        beta = 4; % roughly equivalent to Hann
        w = kaiser(size(GG,1),beta);
        % wKspLR = w .* kspLR;  % may work directly if you have R2016b or later.
        GG = bsxfun(@times, w, GG);
        
        w = kaiser(size(GG,2),beta);
        % wKspLR = w .* kspLR;  % may work directly if you have R2016b or later.
        GG = bsxfun(@times, w, GG');
        GG = GG';
        ffU2 = ifftshift(GG);
        
        
        U22=real(ifft2(ffU2));
        
        % imagesc(abs(ffU2));
        imagesc(U22);
        % synapseBW = U22<-2e-3;
        
        synProb = U22;
        %    synProb = (-1*(sign(V(1,EVN)).*synProb));
    end

%%    
%    function processDirs(s,e,h)
%         %    [C10dirname] = uigetdir(defaultDir,'Select dir containing dirs to process:');
%         %    [C10dirname] = uigetdir(defaultDir,'Select dir containing dirs to process:');
%         
% %         batchDirs={
% %  'F:\share\toBeProcessed\GCAMP\NS_1120180504_155551_20180504_161603'
% %  'F:\share\toBeProcessed\GCAMP\NS_120180504_141003_20180504_143006'
% %  'F:\share\toBeProcessed\GCAMP\NS_1220180504_162547_20180504_164558'
% %  'F:\share\toBeProcessed\GCAMP\NS_1320180504_165538_20180504_171554'
% %  'F:\share\toBeProcessed\GCAMP\NS_1520180507_100016_20180507_101948'
% %  'F:\share\toBeProcessed\GCAMP\NS_6520180427_151013_20180427_152959'
% %  'F:\share\toBeProcessed\GCAMP\NS_6720180427_154455_20180427_160356'
% %  'F:\share\toBeProcessed\GCAMP\NS_6920180427_161455_20180427_163503'
% %  'F:\share\toBeProcessed\GCAMP\NS_820180504_151837_20180504_153852'
% %             };
% %       
% %         for i=1:length(batchDirs)
% %             processDir(batchDirs{i});
% %         end
% 
%         [C10dirname] = uigetdir(defaultDir,'Select dir containing dirs to process:');
%         batchDirs  = dir(C10dirname);
%         batchDirs(1)=[];
%         batchDirs(1)=[];
%         
%         for i=1:length(batchDirs)
%             if isdir([batchDirs(i).folder '\' batchDirs(i).name])
%                 processDir([batchDirs(i).folder '\' batchDirs(i).name]);
%             end
%         end
%     end
%%
   
    function doProcessDir(s,e,h)
        try
            [dataDirname] = uigetdir(defaultDir,'Select dir:');
        catch
            %For when defaultDir is cleared
            [dataDirname] = uigetdir([],'Select dir:');            
        end
        if dataDirname~=0
            processDirAndSubDirs(dataDirname);
        end
    end

    function processDirAndSubDirs(dataDirname)
    
        defaultDir =  [dataDirname '\..'];
        if 1 %Overwrite, default godeepBehaviour, do all subdirs 
            goAllSubDir(@processDir,'*.tif',dataDirname);
        else
            if isempty(dir([dataDirname '\*.tif']))
                dd= dir([dataDirname '\*.*']);
                dd(~[dd.isdir])=[]; % remove files, keep subdirs
                for  i=1:(length(dd)-2) % remove . and ..
                    if isempty(dir([dataDirname '\' dd(i+2).name '\*.tif']))
                        ddd= dir([dataDirname '\' dd(i+2).name '\*.*']);
                        ddd(~[ddd.isdir])=[]; % remove files, keep subdirs
                        for  ii=1:(length(ddd)-2) % remove . and ..
                            if isempty(dir([dataDirname '\' dd(i+2).name '\' ddd(ii+2).name '\*.tif']))
                                dddd= dir([dataDirname '\' dd(i+2).name '\' ddd(ii+2).name '\*.*']);
                                dddd(~[dddd.isdir])=[]; % remove files, keep subdirs
                                for  iii=1:(length(dddd)-2) % remove . and ..
                                    if isempty(dir([dataDirname '\' dd(i+2).name '\' ddd(ii+2).name '\' dddd(iii+2).name '\*.tif']))
                                    else
                                        processDir([dataDirname '\' dd(i+2).name '\' ddd(ii+2).name '\' dddd(iii+2).name]);
                                    end
                                end
                            else
                                processDir([dataDirname '\' dd(i+2).name '\' ddd(ii+2).name]);
                            end
                        end
                    else
                        processDir([dataDirname '\' dd(i+2).name]);
                    end
                end
            else
                processDir(dataDirname);
            end
        end
    end

    function [isProcessed, currentfolder]=writeProcessStart(expnm,iii,currentfolder)
        % Visualise we do new experiment.
        if (~strcmp(expnm{iii}.folder,currentfolder) )
            mkdir([expnm{iii}.folder '\process\']);
            currentfolder=expnm{iii}.folder;
        end
        if (~isfile([expnm{iii}.folder '\process\process_' expnm{iii}.name '.txt']))
            fid =fopen([expnm{iii}.folder '\process\process_' expnm{iii}.name '.txt'],'w');
            cl = clock;
            fprintf(fid,['S3T: ' Version  ' \n start: '  num2str(cl(1)) '-' num2str(cl(2)) '-' num2str(cl(3)) ' ' num2str(cl(4)) ':' num2str(cl(5)) ':' num2str(cl(6)) '\r\n']);
            fclose(fid);
            isProcessed=0;
        else
            isProcessed=1;
        end
    end

    function writeAnalysisStart(expnm,iii,analysisName)
        % Visualise we do new experiment.
        fid =fopen([expnm{iii}.folder '\process\process_' expnm{iii}.name '.txt'],'a');
        cl = clock;
        fprintf(fid,['start Analysis: '  analysisName ': ' num2str(cl(1)) '-' num2str(cl(2)) '-' num2str(cl(3)) ' ' num2str(cl(4)) ':' num2str(cl(5)) ':' num2str(cl(6)) '\r\n']);
        fclose(fid);
    end

    function processDir(datadirname)
        % [C10dirname] = uigetdir(defaultDir,'Select control 10AP dir:');
        defaultDir =  [datadirname '\..'];
        experiments = dir([datadirname '\*.tif']);
        
        experiments=experiments(~([experiments.isdir])); %remove dir called *.tif from list
        if ~isempty(experiments) % only process when tif files are found
            dNmTxt.String = datadirname;
            for ii = 1:length(experiments )
                %ee = num2str(100+experiments(ii));ee = ee(2:3); % To make 01,02, 03, .. 10, 11
                expnm{ii} = dir ([datadirname '\' experiments(ii).name]);
            end
            
            
            if (~isdir([expnm{1}.folder '\process\']))
                mkdir([expnm{1}.folder '\process\']);
            end
            currentfolder=expnm{1}.folder;
            
            for EID = 1:length(experiments) %=tif files
                [isProcessed, currentfolder]=writeProcessStart(expnm,EID,currentfolder);
                if  ~isProcessed
                    % Load the data
                    fNmTxt.String=['loading..' expnm{EID}.name];
                    if fastLoadChkButton.Value
                        [data, pathname, fname, dirname,U,S,V,invalidFileError] = loadTiff([expnm{EID}.folder '\' expnm{EID}.name],fastLoadChkButton.Value );
                        imageEigen(U,S,V);
                        synProb = reshape(U(:,EVN),[wy,wx]);
                    else
                        [data, pathname, fname, dirname,~,~,~,invalidFileError] = loadTiff([expnm{EID}.folder '\' expnm{EID}.name],fastLoadChkButton.Value );
                    end
                    if size(data,3)<2
                        invalidFileError=1;
                        disp('This file is not a movie, but a picture.')
                    end
                    if   ~invalidFileError
                        defaultDir = dirname;
                        dNmTxt.String = defaultDir;
                        wx = size(data,2); wy = size(data,1);
                        fNmTxt.String=fname;
                        pause(.01);
                        
                        %% Check for analysis files:
                        if (loadAnalysisChkButton.Value==1)
                            if ~isempty(dir( [pathname(1:end) '*_Analysis.xml']))
                                % Check if there is a special Analysis needed for this
                                % file.
                                analysisList = dir( [pathname(1:end) '*_Analysis.xml']);
                            else %Look if there are default analysis file in the dir.
                                k=strfind(pathname,'\');
                                kk=k(end);
                                
                                % If no special analysis, use default ones in dir.
                                if ~isempty(dir( [pathname(1:kk) '*_Analysis.xml']))
                                    analysisList = dir( [pathname(1:kk) '*_Analysis.xml']);
                                else
                                    %error
                                    warning('Sorry could not find analysis file.\n Processing aborted...');
                                    disp(['   ' pathname(1:end)]);
                                    pause(10);
                                    analysisList=[];
                                    writeProcessFail(expnm,EID,'Sorry could not find analysis file.')
                                    
                                end
                                
                                % Remove individual analysis files containg '*.tif' from this list.
                                for i=length(analysisList):-1:1 % Remove from end to begin, to keep the indexing logical.
                                    
                                    if ~isempty(strfind(analysisList(i).name,'tif'))
                                        analysisList(i)=[];
                                    end
                                end
                            end
                            
                            for i=1:length(analysisList)
                                dataFrameSelectionTxt ='(1:end)';
                                writeAnalysisStart(expnm,EID,analysisList(i).name);
                                loadAnalysis(analysisList(i));
                                try
                                    eval(preCommand);
                                catch
                                    warning('failed to run preCommand');
                                    disp(preCommand);
                                end
                                if reloadMovie % If with frameselection only a part of the movie is loaded, by reload, another part of the same movie can be loaded to create a mask.
                                    [data, pathname, fname, dirname] = loadTiff([expnm{EID}.folder '\' expnm{EID}.name],fastLoadChkButton.Value );
                                end
                                if ~skipMovie
                                    pause(0.05);
                                    processMovie(pathname);
                                    moveResults(analysisList(i).name);
                                    writeProcessEnd(expnm,EID);
                                end
                                try
                                    eval(postCommand);
                                catch
                                    warning('failed to run postCommand');
                                    disp(postCommand);
                                end
                            end
                            
                            
                        else % The loadAnalysis checkbox is not enabled, just use settings from the GUI.
                            dataFrameSelectionTxt ='(1:end)';
                            processMovie(pathname);
                            writeProcessEnd(expnm,EID);
                        end
                        
                        
                        
                        %% Write in the process file.
                        
                    else % Files is invalid
                        disp('File is invalid, skipping file for processing.');
                        disp(['   ' expnm{EID}.folder '\' expnm{EID}.name ' is already processed']);
                        pause(1);
                    end
                else % Files is already processed
                    disp('File is already processed, skipping file for processing.');
                    disp(['   ' '\' expnm{EID}.name ' is already processed']);
                    %pause(1);
                    
                end
            end
            disp(['All movies in ' datadirname ' processed.']);
            dNmTxt.String = ['All movies in ' datadirname ' processed.'];
            p = mfilename('fullpath');
            bp = strfind(p,'\');
            zip([datadirname '\process\processSoft_' getenv('ComputerName') '_' getenv('username') '.zip'],[p(1:(bp(end))) '*.m'])
        else
            disp([datadirname ': No tiff files found in.']);
        end
    end

    function moveResults(analysisListName)
        ffname = fname(1:end-4);
        %% SECTION TITLE
        % DESCRIPTIVE TEXTSECTION TITLE
        % DESCRIPTIVE TEXT
        if contains(analysisListName, '.tif')
            lll=strfind(analysisListName, '.tif');
            AN = analysisListName(lll+5:end-4);
        else 
            AN = analysisListName(1:end-4);
        end
        movefile([dirname fname '*.png'],[dirname AN '\']);
        movefile([dirname ffname '*.png'],[dirname AN '\']);
        try
            movefile([dirname fname '*.pdf'],[dirname AN '\']);
        catch
            disp('No pdf files found.')
        end
        try
            movefile([dirname ffname '*.pdf'],[dirname AN '\']);
        catch
            disp('no pdf found');
        end
        movefile([dirname fname '*.emf'],[dirname AN '\']);
        movefile([dirname ffname '*.emf'],[dirname AN '\']);
      
        ffname = fname(1:end-4);
        try
           movefile([dirname 'output\' ffname '*.*'],[dirname AN '\output']);
           movefile([dirname 'output\SynapseDetails\' ffname '*.*'],[dirname AN '\output\SynapseDetails\']);
       catch 
           disp('one of these files is open and prevents writing: (probably excell)')
           disp(dir([dirname 'output\SynapseDetails\' ffname '*.*']));
           disp(dir([dirname 'output\' ffname '*.*']));
           disp([dirname AN '\output\SynapseDetails\']);
           disp('press any key to try again');
           pause()
           movefile([dirname 'output\' ffname '*.*'],[dirname AN '\output']);
           movefile([dirname 'output\SynapseDetails\' ffname '*.*'],[dirname AN '\output\SynapseDetails\']);
  
           
       end
       % Put some files back .
        copyfile([dirname AN '\' fname '_mask.png'],[dirname]);
       
    end
    function loadAnalysis(FNname)
        analysisCfgLoad(FNname);
    end


 function writeProcessFail(expnm,iii,message)
        %AP10Response(iii) = mASR;
        fid =fopen([expnm{iii}.folder '\process\process_' expnm{iii}.name '.txt'],'a');
        cl = clock;
        fprintf(fid,[':\n ' ]);
        fprintf(fid,['Failed processing: ' message]);
        fclose(fid);
    end

    function writeProcessEnd(expnm,iii)
        %AP10Response(iii) = mASR;
        fid =fopen([expnm{iii}.folder '\process\process_' expnm{iii}.name '.txt'],'a');
        cl = clock;
        fprintf(fid,['processed: '  num2str(cl(1)) '-' num2str(cl(2)) '-' num2str(cl(3)) ' ' num2str(cl(4)) ':' num2str(cl(5)) ':' num2str(cl(6)) '\r\n']);
        fprintf(fid,['settings: ' ...
            '\r\n\t stimFreq = ' num2str(stimFreq) ...
            '\r\n\t Number of stimuli =' num2str(NOS) ...
            '\r\n\t OnOffset = ' num2str(OnOffset) ...
            '\r\n\t Partial stimFreq = ' num2str(stimFreq2) ...
            '\r\n\t Partial number of stimuli =' num2str(NOS2) ...
            '\r\n\t Partial OnOffset = ' num2str(m.OnOffset2) ...
            '\r\n\t Eigen Value Nr = ' num2str(EVN) ...
            '\r\n\t fps = ' num2str(fps) ...
            '\r\n\t dt =  ' num2str(dt) ...
            '\r\n\t Reuse Mask =  ' num2str(reuseMaskChkButton.Value) ...
            '\r\n\t Threshold =  ' num2str(TValue) ....
            '\r\n\t data Frames Selection =  ' dataFrameSelectionTxt ...
            '\r\n']);
        fclose(fid);
    end
    function doProcessMovie(e,v,h)
        processMovie(pathname)
    end
    function processMovie(pathname)
        
        eval(['data=data(:,:,' dataFrameSelectionTxt ');']);
        if (reuseMaskChkButton.Value==1)
              [synRegio, synProb] =  loadMask([pathname(1:end) '_mask.png']);
              setMask();
        else
            if  segmentCellBodies
                meanZ();
                synProb = imsharpen(synProb,'Radius',16,'Amount',40);% ,'roberts');
                setTvalue(mean(synProb(:))+1*std(synProb(:))); disp('sigma fixed to 1 sigma');
                doThreshold(TValue);
                cleanBW();
     
                %EVN=1; warning ('eigenvalue hacked 2->1');
                warning('processMovie hacked for neuron body processing' )
            else
                segment2(); % [synapseBW, synProb] = f(data)
                rmvBkGrnd(); % synapseBW = f(synapseBW, synProb) 2sigma is done
            end
            
            %threeSigThreshold();
%             onesigma = mean(synProb(:))+1*std(synProb(:));
%             setTvalue(onesigma);
%             threshold();
%             warning('threshold Sigma = 1')
            %cleanBW();
            detectIslands(); %  synRegio  = f(synapseBW)
            %%%subtractBckgrnd(); % data = f(data)
            %%%extractSignals(); % synsignal = f(synRegio)
            
            
            %loadTiff22();
            exportMask('_maskBTT.png'); % mask Before Temporal Thresholding
            setMask(); % maskRegio  = synRegio 
        end
        
        
        % GetSignal
        synRegio = maskRegio;
        RSTmean = mean(data(:)); %Raw spatioTemporalMean
        subtractBlackLevel();          % data = f(data)
        RSTABSmean = mean(data(:)); %Raw spatioTemporalMeanAfterBlackLevelsubtraction.
        if (length(synRegio) ~=0)
            extractSignals();           % synsignal = f(synRegio,data)
            signalPlot();               % f(dff(synsignal'))
            exportSynapseSignals();     % tempThreshold(dff(synsignal'))
            exportMask('_mask.png'); % Mask after temporal Thresholding, =default to (reuse)
            
            doPostProcessing(); % Partial Processing
            % GetAmplitude
            analyseSingSynResponse();
            avgSynapseResponse(); % AR=f(synsignal)
            doMultiResponseto1(); %AR=mr(AR), ASR=mr(ASR)   % Temporal Averaging          
            analyseAvgResponse();
            
        else
               
            % Invalidate:
            extractSignals(); 
            exportSynapseSignals(); % tempThreshold(dff(synsignal'))
            exportMask('_mask.png'); % Mask after temporal Thresholding, =default to (reuse)
            
       synRegio(1).PixelIdxList=nan;
       synRegio(1).PixelList=[nan,nan];
       
            
            doPostProcessing(); % Partial Processing
            % GetAmplitude
            analyseSingSynResponse();
            avgSynapseResponse(); % AR=f(synsignal)
            doMultiResponseto1(); % AR=mr(AR), ASR=mr(ASR)   % Temporal Averaging          
            analyseAvgResponse(); % write outputfiles Analysis.
       
            
            subplot(4,4,16);
            hold off;
            plot(0,0);
            savesubplot(4,4,12,[pathname(1:end-4) '_signals']);
            
            % csvwrite([dirname 'output\' fname(1:end-4) '_synapses.csv'],dff(synsignal'))
           % invalidate();
            
        end
    end
    function invalidate()
        % Write some files to output standard results when experiment is
        % invalid.
        subplot(4,4,8);
        hold off;
        plot(0);
        savesubplot(4,4,8,[pathname '_analysis']);
      %Don't think this is needed any more, is calculated in analyseAvgResponse
      imageMetrics=calcImageMetrics(data)  ;
      
        mASR=0; miASR=0; mstdSR=0; fps=fps; UpHalfTime=0; DownHalfTime=0; expEqUp=0; expEqDown=0; tau1 = 0; ampSS=0; nSynapses=0; error=1;AUC=0;nAUC=0;
        mswASR=0; miswASR=0;amp=0;tau1PA=0; ampPA=0; t0PA=0;TempSynSTD=0; TSpAPA=0; TSpAPAi=0;
        t =array2table([mASR mstdSR miASR  mswASR miswASR fps ...
            UpHalfTime DownHalfTime tau1 amp...
            nSynapses AUC nAUC tau1PA ampPA ...
            t0PA RSTmean RSTABSmean error...
            ,TempSynSTD,...
            TSpAPA, TSpAPAi,...
            [imageMetrics.value]  ],...
            'VariableNames',{...
            'peakAmp', 'mstdSR', 'miASR', 'sizeWeightedMASR', 'swmiASR', 'fps', ...
            'UpHalfTime', 'downHalfTime', 'tau1', 'ampSS',...
            'nSynapses','AUC','nAUC' , 'tau1PA', 'ampPA', ...
            't0PA' , 'RSTmean', 'RSTABSmean', 'error'...
            ,'TempSynSTD',...
            'TSpAPA', 'TSpAPAi',...
            imageMetrics.name});
        
        %t =array2table([mASR miASR fps UpHalfTime DownHalfTime expEqUp expEqDown error],'VariableNAmes',{'mASR', 'miASR', 'fps', 'UpHalfTime', 'downHalfTime', 'expEqy0', 'upA1', 'upx0', 'upT1', 'expEqdwny0', 'dwnA1', 'dwnx0', 'dwnT1', 'invalid'});
        %t =array2table([mASR miASR fps UpHalfTime DownHalfTime expEqUp expEqDown ],'VariableNAmes',{'mASR', 'miASR', 'fps', 'UpHalfTime', 'downHalfTime', 'expEqy0', 'upA1', 'upx0', 'upT1', 'upA2', 'upT2', 'expEqdwny0', 'dwnA1', 'dwnx0', 'dwnT1', 'dwnA2', 'dwnT2'});
        mkdir ([dirname 'output\']);
        writetable(t,[dirname 'output\' fname(1:end-4) '_analysis']);
    end
    function processSingleCoverslipExperiment(s,e,h)
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
                
                
                C10expnm{1} = dir ([C10dirname '\*.tif']);
                C1expnm{1} = dir ([C1dirname '\*.tif']);
                M3expnm{1} = dir ([M3dirname '\*.tif']);
                M5expnm{1} = dir ([M5dirname '\*.tif']);
                M10expnm{1} = dir ([M10dirname '\*.tif']);
                M15expnm{1} = dir ([M15dirname '\*.tif']);
                M20expnm{1} = dir ([M20dirname '\*.tif']);
                M30expnm{1} = dir ([M30dirname '\*.tif']);
                
                processMovie([C10expnm{1}.folder '\' C10expnm{1}.name],0);
                processMovie(C1expnm{1});
                processMovie(M3expnm{1});
                processMovie(M5expnm{1});
                processMovie(M10expnm{1});
                processMovie(M15expnm{1});
                processMovie(M20expnm{1});
                processMovie(M30expnm{1});
                
    end
    function doseResponse(s,e,h)
        
        % Select Data dirs
        global firstExpNb
        firstExpNb = 0;
        if 1
            project = openPlateProject();%filePath);
            prjTxt.String = project.filePath;
            C10dirname = getProjDir(project,'10AP Control');
            dNmTxt.String  = C10dirname;
            C1dirname = getProjDir(project,'1AP Control');
            dNmTxt.String  = C1dirname;
            M5dirname = getProjDir(project,'1AP 5min');
            dNmTxt.String  = M5dirname;
            M10dirname = getProjDir(project,'1AP 10min');
            dNmTxt.String  = M10dirname;
            M20dirname = getProjDir(project,'1AP 20min');
            dNmTxt.String  = M20dirname;
            % M30dirname = getProjDir(project,'10AP 25min');
            
            [plateFilename, plateDir] = uigetfile('*.csv',['Select Plate Layout File'],[defaultDir '\']);
        else
            if 0
                C10dirname =  'D:\data\Rajiv\20171017\syGcamp1\NS_2017_20171017_133534_20171017_133729';
                C1dirname =  'D:\data\Rajiv\20171017\syGcamp1\NS_2017_120171017_133919_20171017_134155';
                M5dirname =     'D:\data\Rajiv\20171017\syGcamp1\NS_2017_220171017_135310_20171017_135609'
                M10dirname =     'D:\data\Rajiv\20171017\syGcamp1\NS_2017_320171017_135815_20171017_140054'
                M20dirname=     'D:\data\Rajiv\20171017\syGcamp1\NS_2017_420171017_140224_20171017_140422'
                
            else
                [C10dirname] = uigetdir(defaultDir,'Select control 10AP dir:');
                defaultDir =  [C10dirname '\..'];
                [C1dirname]  = uigetdir(defaultDir,'Select control 1AP dir:');
                defaultDir =  [C1dirname '\..'];
                [M5dirname]  = uigetdir(defaultDir,'Select 5min. Compound 1AP dir:');
                defaultDir =  [M5dirname '\..'];
                [M10dirname] = uigetdir(defaultDir,'Select 10min. Compound 1AP dir:');
                defaultDir =  [M10dirname '\..'];
                [M20dirname] = uigetdir(defaultDir,'Select 20min. Compound 1AP dir:');
                defaultDir =  [M20dirname '\..'];
            end
        end
        
        % Define experiments to process
        experiments = 1:28;
        experiments = 0:9;
        experiments =0;
        % Create absolute Paths
        for ii = 1:length(experiments )
            ee = num2str(100+experiments(ii));ee = ee(2:3); % To make 01,02, 03, .. 10, 11
            C10expnm{ii} = dir ([C10dirname '\*e00' ee '.tif']);
            if isempty( C10expnm{ii})
                C10expnm{ii} = dir ([C10dirname '\*iGlu_' num2str(ii) '.tif']);
            end
        end
        if isempty(C1dirname)
            C1expnm{ii}=[];
        else
            for ii = 1:length(experiments )
                ee = num2str(100+experiments(ii));ee = ee(2:3); % To make 01,02, 03, .. 10, 11
                C1expnm{ii} = dir ([C1dirname '\*e00' ee '.tif']);
            end
        end
        for ii = 1:length(experiments )
            M5expnm{ii} = dir ([M5dirname '\*e000' num2str(experiments(ii) ) '.tif']);
        end
        for ii = 1:length(experiments )
            M10expnm{ii} = dir ([M10dirname '\*e000' num2str(experiments(ii) ) '.tif']);
        end
        for ii = 1:length(experiments )
            M20expnm{ii} = dir ([M20dirname '\*e000' num2str(experiments(ii) ) '.tif']);
        end
        %                 for ii = 1:length(experiments )
        %                     M30expnm{ii} = dir ([M30dirname '\*e000' num2str(experiments(ii) ) '.tif']);
        %                 end
        
        %% Find and set Meta Data
        % Select Plate Layout
        metadata = 0;
        if metadata
        if 0
            filenm =    'plateLayout_Concentration.csv'
            plateDir =    'D:\data\Rajiv\20171017\syGcamp1\'
        else
            if ~plateDir
                [plateFilename, plateDir] = uigetfile('*.csv',['Select Plate Layout File'],[defaultDir '\']);
            end
        end
        defaultDir =  plateDir;
        plateValues = csvread([plateDir '\' plateFilename ]);
        id = strfind(plateFilename,'_');
        plateQuantity = plateFilename(id+1:end-4);
        
        % Load Andor file
        tttt = dir([C10dirname '\NS_*.txt']);
        if length(tttt)==0
            tttt = dir([C10dirname '\Protocol*.txt']);
        end
        andorfilename = [tttt.folder '\' tttt.name];
        exp2wellNr = readAndorFile(andorfilename);
        
        plate.plateValues = plateValues;
        plate.expwells = exp2wellNr;
        wellQty = getPlateValue(plate,experiments);
        end
        
        %%
        for iii = 1:length(experiments)
            % Load exp 1:10AP
            
            % Visualise we do new experiment.
            
            
            % Load the data
            [data, pathname, fname, dirname] = loadTiff([C10expnm{iii}.folder '\' C10expnm{iii}.name]);
            dNmTxt.String = dirname;
            defaultDir =  dirname;
            wx = size(data,2); wy = size(data,1);
            fNmTxt.String=fname;
            
            
           % 
           if isfile([C10expnm{iii}.folder '\' C10expnm{iii}.name '_mask.png'])
               [synRegio, synProb] =  loadMask([C10expnm{iii}.folder '\' C10expnm{iii}.name '_mask.png']);
               setMask();
           else
               segment2();
               rmvBkGrnd();
               detectIslands();
               doExportMask();
               setMask();
           end
            extractSignals();
            signalPlot();
            exportSynapseSignals();
            
            
            
            % GetSignal
            synRegio = maskRegio;
            if length(synRegio) ~=0
                extractSignals();
                % GetAmplitude
                %                analyseResponse();
                avgSynapseResponse();
                
                %  doMultiResponseto1(); 
                
                analyseAvgResponse();
                AP10Response(iii) = mASR;
                
                % Load exp 2: control
                
                %loadTiff22();
                try C1expnm{ii};
                    [data, pathname, fname, dirname] = loadTiff([C1expnm{iii}.folder '\' C1expnm{iii}.name]);
                    
                    wx = size(data,2); wy = size(data,1);
                    fNmTxt.String=fname;
                    newmask =1;
                    if newmask % Create new mask, use 10AP mask.
                        segment2();
                        rmvBkGrnd();
                        detectIslands();
                    else
                        synRegio=maskRegio;
                    end
                    if length(synRegio) ~=0
                        extractSignals();
                        signalPlot();
                        exportSynapseSignals();
                        % GetAmplitude
                        analyseSingSynResponse();
                        avgSynapseResponse();
                        ASR=multiResponseto1(ASR);
                        
                        analyseAvgResponse();
                        subplot(4,4,12)
                        
                        controlResponse(iii) = mASR;
                    else
                        disp(['No synapses identified in: ' fname])
                        controlResponse(iii)=nan;
                    end
                catch
                    disp(['No control data for' fname])
                end
                if 1
                    % Load exp 3: 5min 1AP
                    %loadTiff22();
                    [data, pathname, fname, dirname] = loadTiff([M5expnm{iii}.folder '\' M5expnm{iii}.name]);
                    wx = size(data,2); wy = size(data,1);
                    fNmTxt.String=fname;
                    if newmask % Create new mask, use 10AP mask.
                        segment2();
                        rmvBkGrnd();
                        detectIslands();
                    else
                        synRegio=maskRegio;
                    end
                    
                    if length(synRegio) ~=0
                        extractSignals();
                        signalPlot();
                        exportSynapseSignals();
                        % GetAmplitude
                        analyseSingSynResponse();
                        avgSynapseResponse();
                        hold on
                        plot(ASR,'k','LineWidth',2)
                        hold off
                        savesubplot(4,4,12,[pathname '_response'])
                        ASR=multiResponseto1(ASR);
                        analyseAvgResponse();
                        min5Response(iii) = mASR;
                    else
                        disp(['No synapses identified in: ' fname])
                        mASR=nan;
                        min5Response(iii) = mASR;
                    end
                    
                    % Load exp 4: 10 min 1AP
                    %loadTiff22();
                    [data, pathname, fname, dirname] = loadTiff([M10expnm{iii}.folder '\' M10expnm{iii}.name]);
                    wx = size(data,2); wy = size(data,1);
                    fNmTxt.String=fname;
                    if newmask % Create new mask, use 10AP mask.
                        segment2();
                        rmvBkGrnd();
                        detectIslands();
                    else
                        synRegio=maskRegio;
                    end
                    if length(synRegio) ~=0
                        extractSignals();
                        signalPlot();
                        exportSynapseSignals();
                        % GetAmplitude
                        analyseSingSynResponse();
                        avgSynapseResponse();
                        signalPlot();
                        hold on
                        plot(ASR,'k','LineWidth',2)
                        hold off
                        %figure
                        subplot(4,4,8);
                        ASR=multiResponseto1(ASR);
                        analyseAvgResponse();
                        min10Response(iii) = mASR;
                    else
                        disp(['No synapses identified in: ' fname])
                        mASR=nan;
                        min10Response(iii) = mASR;
                    end
                    
                    
                    
                    % Load exp 5: 20 min 1AP
                    %loadTiff22();
                    [data, pathname, fname, dirname] = loadTiff([M20expnm{iii}.folder '\' M20expnm{iii}.name]);
                    wx = size(data,2); wy = size(data,1);
                    fNmTxt.String=fname;
                    
                    if newmask % Create new mask, use 10AP mask.
                        segment2();
                        rmvBkGrnd();
                        detectIslands();
                    else
                        synRegio=maskRegio;
                    end
                    if length(synRegio) ~=0
                        extractSignals();
                        signalPlot();
                        exportSynapseSignals();
                        % GetAmplitude
                        analyseSingSynResponse();
                        avgSynapseResponse();
                        ASR=multiResponseto1(ASR);
                        
                        analyseAvgResponse();
                        min20Response(iii) = mASR;
                    else
                        disp(['No synapses identified in: ' fname])
                        mASR=nan;
                        min20Response(iii) = mASR;
                    end
                    
                    
                    %                     % Load exp 6: 30 min 1AP
                    %                     %loadTiff22();
                    %                     [data, pathname, fname, dirname] = loadTiff([M30expnm{iii}.folder '\' M30expnm{iii}.name]);
                    %                     wx = size(data,2); wy = size(data,1);
                    %                     fNmTxt.String=fname;
                    %
                    %                     if newmask % Create new mask, use 10AP mask.
                    %                         segment2();
                    %                         rmvBkGrnd();
                    %                         detectIslands();
                    %                     else
                    %                         synRegio=maskRegio;
                    %                     end
                    %                     if length(synRegio) ~=0
                    %                         extractSignals();
                    %                         % GetAmplitude
                    %                         avgSynapseResponse();
                    %                         ASR=multiResponseto1(ASR);
                    %
                    %                         analyseAvgReponse();
                    %                         min30Response(iii) = mASR;
                    %                     else
                    %                         disp(['No synapses identified in: ' fname])
                    %                         mASR=nan;
                    %                         min30Response(iii) = mASR;
                    %                     end
                end
                
            else
                disp(['No synapses identified in: ' fname])
                mASR=nan;
                min10Response(iii) = mASR;
                AP10Response(iii) = nan;
                controlResponse(iii) = nan;
                min5Response(iii) = nan;
                min20Response(iii) = nan;
                min30Response(iii) = nan;
                
            end
            
            hold off;
            subplot(4,4,14);
            
            plot([0 ]  , [controlResponse(iii)]);% min5Response(iii)]);
            plot([0 5 10 20] , [controlResponse(iii) min5Response(iii) min10Response(iii) min20Response(iii) ]);
            
            %plot([0 5 10 20 30] , [controlResponse(iii) min5Response(iii) min10Response(iii) min20Response(iii) min30Response(iii)]);
            savesubplot(4,4,14,[dirname 'responses']);
        end
        %% save the result:
        save ('controlResponse.mat', 'controlResponse')
        
        %% Plot the results
        %figure;
        subplot(4,4,[2:4,6:8,10:12]);
        cla
        pause(.5);
        
        %  plot(wellQty , AP10Response);
        hold on
        plot(wellQty , controlResponse,'o');%./controlResponse,'o');
        
        plot(wellQty , min5Response./controlResponse,'*');
        %        plot(wellQty , min10Response./controlResponse,'x');
        %        plot(wellQty , min20Response./controlResponse,'o');
        mR = mean([controlResponse],1);% min10Response./controlResponse; min20Response./controlResponse]);
        e = std( [controlResponse],[],1);% min10Response./controlResponse; min20Response./controlResponse]);
        
        
        %mR = mean([min5Response./controlResponse; min10Response./controlResponse; min20Response./controlResponse]);
        %e = std( [min5Response./controlResponse; min10Response./controlResponse; min20Response./controlResponse]);
        
        wellSelection1 = (wellQty==1);
        mC1 = sum((wellSelection1).*controlResponse)/sum((wellSelection1));
        sC1 = sqrt(sum((wellSelection1).*(controlResponse-mC1).^2))/sqrt(sum((wellSelection1)));
        
        wellSelection0 = (wellQty==0);
        mC2 = sum(wellSelection0.*controlResponse)/sum(wellSelection0);
        sC2 = sqrt(sum(wellSelection0.*(controlResponse-mC2).^2))/sqrt(sum(wellSelection0));
        
        sum((wellQty==1).*controlResponse)
        errorbar(wellQty, mR,e)
        xlabel(plateQuantity);
        ylabel('Amp. / A_{control}');
        legend('10AP Control','1AP Control', '1AP 5min', '1AP 10min', '10AP 12min')
        savesubplot(4,4,[2:4,6:8,10:12],[pathname '_doseResponse.png'])
        
    end
    function subtractBlackLevel(f,d,e)
        [sz1, sz2, sz3]=size(data);
        backGroundStrength = getBkgrnd(data(:,:,:));
        backGroundStrength =reshape(backGroundStrength ,[ 1 1 sz3]);
        data=data-repmat(backGroundStrength,[sz1 sz2 1]);        
    end
    function backGroundStrength=getBkgrnd(data)
        % Calculates the average background dynamics of the 5% darkest
        % pixels. The darkest pixels of the time average.
        image=mean(data(:,:,1:end),3);
        [~, sii] = sort(image(:));
        fivePrctInterval = floor(length(sii)/100*5);
        data2=reshape(data,[],size(data,3));
        backGroundStrength = mean(data2(sii(1:fivePrctInterval),:));      
    end
    function ok = doExportMask(s,e,h)
        exportMask('_mask.png');
    end
    function ok = exportMask(fileExtension)
        s2=synRegio;
        mask=uint16 (zeros(wy,wx));
        for j=1:length(s2)
            %pixl=s2(j).PixelList;
            pixlid=s2(j).PixelIdxList;
            mask(pixlid)=(2^16-j);
        end
        if length(s2)==0
            mask=zeros(wy,wx);
        end
        imwrite(mask,[pathname fileExtension],'bitdepth',16);
    end
    function meanData = mR1(data)
        meanData = multiResponseto1(data);
    end
    function doMultiResponseto1(s,e,h)
        ASR = multiResponseto1(ASR);
        AR = multiResponseto1(AR);
        
    end

    function part = foldData(data)
        % stimFreq = 0.125;%Hz
        % Number of Stimuli
        % NOS = 3; % Number of Stimuli
        interStimPeriod = 1/stimFreq*fps; %Do not floor here but only after multiplication.
        iSP = interStimPeriod;
        dCOF=dutyCycleOnFrames; % DutyCycleOnFrames.  |--dCOF--|____|-----|____
        if (dCOF==0 || dCOF>iSP)
            dCOF = floor(iSP);
        end
        
        %dCOF = floor(iSP); %dutyCycleOnFrames.
        part = zeros(dCOF,NOS);
        for iii = 1:NOS
            try
                part(:,iii)=data(OnOffset+floor((iii-1)*iSP)+(1:dCOF));
            catch e
                disp(['size(data) = ' num2str(size(data)) ', OnOffset= ' num2str(OnOffset) ', iSP =' num2str(iSP) ', dCOF= ' num2str(dCOF) ]);
                disp('Multi Response to 1 error, press any key to crash, or set a breakpoint to investigate')
                 pause;
                disp(['error: ' pathname]);
                disp('run analysisCfgGenerator(), to resolve analysis errors');
                error(e.message);
                
            end
        end
        
    end
    function meanData = multiResponseto1(data,exportPlot)
        if nargin==1
            exportPlot=1;
        end
        
        part = foldData(data);

        %         part(:,2)=data(OnOffset+1*iSP+(1:iSP));
        %         part(:,3)=data(OnOffset+2*iSP+(1:iSP));
        %         part(:,4)=data(OnOffset+3*iSP+(1:iSP));
        %         part(:,5)=data(OnOffset+4*iSP+(1:iSP));
        % figure;
        
        if  ~(strcmp(PhotoBleachingTxt,'auto2exp') || strcmp(PhotoBleachingTxt,'autoLinInt'))
        subplot(4,4,12)
        [spart,~,~,level] = linBleachCorrect(part');
        part = (spart-level)'; %Using Matlab Matrix expansion
        plot(part);
        hold on
        end
        
        meanData=mean(part,2);
        
        if ~(strcmp(PhotoBleachingTxt,'auto2exp') || strcmp(PhotoBleachingTxt,'autoLinInt'))
            [meanData,~, ~,baseLevel] = linBleachCorrect(meanData'); % To set the bottom back to zero,
            meanData = meanData'-baseLevel;
            plot(meanData,'k','LineWidth',3);
            hold off
            pause(.01);
        end
        if (exportPlot)
            savesubplot(4,4,12,[pathname '_align']);
        end
        
        
        % ASR = meanData;
    end


    function part = foldData2(signal)    % Check if the partial interval is bigger than the interval
        % itself.
        if (stimFreq2<stimFreq) && (stimFreq2~=0)
            stimFreq2=stimFreq;
            warning(['stimFreq2 adjusted to: ' num2str(stimFreq) 'to fit interval.']);
            warning(['Continue on your own risk by pressing a key ' ]);
            pause();
        end
        
        if stimFreq2==0
            sFq2=stimFreq;
        else
            sFq2=stimFreq2;
        end
        interStimPeriod = floor(1/sFq2*fps);
        iSP = interStimPeriod;
        if NOS2==0
            setNOS2(1);
        end
        if NOS2==-1
            
        else
            part=zeros(iSP,NOS2);
            for j = 1:NOS2
                %part(:,j)=signal(m.OnOffset2+(j-1)*iSP+(1:iSP));
                try
                    part(:,j)=signal(m.OnOffset2+floor((j-1)/sFq2*fps)+(1:iSP)); % Here the rounding is done after the multiplication = better
                catch e
                    d = dialog('Position',[300 300 250 150],'Name','Wrong Numbers');
                    
                    txt = uicontrol('Parent',d,...
                        'Style','text',...
                        'Position',[20 80 210 40],...
                        'String','The artificial intelligence says the partial analysis numbers are wrong.');
                    
                    btn = uicontrol('Parent',d,...
                        'Position',[85 20 70 25],...
                        'String','Close',...
                        'Callback','delete(gcf)');
                    pause();
                end
            end
            if debug
                plot(part);
                pause(.01);
            end
        end
    end

    function doPostProcessing(s,e,h)
        postProcess(synsignal');%dff(synsignal')')
    end

    function postProcess(synsignalTemp)
        % To create the *PP_Synapse.txt file
        dffsynsignal=dff(synsignal')';
        
        
        expEqDown =[nan nan nan nan] ;
        expEqUp =[nan nan nan nan] ;
        
        synapseNbr=nan; mSigA=nan;     miSigA=nan; synapseSize=nan; noiseSTD=nan; aboveThreshold=nan;
        UpHalfTime=nan;    DownHalfTime=nan;    tau1=nan;    amp=nan;      error=nan; xCentPos=nan; yCentPos=nan;
        bbox=[nan,nan,nan,nan]; AUC=nan; nAUC=nan;
         rawDFF=nan; rawDFluor=nan; rawMaxFluor = nan; rawBaseFluor=nan;
            rawPartDF=nan; rawPartMaxFluor= nan; rawPartMinFluor=nan;
        
        for i=1:size(dffsynsignal,2)
            if isempty(synsignal)
                rawFoldedData=nan*ones(size(dffsynsignal)); %When no synapses
                centre = nan;
                xCentPos(i) = nan;
                yCentPos(i) = centre(1);
                bbox(i,1:2)=nan;
                bbox(i,3:4)=nan;
                synapseSize(i) = nan;
            else
                rawFoldedData=mean(foldData(synsignal(:,i)),2);
                  centre = mean(synRegio(i).PixelList,1);
                  xCentPos(i) = centre(2);
                  yCentPos(i) = centre(1);
                  bbox(i,1:2)=max(synRegio(i).PixelList,[],1);
                  try
                  bbox(i,3:4)=min(synRegio(i).PixelList,[],1);
                  catch e
                      error(e.message);
                  end
                 synapseSize(i) = length(synRegio(i).PixelList);
            end
            if size(rawFoldedData)>=30
                rawBaseFluor(i) = mean(rawFoldedData(1:30));
            else
                rawBaseFluor(i) = mean(rawFoldedData(:));
            end
            rawMaxFluor(i)= max(rawFoldedData);
            rawDFluor(i) = rawMaxFluor(i)-rawBaseFluor(i);
            rawDFF(i) = rawDFluor(i)/rawBaseFluor(i);
        
            signal = dffsynsignal(:,i);
            synapseNbr(i) = i;
            
          
            
            signal = multiResponseto1(signal,0);
            part = foldData2(signal); % The dff data
            rawFolded2Part = foldData2(rawFoldedData); % The Raw Data
            for j = 1:NOS2
                % Partial raw Max and Min.
                rawPartMaxFluor(i,j)= max(rawFolded2Part(:,j));
                rawPartMinFluor(i,j) = min(rawFolded2Part(:,j));
                rawPartDF(i,j) = rawPartMaxFluor(i,j) - rawPartMinFluor(i,j);
                
                pSignal = part(:,j);
                [mSig, miSig] = max(pSignal,[],1); % Find max ampl of the Average Synaptic Response
                mSigA(i,j)=mSig;
                miSigA(i,j)=miSig;
                AUC(i,j) = sum((pSignal>0).*pSignal);
                nAUC(i,j) = sum((pSignal<0).*pSignal);
                noiseSTD(i,j) = std(signal(1:NumbAvgSamples)); % Calculate noise power (std). From the start of the signal.
                aboveThreshold(i,j) = mSig>(2*noiseSTD(i,j));
                
                %     upframes = miSig-stimulationStartFrame;
                %     upResponse = signal(stimulationStartFrame:miSig);
                %     expdata.x = (0:(length(upResponse)-1))*dt;
                %     expdata.y = upResponse;
                %     [expEqUp, fitCurve1] = curveFitV1(expdata,[.22 100 0 2 -1 2]);
                
                if 1 %length(expdata.x(:))<=4000000
                    expEqUp =[0 0 0 0] ;
                    %       disp(['No synapse up kinetcis fit for: ' fname 'Synapse' num2str(i)]);
                    tau1(i,j)=0; amp(i,j)=0; t0(i,j)=0;
                else
                    [tau1(i), amp(i), t0(i)] = exp1fit(expdata.x,expdata.y);
                    %            [fitCurve1] = fit(expdata.x(:),expdata.y(:),'exp2');%[.22 100 0 2 -1 2]);
                    %            expEqUp = coeffvalues(fitCurve1);
                    hold on;
                    %plot(miASR*dt+expdata.x, amp*exp(-expdata.x/tau1));
                    plot(miSig*dt+t0+expdata.x, amp*exp(-expdata.x/tau1));
                    %temp.     plot(expdata.x+stimulationStartTime, fitCurve1(expdata.x));
                end
                %downResponse = ASR(miASR:miASR+floor(3.0/dt));
                downResponse = pSignal(miSig:end);
                expdata.x = (0:(length(downResponse)-1))*dt;
                expdata.y = downResponse;
                %[expEqDown, fitCurve2] = curveFitV1(expdata,[0 1 0 2 1 2]);
                
                if length(expdata.x(:))<=4
                    expEqDown =[0 0 0 0] ;
                    disp(['No down kinetics fit for: ' fname]);
                    tau1(i,j)=0; amp(i,j)=0;t0(i,j)=0;
                else
                    [tau1(i,j), amp(i,j), t0(i,j)] = exp1fit(expdata.x,expdata.y);
                    %            [fitCurve2] = fit(expdata.x(:),expdata.y(:),'exp2');
                    %            expEqDown = coeffvalues(fitCurve2);
                                     hold off;
                    %                 %plot(miASR*dt+expdata.x, fitCurve2(expdata.x));
                    %                 %plot(miASR*dt+expdata.x, amp*exp(-expdata.x/tau1));
%                                      plot(miSig*dt+expdata.x,expdata.y);
%                                      hold on;
%                                      plot(miSig*dt+t0(i)+expdata.x, amp(i)*exp(-expdata.x/tau1(i)));
%                                      drawnow();%pause(.5)
                end
            end
     
        end
            
        UpHalfTime=tau1*0; DownHalfTime=tau1*0;
        error=tau1*0;
        
        tauL=labelVar('tau_',NOS2);
        maxSynL=labelVar('synapseAmplitude',NOS2);
        miSynL=labelVar('synapseMaxFrame',NOS2);
        noiseSTDL=labelVar('noiseSTD',NOS2);
        aboveThresholdL=labelVar('aboveThreshold',NOS2);
        UpHalfTimeL=labelVar('UpHalfTime',NOS2);
        downHalfTimeL=labelVar('downHalfTime',NOS2);
        AUCL=labelVar('AUC_',NOS2);
        nAUCL=labelVar('nAUC_',NOS2);
        ampSSL=labelVar('ampSS_',NOS2);
        rawPartMaxFluorL=labelVar('rawPartMaxFluor_',NOS2);
        rawPartMinFluorL=labelVar('rawPartMinFluor_',NOS2);
        rawPartDFFL=labelVar('rawPartDFF_',NOS2);
        errorL=labelVar('error_',NOS2);
                
        
        if  isempty(synSTD.spaceTimeSTD) % If all synapses are removed for not reaching temporal threshold.
        synSTD.spaceTimeSTD=nan;
        synSTD.spaceMeanTimeSTD=nan;
        synSTD.meanSpaceTimeSTD=nan;
        synSTD.laplaceSynProbSTD=nan;
        synSTD.synProbSTD=nan;
        end
        
        
        
        
        
   
        t = array2table([...
            synapseNbr', mSigA     miSigA synapseSize' noiseSTD ...
            aboveThreshold UpHalfTime    DownHalfTime    tau1    amp      ...
            error, xCentPos', yCentPos',  bbox(:,2), bbox(:,1), bbox(:,4), ...
            bbox(:,3), AUC, nAUC, rawBaseFluor', rawMaxFluor', rawDFluor', ...
            rawDFF', rawPartMaxFluor, rawPartMinFluor, rawPartDF...
            synSTD.spaceTimeSTD'  synSTD.spaceMeanTimeSTD' synSTD.meanSpaceTimeSTD' ...
         synSTD.synProbSTD'  synSTD.laplaceSynProbSTD'   ...
        ],...
            'VariableNames',...
            [{'synapseNbr'},maxSynL, miSynL, {'synapseSize'}, ...
            noiseSTDL, aboveThresholdL, UpHalfTimeL, downHalfTimeL, tauL, ampSSL, ...
            errorL,{'xCentPos'},{'yCentPos'},  {'bboxUx'},{'bboxUy'},...
            {'bboxDx'},{'bboxDy'},AUCL,nAUCL, 'rawBaseFluor', 'rawMaxFluor'...
            , 'rawDFluor', 'rawDFF', rawPartMaxFluorL , rawPartMinFluorL...
            , rawPartDFFL,...
            'spaceTimeSTD', 'spaceMeanTimeSTD' 'meanSpaceTimeSTD', ...
            'synProbSTD', 'laplaceSynProbSTD']);
        
        if(~isdir ([dirname 'output\']))
            mkdir ([dirname 'output\']);
        end
        if (~isdir ([dirname 'output\SynapseDetails']))
            mkdir ([dirname 'output\SynapseDetails']);
        end
        writetable(t,[dirname 'output\SynapseDetails\' fname(1:end-4) '_PPsynapses']);
        disp([dirname 'output\SynapseDetails\' fname(1:end-4) '_PPsynapses.txt']);disp(['created']);
    end

    function tableLabels = labelVar(label,ii)
        tableLabels=[];
        for i=1:ii
            tableLabels{i}=[label num2str(i)];
        end
        
    end

    function fijime(d1,d2,d3)
        
        %!C:\Users\mvandyc5\Downloads\fiji-win64\Fiji.app\ImageJ-win64.exe C:\Users\mvandyc5\Desktop\Protocol13220180124_132350_e0007.tif
        fijipath  = 'C:\Users\mvandyc5\Downloads\fiji-win64\Fiji.app\ImageJ-win64.exe';
        eval(['!START ' fijipath ' ' pathname]);
        
        
    end
    function ml=maxLength(parts)
        ml=0;
        for iii=1:length(part)
            ml =max(ml, length(part{iii}));
        end
    end
    function setMask()
        maskRegio = synRegio;
    end
    function ok = doloadMask(s,e,h)
        [maskFilename, maskDir] = uigetfile('*.png',['Select mask:'],[defaultDir '\']);
        maskFilePath = [maskDir '\' maskFilename];
        synRegio = loadMask(maskFilePath);
        setMask();
    end
    function analysisCfgLoad(stimCfgFN)
        
        stimCfgFN.folder=stimCfgFN.folder;
        stimCfgFN.name=stimCfgFN.name;
        analysisCfg = xmlSettingsExtractor(stimCfgFN);
        setNOS(analysisCfg.pulseCount);
        setFPS(analysisCfg.imageFreq);
        setCellBody(analysisCfg.cellBody);
        setOnOffset(round(analysisCfg.delayTime*analysisCfg.imageFreq/1000));
        setStimFreq(analysisCfg.stimFreq);
        EVN = analysisCfg.eigenvalueNumber;
        setFrameSelectionTxt(analysisCfg.FrameSelectionTxt); %'(1:end)';
        
    
        setNOS2(analysisCfg.pulseCount2);
        setOnOffset2(round(analysisCfg.delayTime2*analysisCfg.imageFreq/1000));
        setStimFreq2(analysisCfg.stimFreq2);
        
        setReuseMask(analysisCfg.reuseMask);
        setReloadMovie(analysisCfg.reloadMovie);
        setwriteSVD(analysisCfg.writeSVD);
        setSkipMovie(analysisCfg.skipMovie);
       % for now, let the button overrule the text
       disp('fast load xml setting disabled');%setFastLoad(analysisCfg.fastLoad);
        setFrameSelectionTxt(analysisCfg.FrameSelectionTxt);
        setPhotoBleachingTxt(analysisCfg.PhotoBleachingTxt);
        setNumbAvgSamples(analysisCfg.NumAvgSamples);
        setDutyCycleOnFrames(analysisCfg.dutyCycle);
        setmaskTimeProjectionMethod(analysisCfg.maskTimeProjectionMethod);
        if isfield (analysisCfg,'preCommand')
            setPreCommand(analysisCfg.preCommand);
        else
            setPreCommand('');
        end
        if isfield (analysisCfg,'postCommand')
            setPostCommand(analysisCfg.postCommand);
        else
            setPostCommand('');
        end
% if exist('eigTxt')
%     eigTxt.String = EVN; 
% end
        pause(0.1);
    end


    function setPreCommand(txt) 
        preCommand=txt;
    end

    function setPostCommand(txt)
        postCommand=txt;
    end


    function setmaskTimeProjectionMethod(methodTxt)
        maskTimeProjectionMethod=methodTxt;
    end


function setSkipMovie(value)
        if exist('skipMovieChkButton','var')
            skipMovieChkButton.Value=value;
        end
        skipMovie = value;
    end
    
    function setFastLoad(value)
        if exist('fastLoadChkButton','var')
            fastLoadChkButton.Value=value;
        end
        fastLoad = value;
    end
    
    function setwriteSVD(value)
        if exist('writeSVDChkButton','var')
            writeSVDChkButton.Value=value;
        end
        writeSVD=value;
    end

    function setReuseMask(value)
        reuseMaskChkButton.Value=value;
    end

    function setReloadMovie(reloadMovieT)
        reloadMovie = reloadMovieT;
    end
    function setFrameSelectionTxt(FrameSelectionTxt)
        dataFrameSelectionTxt = FrameSelectionTxt;
    end
    function setPhotoBleachingTxt(PBT)
        PhotoBleachingTxt = PBT;
    end

    function setNumbAvgSamples(num)
        NumbAvgSamples=num;
    end
 
    function doLoadAnalysisSettings(s,f,g)
        [FN.name, FN.folder]=uigetfile('*Analysis.xml',['Select mask:'],[defaultDir '\']);
        analysisCfgLoad(FN);
    end


    function doStimCfgLoad(s,f,g)
        stimCfg = stimSettingsLoader(dirname);
        setNOS(stimCfg.pulseCount);
        setFPS(stimCfg.imageFreq);
        setOnOffset(round(stimCfg.delayTime*stimCfg.imageFreq/1000));
        setStimFreq(stimCfg.stimFreq);
    end
  function goAllSubDir(func,filterOptions,rootDir)
        % goAllSubDir will evaluate the function func on specific files in
        % current directory or subdirectory. 
       
        %global defaultDir;
        if nargin<3  
            if exist('defaultDir')
            [dataDirname] = uigetdir(defaultDir,'Select dir:');
            defaultDir =  [dataDirname '\..'];
            else
                [dataDirname] = uigetdir('','Select dir:');
            defaultDir =  [dataDirname '\..'];
            end
        else
            dataDirname=rootDir;  
        end
        if nargin<2
            filterOptions='\*.tif';
        end
        
        if ~isempty(dir([dataDirname '\' filterOptions]))
            func([dataDirname]);
        end
        
        if 1%isempty(dir([dataDirname filterOptions]))
            d2= dir([dataDirname '\*.*']);
            d2(~[d2.isdir])=[]; % remove files, keep subdirs
            for  i=1:(length(d2)-2) % remove . and ..
                goAllSubDir(func,filterOptions,[dataDirname '\' d2(i+2).name])
                func([dataDirname '\' d2(i+2).name]);
            end
        end
  end
end

