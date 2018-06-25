function sbsviewer(A,B,allign)
% Create a figure and axes
f2 = figure('Visible','off');
f = figure('Visible','off');
if ~exist('allign','var')
    allign=[1,1,1,1];
end
up=0;
hor=0;

upBorder = allign(1);
downBorder = allign(2);
leftBorder = allign(3);
rightBorder = allign(4);

%surf(peaks)
cframe=1;
showFrame(cframe);

%    ax.Visible='off';
%axi.	= 'equal';

maxA=max(A(:));
minA=min(A(:));

% Create push button
btn = uicontrol('Style', 'pushbutton', 'String', 'Play',...
    'Position', [20 20 50 20],...
    'Callback', @playy);

% Change allignment
upbtn = uicontrol('Style', 'pushbutton', 'String', 'up',...
    'Position', [420 40+20 50 20],...
    'Callback', @upIncrease);

downbtn = uicontrol('Style', 'pushbutton', 'String', 'down',...
    'Position', [420 40-20 50 20],...
    'Callback', @downIncrease);
leftbtn = uicontrol('Style', 'pushbutton', 'String', 'left',...
    'Position', [420-20 40 50 20],...
    'Callback', @leftIncrease);
rightbtn = uicontrol('Style', 'pushbutton', 'String', 'rigth',...
    'Position', [420+20 40 50 20],...
    'Callback', @rigthIncrease);



    function upIncrease(source,event)
        'up'
        up=up+1
        if up<=0
            downBorder=-up+1
            upBorder=1
        else
            upBorder=up+1
            downBorder=1
        end
        showFrame(cframe);
    end

    function downIncrease(source,event)
        'down'
        up=up-1
        if up<=0
            downBorder=-up+1
            upBorder=1
        else
            upBorder=up+1
            downBorder=1
        end
        showFrame(cframe);
    end

    function leftIncrease(source,event)
        hor=hor+1;
        if hor<=0
            rightBorder=-hor+1
            leftBorder=1
            
        else
            leftBorder=hor+1
            rightBorder=1
        end
        showFrame(cframe);
    end

    function rigthIncrease(source,event)
        hor=hor-1;
        if hor<=0
            rightBorder=-hor+1
            leftBorder=1
        else
            leftBorder=hor+1
            rightBorder=1
        end
        showFrame(cframe);
    end

sld = uicontrol('Style', 'slider',...
    'Min',1,'Max',size(B,3),'Value',1,...
    'Position', [10 00 420 20],...
    'Callback', @surfzlim);

f.Visible='on';

f2.Visible='on';
figure(f);

    function showFrame(cframe)
        
        figure(f);
        subplot(1,2,1);
        imagesc(A(downBorder:end-upBorder+1,rightBorder:end-leftBorder+1,cframe));
        %imagesc(A(:,:,cframe));
        
        axA = axes('Units','pixels');
        axis image;
        axA.Visible='off';
        
        subplot(1,2,2);
        imagesc(B(upBorder:end-downBorder+1,leftBorder:end-rightBorder+1,cframe));
        axB = axes('Units','pixels');
        axis image;
        axB.Visible='off';
        drawnow;
        figure(f2);
        
        numPixels=(upBorder-(size(B,1)-downBorder+1))*((leftBorder)-(size(B,2)-rightBorder+1));
        error=sum(sum(sum(abs(A(downBorder:end-upBorder+1,rightBorder:end-leftBorder+1,cframe)-B(upBorder:end-downBorder+1,leftBorder:end-rightBorder+1,cframe)))))/numPixels;
        imagesc(abs(A(downBorder:end-upBorder+1,rightBorder:end-leftBorder+1,cframe)-B(upBorder:end-downBorder+1,leftBorder:end-rightBorder+1,cframe)));
        title(['err=' num2str(error) ' rb=' num2str(rightBorder) ' lb=' num2str(leftBorder) ' ub=' num2str(upBorder) ' db=' num2str(downBorder)]);
        figure(f);
    end

    function playy(source,event)
        for k=cframe:size(B,3)
            cframe = k;
            showFrame(cframe);
            pause(.3);
            drawnow;
        end
    end

    function surfzlim(source,event)
        cframe=ceil(source.Value);
        showFrame(cframe);
        %        image((B(:,:,cframe)-minB)/(maxB-minB)*64);
    end
end