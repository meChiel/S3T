rr=imread('mysplash.png');
%splF=figure;image(rr(8:end-25,35:end-35,:)); axis off;
splF=figure;image(rr); axis off;

splF.MenuBar='none';
splF.ToolBar='none';
splF.Name='S3T: Loading ... ';
splF.NumberTitle='off';
splF.Color=[160 182 211]/255;
%splF.Color=[0 0 0]/255;
%
%pause(2)
t = timer;
t.StartDelay = 3;
t.TimerFcn = @(myTimerObj, thisEvent)splF.delete;
start(t)
