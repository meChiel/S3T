%splash()
function S3T()
splF=figure(...
  ...%'units','normalized','outerposition',[0.3 0.3 0.3 0.3]... % set maximize 
  'GraphicsSmoothing','off',...
  'units','pixels','position',[500 250 1.00*487 1.00*354]... % set maximize    
  );
try
    try
        rr=imread([ctfroot '\S3T\mysplash.png']);
    catch
        rr=imread('mysplash.png');
    end
    %splF=figure;image(rr(8:end-25,35:end-35,:)); axis off;
    image(rr);
    hAx=gca();
    set(hAx,'Unit','normalized','Position',[0.00 0.00 1 1]);
    axis off;
    
    splF.MenuBar='none';
    splF.ToolBar='none';
    splF.Name='S3T: Welcome ... ';
    splF.NumberTitle='off';
    splF.Color=[160 182 211]/255;
    splF.Color=0*[160 182 211]/255;
    try
        javaFrame = get(splF,'JavaFrame');
        try
            javaFrame.setFigureIcon(javax.swing.ImageIcon([ctfroot '\S3T\my_icon.png']));
        catch
            javaFrame.setFigureIcon(javax.swing.ImageIcon(['my_icon.png']));
        end
    catch
        disp('no javafrme found.')
    end
    
catch
    disp('splash screen error.')
end
r=segGUIV1();
r.f2.Visible='on';
figure(splF);
%splF.Color=[0 0 0]/255;
%
%pause(2)
t = timer;
t.StartDelay = 2.3;
t.TimerFcn = @(myTimerObj, thisEvent) tat;
start(t);

function tat(myTimerObj, thisEvent)
splF.delete();
end

end
