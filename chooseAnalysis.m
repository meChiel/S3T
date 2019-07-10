function chooseAnalysis(dd)
f=figure;
 set(f,'MenuBar', 'none');
    set(f,'toolBar', 'none');
    set(f,'NumberTitle','off');
    
uicontrol('Style', 'Text', 'String',  {'Choose Analysis:'},...
    'Position', [150 290 250 30], 'Fontsize',16,...
    ...%'BackgroundColor',[.35 .35 .38],
    'ForegroundColor',[.05 .05 .08] );

ad=dir([dd  '\*_Analysis']); %Analysis direct.

for i=1:size(ad,1)
    endA=strfind(ad(i).name,'_Analysis');
    al{i}=ad(i).name(1:(endA-1));
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
        viewTraces([dd '\'  listSelection{1} '_Analysis\output'  ])
    end 
end
         
