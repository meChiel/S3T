function viewer(B)
    % Create a figure and axes
    f = figure('Visible','off');
    f2 = figure('Visible','off');
    figure(f);
    ax = axes;%('Units','pixels');
    axis image;
    %surf(peaks)
    cframe=1;
    imagesc(B(:,:,cframe));
    ax.Visible='off';
    %axi.	= 'equal';
    
    maxB=max(B(:));
    minB=min(B(:));
    
      % Create push button
    btn = uicontrol('Style', 'pushbutton', 'String', 'Play',...
        'Position', [20 20 50 20],...
        'Callback', @playy);       
    
    sel = uicontrol('Style', 'pushbutton', 'String', 'Plot',...
        'Position', [20 40 50 20],...
        'Callback', @synplot);       
  
sld = uicontrol('Style', 'slider',...
        'Min',1,'Max',size(B,3),'Value',1,...
        'Position', [10 00 420 20],...
        'Callback', @surfzlim); 
    
    f.Visible='on';
    
    
    function synplot(source,event)
       [mouse.X,mouse.Y]=ginput(1)
        try figure(f2);
        catch
                f2=figure;
        end
         f2.Visible='on';
       plot(squeeze(B(ceil(mouse.Y),ceil(mouse.X),:)));
        
    end
    
    function playy(source,event)
        for k=cframe:size(B,3)
           imagesc(B(:,:,k)); 
            pause(.03);
            drawnow;
        end
    end
    function surfzlim(source,event)
        cframe=ceil(source.Value);
        %image((B(:,:,cframe)-minB)/(maxB-minB)*64);
        imagesc(B(:,:,cframe));
    end
end