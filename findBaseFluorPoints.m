function [bcresponse, dff, BC, mstart]=findBaseFluorPoints(seq,polyType,doplot)
%% [bcresponse, dff, BC, mstart]=findBaseFluorPoints(seq)
% Returns Baselline corrected response. and dff
%%
% First find 5% lowest values
% calculate mean and range
%
% Fit Linear Curve on all points in 2 x range.
% Look which points are within 2xstd.
% Add these points to fit again.
% repeat x2
%
% Emphasise first points, because photobleaching effect is at the start.
%
% Fit 2x exponential with fminsearch
% Use proper initialisation parameters
% Again look at points within 2 sigma to add/remove from the dataset
% and fit again.
% repeat x3
% polyType:
% 1) is a linear fit or a
% 2) 2exp fit. (default)
% A linear fit is a lot faster.
%%
if nargin<2
    polyType='2exp';
    polyType='none';% {'none','2exp','poly','1expa'} 'autoLinFit'
end


if nargin<3
    doplot=1;
end


%%
if isempty(seq)
    bcresponse=[];
    dff=[];
    BC=[];
    mstart=[];
else
    for i=1:size(seq,1)
        [bcresponse(i,:), dff(i,:), BC(i,:), mstart(i)] = singlefit(seq(i,:)',polyType,doplot);
    end
end
end

function [bcresponse, dff, BC, mstart]=singlefit(seq,polyType,doplot)
% Debug
debug = 0;


if isempty(seq)
    bcresponse=[]; 
    dff=[]; 
    BC=[]; 
    mstart=[];
else
    
    %% First find 5% lowest values
    % calculate mean and range
    [sseq, sseqi]=sort(seq);
    rangeI = ceil(length(sseq)*0.05);
    noiseRange = sseq(rangeI)-sseq(1); % Range of 5% lowest values
    rangeMean = mean(sseq(1:rangeI));
    allPoints = (1:length(seq))';
    points = allPoints(seq<(rangeMean+noiseRange*1));
    minPoints = seq(points);
    
    
    if debug
        figure(3);%subplot(3,1,1);
        hold off;
        plot(allPoints,seq);hold on;
        plot(sseqi(1:rangeI),sseq(1:rangeI),'.');
        plot(points,minPoints,'g');
        plot(allPoints,allPoints*0+rangeMean);
        plot(allPoints,allPoints*0+rangeMean+1*noiseRange);
    end
    
    
    %% fit Linear Curve on all points in 2 x range.
    % Look which points are within 2xstd.
    % Add these points to fit again.
    % repeat x2
    
    
    LMSrico=[points*0+1 points]\minPoints;
    
    if debug
        figure(3);%subplot(3,1,1);
        hold off;
        plot(allPoints,seq);hold on;
        plot(points,minPoints,'g');
        plot(allPoints,LMSrico(2)*allPoints+LMSrico(1));
    end
    
    seq2=seq-(LMSrico(2)*allPoints+LMSrico(1));
    std1=std(seq2(points));
    points2=allPoints(seq2<(0+std1*1));
    minPoints2=seq(points2);
    LMSrico2=[points2*0+1 points2]\minPoints2;  %[1 x1]   [y1]
    %[1 x2]   [y2]
    %[1 . ] \ [ .]
    %[1 . ]   [ .]
    %%
    if debug
        figure(3);%subplot(3,1,2);
        hold off;
        plot(allPoints, seq);
        hold on
        plot(allPoints, seq2);
        plot(points2, minPoints2,'g');
    end
    %%
    seq3=seq-(LMSrico2(2)*allPoints+LMSrico2(1));
    std2=std1;%std(seq3(points2));
    points3=allPoints(seq3<(0+std2*1));
    minPoints3=seq(points3);
    LMSrico3=[points3*0+1 points3]\minPoints3;
    
    if debug
        figure(3);%subplot(3,1,3);
        hold off;
        plot(allPoints,seq);hold on;
        plot(points3,minPoints3,'g');
        plot(allPoints,LMSrico3(2)*allPoints+LMSrico3(1));
    end
    %%
    LMSricox=LMSrico3;
    pointsx=points3;
    oldLengthPointsx=0;
    %while length(pointsx)~=oldLengthPointsx
    oldLengthPointsx=length(pointsx);
    BC=(LMSricox(2)*allPoints+LMSricox(1));
    seqx=seq-BC;
    stdx=std2;%std(seqx(pointsx));
    pointsx=allPoints(seqx<(0+stdx*2));
    minPointsx=seq(pointsx);
    m30=min(length(minPointsx),130); 
    LMSricox=[pointsx*0+1 pointsx]\minPointsx;
    if debug
        figure(3);%subplot(3,1,3);
        hold off;
        plot(allPoints,seq);hold on;
        plot(pointsx,minPointsx,'g');
        plot(allPoints,LMSricox(2)*allPoints+LMSricox(1));
        %drawnow();
    end
    
    switch polyType
        case  'autoZeroFit' % polyType==0
            BC = mean(minPoints);
            bcresponse=seq-BC;
            dff=(seq-BC)./mean(minPoints);
            mstart=minPoints(1);
            
         case  'autoLinFit' % polyType==1
                BC = LMSrico(2)*allPoints+LMSrico(1);
                bcresponse=seq-BC;
                dff=(seq-BC)./LMSrico(1);
                mstart=minPoints(1);
        case {'none','lin','2exp','poly','1expa'}
            %% Emphasise first points, because photobleaching effect is at the start.
            %
            %
            % m30=min(length(minPointsx),130);
            % y=[repmat(minPointsx(1:m30)',1,200) minPointsx'];
            % x=[repmat(pointsx(1:m30)',1,200) pointsx'];
            
            %[a,b,c,p,q]=exp2fit(pointsx',minPointsx');
            %     [a,b,c,p,q]=exp2fit(x',y');
            
            % x=pointsx;
            % y=minPointsx;
            %opts.MaxFunEvals=550;
            
            %% Fit 2x exponential with fminsearch
            % Use proper initialisation parameters
            % Again look at points within 2 sigma to add/remove from the dataset
            % and fit again.
            % repeat x3
            %f = @(b,x) b(1).*exp(b(2).*x)+b(3).*exp(b(4).*x)+b(5);                                     % Objective Function
            %B = fminsearch(@(b) norm(y - f(b,x)), [33; -0.01; 670; -4e-5; 550; ]);%,opts)                  % Estimate Parameters
            %B = fmincon(@(b) norm(y - f(b,x)), [33; -0.01; 670; -4e-5; 550; ],[],[],[0; -5; 0; -5; 0; ],[3300; 0; 6700; 0; 5500; ]);%,opts)                  % Estimate Parameters
            
            %BC=f(B,allPoints);
            
            % LM=length(seq);
            %BC = real(a') + real(b)' .* exp(real(p)'* (1:LM))+real(c)'.*exp(real(q)'*(1:LM)); % using Matlab * expansion
            
            %seqx=seq-BC;
            %stdx=std(seqx(pointsx));
            
            %%
            
            pointsx=allPoints(seqx<(0+stdx*1));
            minPointsx=seq(pointsx);
            
            m30=min(length(minPointsx),130); % For emphasising the (max:130) first points,
            k=0;
            K=3;
            while (k<K) %length(pointsx)~=oldLengthPointsx
                k=k+1
                y=[repmat(minPointsx(1:m30)',1,200) minPointsx'];
                x=[repmat(pointsx(1:m30)',1,200) pointsx'];
                %
                %          y= minPointsx;
                %          x= pointsx;
                
                
                %[a,b,c,p,q]=exp2fit(pointsx',minPointsx');
                %[a,b,c,p,q]=exp2fit(x,y);
                
                
                %     [xData, yData] = prepareCurveData( x, y );
                
                % % Set up fittype and options.
                % ft = fittype( 'exp2' );
                % opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
                % opts.Display = 'Off';
                % opts.StartPoint = [315.971017064752 0.00122537474619184 -378.377442896221 -0.00296185278295226];
                %
                % % Fit model to data.
                % [fitresult, gof] = fit( xData, yData, ft, opts );
                %
                
                totatalRange=max(allPoints)-min(allPoints);
                startExrapolation = (min(pointsx)-min(allPoints))/totatalRange;
                endExtrapolation = (max(allPoints)-max(pointsx))/totatalRange;
                
                if strcmp(polyType,'2exp') && k==K
                    if(startExrapolation + endExtrapolation) > 0.125
                        polyType='lin';
                        warning('Not enoug support for fit of 2exp, and reliable extrapolation. Fallback on linear.')
                    else
                        disp('support OK');
                    end
                end
                
                
                switch polyType
                    case 'none'
                        BC=0;%seq;
                        base=1;
                        stdx=0;
                     case 'lin'
                         LMSricox=[pointsx*0+1 pointsx]\minPointsx;
                         BC = LMSricox(2)*allPoints+LMSricox(1);
                         base=minPoints(1);
                    case '2expOldSlow'
                        f = @(b,x) b(1).*exp(b(2).*x)+b(3).*exp(b(4).*x)+b(5);                                     % Objective Function
                        B = fminsearch(@(b) norm(y - f(b,x)), [33; -0.01; 670; -4e-5; 550; ]);                  % Estimate Parameters
                        %B = fmincon(@(b) norm(y - f(b,x)), [33 -0.01 670 -4e-5 550],[],[],[],[],[0 -5 0 -5 0],[3300  0  6700  0  5500]);%,opts)                  % Estimate Parameters
                        BC=f(B,allPoints);
                        base=B(5);
                    case '2exp'
                        %[bcresponse, dff, BC, mstart]=exp2BleachCorrection(signal,avgSampleSize);
                        x=pointsx';
                        y=minPointsx';
                        
                        [a,b,c,p,q]=exp2fit(x,y);
                        BC = real(a') + real(b)' .* exp(real(p)'* (allPoints))+real(c)'.*exp(real(q)'*(allPoints)); % using Matlab * expansion
                        base=BC(1);
                    case 'poly'
                        opol = 5;
                        [p,s,mu] = polyfit(x,y,opol);
                        BC = polyval(p,allPoints,[],mu);
                        base=p(end);
                    case '1expa'
                        f = @(b,x) b(1).*exp(b(2).*x)+b(3);                         % Objective Function
                        B = fminsearch(@(b) norm(y - f(b,x)), [33; -.01; 100]);     % Estimate Parameters
                        BC=f(B,allPoints);
                        base=B(3);
                end
                
                
                
                %BC = real(a') + real(b)' .* exp(real(p)'* (1:LM))+real(c)'.*exp(real(q)'*(1:LM)); % using Matlab * expansion
                seqx=seq-BC;
                %Do not update stdx, stdx=std(seqx(pointsx));
                dseq=(1.57-atan([0; abs(diff(smooth(seqx)))]));
                pointsx = allPoints((seqx-3*stdx*dseq)<(0+stdx*3));
                stdi=3;
                while (length(pointsx)<rangeI) % update intervalsize until at least 5% samples are there
                     pointsx=allPoints(seqx<(0+stdx*stdi)); % increase std
                     stdi=stdi+1;
                     disp('adapting std');
                end
                if isempty(pointsx)
                    warning('no more points to fitt!!');
                end
                    
                minPointsx=seq(pointsx);
                m30=min(length(minPointsx),130); 
                
                
                if debug
                    figure(3);%subplot(3,1,3);
                    hold off;
                    hold off
                    plot(allPoints,seq);hold on;
                    plot(BC(:),'r','LineWidth',1)
                    plot(pointsx,minPointsx,'g');
                    %     plot(allPoints,LMSricox(2)*allPoints+LMSricox(1));
                    drawnow();
                    %pause(.1);
                end
                
                
            end
            %[a,b,c,p,q]=exp2fit(pointsx,minPointsx);
            
            
            for n=1:1%size(seq,1)
                %n=1;
                if debug
                    %figure;
                    subplot(3,1,3)
                    cla
                    
                    hold off
                    plot(seq,'b','LineWidth',2)
                    hold on
                    plot(BC(:),'g','LineWidth',1)
                    
                    %plot(aSS/2, mmend(n),'or','LineWidth',6)
                    plot(pointsx, minPointsx,'k','LineWidth',1)
                    %plot(ls-aSS/2, mmend(n),'or','LineWidth',6)
                    % plot([aSS/2, ls-aSS/2],[mstart(n) mend(n)],'g','LineWidth',3)
                    %plot(ls-(aSS-1):ls, mend(n)*ones(aSS,1),'k','LineWidth',3)
                    
                    subplot(3,1,2)
                    plot(seq-BC,'k','LineWidth',1)
                end
                if doplot
                    plot(seq-BC,'k','LineWidth',1)
                    drawnow();
                end
                %pause(.3)
            end
            
            bcresponse=seq-BC;
            dff=(seq-BC)./(base);
            try            
                mstart=minPointsx(1);
            catch
                disp('hu?');
            end
            
        otherwise
            error('Unknown method.')
    end
end

end

function test()
%Z:\create\_Rajiv_HTS\NS_2019_017131\NS_620190208_105921_20190208_112135 - Copy\01AP_1st_Analysis\output\SynapseDetails
testData = NS620190208105921e0052RawSynTraces;
for i=8;%2:(width(testData))
    aa=testData.(i);
    
    %tpoints=
    points=findBaseFluorPoints((aa'),1);
    %pause(0);
end
end
