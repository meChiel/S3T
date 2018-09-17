function processMovie(data,pathname,reuseMask,fps,EVN,stimFreq,OnOffset,NOS )
% EVN=2;
% stimFreq = 0.125;%Hz
% OnOffset=50;
% NOS = 3;        % Number of Stimuli

if (reuseMask==1)%reuseMaskChkButton.Value==1)
    loadMask([pathname(1:end) '_mask.png']);
else
    segmentCellBodies=0;
    if segmentCellBodies
        meanZ();
        warning('processMovie hacked for neuron body processing' )
    else
        synProb = segment2(data,EVN,pathname);
        rmvBkGrnd(synProb,pathname);
        %rmvBkGrnd();
        
        
    end
    
    %twoSigThreshold();
    
    tvalue = mean(synProb(:))+2*std(synProb(:));
    %setTvalue(onesigma);
    %threshold();
    synapseBW = threshold(synProb ,tvalue);
    warning('threshold Sigma = 2')
    
    synapseBW = cleanBW(synapseBW);
    
    synRegio = detectIslands(synapseBW);
  %  synsignal = extractSignals(synRegio,data);
    
    %loadTiff22();
    wx = size(data,2); wy = size(data,1);
    exportMask(synRegio,pathname,wx,wy);
    maskRegio = setMask(synRegio);
end

% GetSignal
synRegio = maskRegio;
if (length(synRegio) ~=0)
    synsignal = extractSignals(synRegio,data);
    signalPlot(synsignal,pathname);
    exportSynapseSignals (synsignal,pathname);
    
    % GetAmplitude
    dt = 1/fps;
    analyseResponse(synsignal,synRegio,data,dt,stimFreq,NOS,fps,OnOffset,pathname);
    [ASR,nSynapses]  = avgSynapseResponse(synsignal);
    % doMultiResponseto1();
    ASR = multiResponseto1(ASR,1,stimFreq,NOS,fps,OnOffset,pathname);
    analyseAvgReponse(ASR,dt,pathname,nSynapses);
    
else
    % Invalidate:
    subplot(4,4,16);
    hold off;
    plot(0,0);
    savesubplot(4,4,12,[pathname(1:end-4) '_signals']);
    
    % csvwrite([dirname 'output\' fname(1:end-4) '_synapses.csv'],dff(synsignal'))
    invalidate();
    
end
end

function rmvBkGrnd(synProb,pathname)
subplot(4,4,16);
synProb=tophat(synProb);warning('tophat ipo freqfilter')
% freqfilter2D();

% setTvalue((std(synProb(:))*2));
tvalue = (std(synProb(:))*2);
% threshold(TValue);
synapseBW = threshold(synProb ,tvalue);
%cleanBW();
synapseBW = cleanBW(synapseBW);
%savesubplot(4,4,16,[pathname '_mask']);
imwrite(synapseBW,[pathname '_mask.png']);
subplot(4,4,4);
end

function synProb=tophat(synProb)%source,event,handles)
se = strel('disk',1);
%synProb = imadjust(imtophat(synProb ,se));
synProb = imsharpen(synProb,'Radius',16,'Amount',40);% ,'roberts');

pause(.5);
imagesc(synProb);
end

function synapseBW = threshold(synProb ,tvalue)%source,event,handles)
TValue = tvalue;%str2double(thresTxt.String);
synapseBW = synProb > TValue;
pause(.5);
imagesc(synapseBW);
end

function synapseBW = cleanBW(synapseBW)%source,event,handles)
warning('close sz 2 changed to 1')
synapseBW = imerode(synapseBW,strel('disk',2));
synapseBW = imdilate(synapseBW,strel('disk',2));
%warning('erode size hacked to 8')
pause(.5);
imagesc(synapseBW);
end
function synsignal = extractSignals(synRegio,data)
s2=synRegio;  wx = size(data,2); wy = size(data,1);
synsignal=[];
for j=1:length(s2)
    mask=zeros(wy,wx);
    % pixl=s2(j).PixelList;
    rframes=reshape(data,wx*wy,[]);
    pixlid=s2(j).PixelIdxList;
    synsignal(:,j) = mean(rframes(pixlid,:),1);
end
if length(s2)==0
    disp('No synapses found');
end
end
function  synRegio = detectIslands(synapseBW)
synRegio  = regionprops(synapseBW(:,:),'PixelList','PixelIdxList');
end

function ok = exportMask(synRegio,pathname,wx,wy)
s2=synRegio;
synsignal=[];
mask=uint16 (zeros(wy,wx));
for j=1:length(s2)
    %pixl=s2(j).PixelList;
    pixlid=s2(j).PixelIdxList;
    mask(pixlid)=(2^16-j);
end
if length(s2)==0
    mask=zeros(wy,wx);
end
imwrite(mask,[pathname '_mask.png'],'bitdepth',16);
end

function maskRegio = setMask(synRegio)
maskRegio = synRegio;
end

function signalPlot(synsignal,pathname)
pause(.5)
subplotNr=16;
subplot(4,4,subplotNr);
plot(bsxfun(@plus,4*dff(synsignal')',1*(1:size(synsignal,2))));
drawnow();
%plot(bsxfun(@plus,(synsignal')',1000*(1:size(synsignal,2))));
savesubplot(4,4,subplotNr,[pathname(1:end-4) '_signals']);
end

function exportSynapseSignals (synsignal,pathname)
[dirname, fname,ext] = fileparts(pathname);
%         pause(.5)
%         subplot(4,4,16);
%         plot(bsxfun(@plus,4*dff(synsignal')',1*(1:size(synsignal,2))));
mkdir([dirname '\output\']);
csvwrite([dirname '\output\' fname(1:end-4) '_synapses.csv'],dff(synsignal'))
%plot(bsxfun(@plus,(synsignal')',1000*(1:size(synsignal,2))));
end

function analyseResponse(synsignal,synRegio,data,dt,stimFreq,NOS,fps,OnOffset,pathname)
[dirname, fname,ext] = fileparts(pathname);
stimulationStartTime = 1.0;
stimulationStartFrame = floor(stimulationStartTime /dt);
dffsynsignal=dff(synsignal')';
for i=1:size(dffsynsignal,2)
    signal = dffsynsignal(:,i);
    synapseNbr(i) = i;
    centre = mean(synRegio(i).PixelList,1);
    xCentPos(i) = centre(2);
    yCentPos(i) = centre(1);
    bbox(i,1:2)=max(synRegio(i).PixelList,[],1);
    bbox(i,3:4)=min(synRegio(i).PixelList,[],1);
    
    signal = multiResponseto1(data,0,stimFreq,NOS,fps,OnOffset);
    [mSig, miSig] = max(signal,[],1); % Find max ampl of the Average Synaptic Response
    mSigA(i)=mSig;
    miSigA(i)=miSig;
    AUC(i) = sum((signal>0).*signal);
    nAUC(i) = sum((signal<0).*signal);
    
    upframes = miSig-stimulationStartFrame;
    upResponse = signal(stimulationStartFrame:miSig);
    expdata.x = (0:(length(upResponse)-1))*dt;
    expdata.y = upResponse;
    %[expEqUp, fitCurve1] = curveFitV1(expdata,[.22 100 0 2 -1 2]);
    
    
    if length(expdata.x(:))<=4000000
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

t =     array2table([mSigA'     miSigA'   UpHalfTime'    DownHalfTime'    tau1'    amp'      error', xCentPos', yCentPos', synapseNbr', bbox(:,2), bbox(:,1), bbox(:,4), bbox(:,3), AUC', nAUC'],...
    'VariableNAmes',{'maxSyn', 'miSyn', 'UpHalfTime', 'downHalfTime', 'tau1', 'ampSS', 'error','xCentPos','yCentPos', 'synapseNbr', 'bboxUx','bboxUy','bboxDx','bboxDy','AUC','nAUC'});

if(~isdir ([dirname '\output\']))
    mkdir ([dirname '\output\']);
end
if (~isdir ([dirname '\output\SynapseDetails']))
    mkdir ([dirname '\output\SynapseDetails']);
end
writetable(t,[dirname '\output\SynapseDetails\' fname(1:end-4) '_synapses']);
disp([dirname '\output\SynapseDetails\' fname(1:end-4) '_synapses.csv']);disp([ 'created']);



end

function analyseAvgReponse(ASR,dt,pathname,nSynapses)
fps=1/dt;
[dirname, fname,ext] = fileparts(pathname);
% Amplitude
[mASR, miASR] = max(ASR); % Find max ampl of the Average Synaptic Response

stimulationStartTime = 1.0;
stimulationStartFrame = floor(stimulationStartTime /dt);

pause(.5);
subplot(4,4,8)
cla
plot(dt*(((1:length(ASR))-1)), ASR);
xlabel(['Time(s) (' num2str(fps) 'fps)'])
ylabel('\Delta F/F0');
title('Analysis')
text(miASR/fps,mASR*1.05 ,['max: ' num2str(mASR)],'HorizontalAlignment','center');
% Area under the curve
AUC = sum(ASR.*(ASR>0));
text(miASR/fps,mASR*0.7 ,{'AUC:', num2str(AUC)},'HorizontalAlignment','center');


upframes = miASR-stimulationStartFrame;
upResponse = ASR(stimulationStartFrame:miASR);

expdata.x = (0:(length(upResponse)-1))*dt;
expdata.y = upResponse;
%[expEqUp, fitCurve1] = curveFitV1(expdata,[.22 100 0 2 -1 2]);


if length(expdata.x(:))<=4000000
    expEqUp =[0 0 0 0] ;
    disp(['No up kinetcis fit for: ' fname]);
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

savesubplot(4,4,8,[pathname '_analysis']);
error =0; % Indicates if something was wrong with the data or dataprocessing

nAUC = sum((ASR<0).*ASR);
t =array2table([mASR miASR fps UpHalfTime DownHalfTime tau1 amp nSynapses AUC nAUC error ],'VariableNames',{'peakAmp', 'miASR', 'fps', 'UpHalfTime', 'downHalfTime', 'tau1', 'ampSS', 'nSynapses','AUC','nAUC' ,'error'});
%t =array2table([mASR miASR fps UpHalfTime DownHalfTime expEqUp expEqDown error ],'VariableNAmes',{'mASR', 'miASR', 'fps', 'UpHalfTime', 'downHalfTime', 'expEqy0', 'upA1', 'upx0', 'upT1', 'expEqdwny0', 'dwnA1', 'dwnx0', 'dwnT1','error'});
%t =array2table([mASR miASR fps UpHalfTime DownHalfTime expEqUp expEqDown ],'VariableNAmes',{'mASR', 'miASR', 'fps', 'UpHalfTime', 'downHalfTime', 'expEqy0', 'upA1', 'upx0', 'upT1', 'upA2', 'upT2', 'expEqdwny0', 'dwnA1', 'dwnx0', 'dwnT1', 'dwnA2', 'dwnT2'});
if ~isdir([dirname '\output\']);
    mkdir ([dirname '\output\']);
end
writetable(t,[dirname '\output\' fname(1:end-4) '_analysis']);
disp([dirname '\output\' fname(1:end-4) '_analysis.csv']);disp([ 'created']);
subplot(4,4,15)

end

function meanData = multiResponseto1(data,exportPlot,stimFreq,NOS,fps,OnOffset,pathname)
if nargin==1
    exportPlot=1;
end
% stimFreq = 0.125;%Hz
% Number of Stimuli
% NOS = 3; % Number of Stimuli
interStimPeriod = floor(1/stimFreq*fps);
iSP = interStimPeriod;
part=zeros(iSP,NOS);
for iii = 1:NOS
    part(:,iii)=data(OnOffset+(iii-1)*iSP+(1:iSP));
end
%         part(:,2)=data(OnOffset+1*iSP+(1:iSP));
%         part(:,3)=data(OnOffset+2*iSP+(1:iSP));
%         part(:,4)=data(OnOffset+3*iSP+(1:iSP));
%         part(:,5)=data(OnOffset+4*iSP+(1:iSP));
%figure;
subplot(4,4,12)
[spart,~,~,level]=linBleachCorrect(part');
part = (spart-level)'; %Using expansion
plot(part);
hold on

meanData=mean(part,2);


[meanData,~, ~,baseLevel] = linBleachCorrect(meanData'); % To set the bottom back to zero,
meanData = meanData'-baseLevel;
plot(meanData,'k','LineWidth',3);
hold off
if (exportPlot)
    savesubplot(4,4,12,[pathname '_align']);
end


% ASR = meanData;
end

function [ASR,nSynapses] = avgSynapseResponse(synsignal)
nSynapses = size(synsignal,2);
hold off
if ~isempty(synsignal)
    ASR = mean(dff(synsignal'),1); % Average over all synapses
else
    ASR=zeros(1,wt);
    invalidate();
end
end

