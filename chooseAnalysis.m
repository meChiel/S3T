function chooseAnalysis(dd)
f=figure;
 set(f,'MenuBar', 'none');
    set(f,'toolBar', 'none');
    set(f,'NumberTitle','off');
    
uicontrol('Style', 'Text', 'String',  {'Choose Analysis:'},...
    'Position', [150 290 250 30], 'Fontsize',16,...
    ...%'BackgroundColor',[.35 .35 .38],
    'ForegroundColor',[.05 .05 .08] );
if strcmp(dd(end-3:end),'.tif') % Check if it is a file
    gg=strfind(dd,'\');    
    dname=dd(1:gg(end));
    fname=dd((gg(end)+1):end);
    ad=dir([dname '*_Analysis\' fname '_mask.png']); % Analysis direct.
    for i=1:size(ad,1)
        gg=strfind(ad(i).folder(),'\');
        ad(i).name=ad(i).folder((gg(end)+1):end);
    end
    isfile=1;
else % or it's a dir
    ad=dir([dd  '\*_Analysis']); %Analysis direct.
    isfile=0;
end

for i=1:size(ad,1)
    endA=strfind(ad(i).name,'_Analysis');
    al{i}=ad(i).name(1:(endA-1)); % Generate analysis List
end

analysisLst = uicontrol('Style', 'List', 'String', al,...
    'Position', [150 180 250 100], ...
    ...%'BackgroundColor',[.35 .35 .38],
    'ForegroundColor',[.05 .05 .08] );


ctButton = uicontrol('Style', 'pushbutton', 'String',  {'Continue..'},...
    'Position', [150 130 250 30], ...
    ...%'BackgroundColor',[.35 .35 .38],
    'ForegroundColor',[.05 .05 .08], ...
    'Callback', @ct);

    function ct(e,g,j)
        ctButton.String='OK, just a sec.';
        pause(.01)
        listSelection=analysisLst.String(analysisLst.Value)
        if isfile % Check if it is a file
            dataViewer( [dname listSelection{1} '_Analysis\output\SynapseDetails\' fname(1:end-4) '_PPsynapses.txt']); % Analysis direct.)
        else % It's a dir
            viewTraces([dd '\'  listSelection{1} '_Analysis\output'  ])
        end
    end 
end
         
