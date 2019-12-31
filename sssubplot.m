function pp=sssubplot(nx,ny,n,xdata,ydata,labeltext)%pp,ny,nx,n,vh,
% Creates a scrollable array of figures/axis;


vh=0;
%pp{n} = plot(xdata,ydata);

dx=1/nx;
dy=1/ny;
figure
createButtons();



    
    function update()
        for n=1:(nx*ny)
            px = mod(n,nx)+0;
            py = ceil(n/nx);
            pp{n}.Position = [px/nx vh+py/nx dx dy];
            axis off;
        end
    end


    function createButtons()
        uicontrol('Style', 'pushbutton','Max',10,'Min',1, 'String', {'UP'},...
            'Position', [10 60 10 15], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
            'Visible','on','CallBack',@moveUp );
        
        
        uicontrol('Style', 'pushbutton','Max',10,'Min',1, 'String', {'DWN'},...
            'Position', [10 40 10 15], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
            'Visible','on','CallBack',@moveDown );
        
        for n=1:(nx*ny)
            pp{n}=axes();%.position = [px/nx vh+py/nx dx dy];
            px = mod(n,nx)+1;
            py = ceil(n/nx);
            pp{n}.Position = [px/nx vh+py/nx dx dy];
            try
                %plot(xdata{n},ydata{n});
                  thecolor = [0 0 1; 1 0 0; 0 1 0; 1 1 0; 0 1 1; 1 0 1];%colormap(jet);
                 bar(xdata{n},ydata{n},1,'facecolor',thecolor(mod(n-1+1,6)+1,:));%,'width',1); %PixelAverage,rawAverageResponse
               try
                   lb=labeltext{n};
                lb=strrep(lb,'_',' ');
                title(lb);
               catch
               end
                aa=axis();
                axis([aa(1) aa(2) -.5 1]);
                axis off;
                
            catch
                plot(0)
            end
            
            try
              
            catch
            end
            axis off;
        end
    end
    function moveUp(f,g,h)
        vh=vh+.1;
        update();
    end

    function moveDown(f,g,h)
        vh=vh-.1;
        update();
    end
end


function test
%% test
nx=6; ny=10; n=[1:60];vh=0;xdata=[];ydata=[];
for i=1:60
xdata{i}=rand(1,30);ydata{i}=rand(1,30);end
xdata{5}=[1]
sssubplot(nx,ny,n,xdata,ydata);%pp,ny,nx,n,vh,
end