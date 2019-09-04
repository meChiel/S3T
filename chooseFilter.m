function dfp =  chooseFilter(dd)
if nargin==0
    dd=uigetdir('defaultdir');
    dd=[dd '\'];
end
dname=dd;
f=figure;
 set(f,'MenuBar', 'none');
    set(f,'toolBar', 'none');
    set(f,'NumberTitle','off');
    
uicontrol('Style', 'Text', 'String',  {'Choose Filter:'},...
    'Position', [150 290 250 30], 'Fontsize',16,...
    ...%'BackgroundColor',[.35 .35 .38],
    'ForegroundColor',[.05 .05 .08] );
if strcmp(dd(end-3:end),'.tif') % Check if it is a file
    gg=strfind(dd,'\');    
    dname=dd(1:gg(end));
    fname=dd((gg(end)+1):end);
    ad=dir([dname '*_Filter\' fname '_mask.png']); % Analysis direct.
    for i=1:size(ad,1)
        gg=strfind(ad(i).folder(),'\');
        ad(i).name=ad(i).folder((gg(end)+1):end);
    end
    isfile=1;
else % or it's a dir
    ad=dir([dd  '\*_Filter.pson']); %Analysis direct.
    isfile=0;
end
al={''};
for i=1:size(ad,1)
    endA=strfind(ad(i).name,'_Filter.pson');
    al{i}=ad(i).name(1:(endA-1)); % Generate analysis List
end

filterLst = uicontrol('Style', 'List', 'String', al,...
    'Position', [150 180 250 100], ...
    ...%'BackgroundColor',[.35 .35 .38],
    'ForegroundColor',[.05 .05 .08] );


ctButton = uicontrol('Style', 'pushbutton', 'String',  {'Continue..'},...
    'Position', [150 130 250 30], ...
    ...%'BackgroundColor',[.35 .35 .38],
    'ForegroundColor',[.05 .05 .08], ...
    'Callback', @ct);
chosen =0 ;
while (~chosen)
pause(0.1);
end

    function ct(e,g,j)
        ctButton.String='OK, We built the database can take some time.';
        pause(.01)
           fid = fopen('default_Filter.pson', 'r');
    c = fread(fid,inf,'uint8=>char')';
 
    fclose(fid);
    
        listSelection=filterLst.String(filterLst.Value)
        if isfile % Check if it is a file
            dfp = [dname listSelection{1}];
            %dataBaseViewer;%( [dname listSelection{1}]);% '_Filter\output\SynapseDetails\' fname(1:end-4) '_PPsynapses.txt']); % Analysis direct.)
            
        else % It's a dir
            dfp = [dname '\' listSelection{1} '_Filter.pson'];
            %dataBaseViewer;%( [dname listSelection{1}]);
        end
        chosen = 1;
    end 
end
         
