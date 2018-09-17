function dff=dff(signal,BC)
% Calculates the delta fluoresence / base fluoresence signal.
%
% BC enables/disables bleach correction. Default = on;
if nargin <= 2
    BC = 1;
end

if BC == 1  %Do Bleach Correction?
    if 1
        [~,dff] = linBleachCorrect(signal);
     %   [~,dff] = linMinBleachCorrect(signal);warning ('dff hack');
     %   [~,dff] = exp2BleachCorrection(signal);warning ('dff hack');
        
    else
        filterExperiment();
    end
else
    % No bleach correction.
     mstart = mean(signal(:,1:30),2);
     %     dff = (signal-BC-repmat(mstart,1,LM))./repmat(mstart,1,LM); % Delta f
     dff = (signal-repmat(mstart,1,LM))./repmat(mstart,1,LM); % Delta f over v
      %     warning('Is -BC juist');
    
      if 0 % When using the minima
          LM = length(signal,2);
          mstart = min(signal(:,1:floor(LM/3)),[],2);
          dff = (signal-repmat(mstart,1,LM))./repmat(mstart,1,LM); % Delta f over f
      end
end

end
function filterExperiment()

%       bpFilt = designfilt('bandpassfir', 'FilterOrder', 60, ...
%   'CutoffFrequency1', 0.05, 'CutoffFrequency2', 15,...
%   'SampleRate', 33);

lpFilt = designfilt('lowpassfir', 'FilterOrder', 5, ...
    'StopbandFrequency', 1, ...
    'PassbandFrequency',.0125,...
    'SampleRate', 33);
%  BCsignal = filtfilt(bpFilt, signal');
% figure;plot(BCsignal);

%B= [-0.0010    0.0016   -0.0056    0.0103   -0.0221    0.0324   -0.0514    0.0625   -0.0812    0.0847  0.9057    0.0847   -0.0812    0.0625   -0.0514    0.0324   -0.0221    0.0103   -0.0056    0.0016   -0.0010]; % 0.05
B=[-0.0028   -0.0008   -0.0097    0.0036   -0.0323    0.0183   -0.0695    0.0407   -0.1059    0.0580    0.8783     0.0580   -0.1059    0.0407   -0.0695    0.0183   -0.0323    0.0036   -0.0097   -0.0008   -0.0028 ]; % 0.5
%B = [-0.0031   -0.0016   -0.0117   -0.0008   -0.0400    0.0060   -0.0867    0.0185   -0.1322    0.0287    0.8469    0.0287   -0.1322    0.0185   -0.0867    0.0060   -0.0400   -0.0008   -0.0117   -0.0016   -0.0031]; % Cut off 1Hz
%B= [-0.0014   -0.0000   -0.0101   -0.0000   -0.0417    0.0000   -0.0987    0.0000   -0.1568    0.0000    0.8175    0.0000   -0.1568    0.0000   -0.0987    0.0000   -0.0417   -0.0000   -0.0101   -0.0000   -0.0014]; % Cut off 1.5Hz
%B = [  0.0009    0.0030   -0.0057    0.0055   -0.0369    0.0015   -0.1038   -0.0133   -0.1790   -0.0280    0.7894   -0.0280   -0.1790   -0.0133   -0.1038    0.0015   -0.0369    0.0055   -0.0057    0.0030    0.0009];% Cut off 2Hz

B = [-0.000881204974448489,0.000577377032672532,-0.00128379607772674,0.000889591375312911,-0.00169411337486796,0.000938281567960555,-0.00170889978185108,0.000177045703057591,-0.000698949630417756,-0.00196422772818845,0.00173479495656630,-0.00553525829202193,0.00520338288883767,-0.00958236613084966,0.00820710648287145,-0.0120621263629164,0.00833357897203198,-0.0103423347856177,0.00303713739022988,-0.00220071054298347,-0.00924093812054890,0.0130511459127013,-0.0280781604442713,0.0338276269008911,-0.0506933519071779,0.0563240391268902,-0.0724628469541975,0.0754687010063404,-0.0882367327723690,0.0864848885307834,0.906639640344546,0.0864848885307834,-0.0882367327723690,0.0754687010063404,-0.0724628469541975,0.0563240391268902,-0.0506933519071779,0.0338276269008911,-0.0280781604442713,0.0130511459127013,-0.00924093812054890,-0.00220071054298347,0.00303713739022988,-0.0103423347856177,0.00833357897203198,-0.0120621263629164,0.00820710648287145,-0.00958236613084966,0.00520338288883767,-0.00553525829202193,0.00173479495656630,-0.00196422772818845,-0.000698949630417756,0.000177045703057591,-0.00170889978185108,0.000938281567960555,-0.00169411337486796,0.000889591375312911,-0.00128379607772674,0.000577377032672532,-0.000881204974448489];% 61order,
A = 1;

% BCsignal = filtfilt(B,A, signal');
% lowFreq= signal-BCsignal';

%lowFreq= filtfilt(B,A, signal');
lowFreq =filtfilt(lpFilt,signal);

[z,p,k] = butter(4,15/(33/2));              % lowpass filter - 5 Hz cutoff
SOS = zp2sos(z,p,k);                        % second order sections matrix
lowFreq = sosfilt(SOS,signal);


lowFreq  = sgolayfilt(signal,10,61   );
lowFreq  = medfilt1(signal,13,'truncate');
BCsignal = signal'-lowFreq';


fsgnal = fft(signal,[],2);
ct=4
fsgnal(:,1:ct)=0;
fsgnal(:,end-ct:end)=0;
BCsignal = ifft(fsgnal,[],2,'symmetric');

lowFreq= signal'-BCsignal';

baseF = mean(lowFreq,2);
dff = BCsignal'./baseF; % Using auto expansion here

% Debug
debug = 0;
n=1;
if debug
    %figure;
    subplot(4,4,4)
    cla
    plot(signal(n,:),'LineWidth',3)
    hold on
    plot(lowFreq(n,:)','r','LineWidth',2)
    subplot(4,4,12)
    
end
end
