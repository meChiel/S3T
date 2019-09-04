function ss=projViewer(tifDir,filter)
global nopf notf oldNopf uia
global defaultdir t rootNode f label1 refreshBtn refreshBtn2 tifViewModeLst
global tifViewMode analysisLst currentAnalysis
global isPlaying
global currentPath
global displayNodeFct;
global setNodeUnprocessedIconFct;
displayNodeFct=@(x) disp(x); % Temporary implementation to be overwritten by structViewer immplementation.


if nargin==0
    d=uigetdir('defaultdir');
    d=[d '\'];
else
    if strcmp(tifDir(end),'\')
        d=tifDir;
    else
        d=[tifDir '\']
    end
end

if nargin<2
    chooseFilter(d);
end


defaultdir=d;

%%
startt();
%%
    function startt()
        
        %% Create the figure:
        f=uifigure('Name','ProjViewer','Resize','on','AutoResizeChildren','off');
        f.Name='S3T: Project Viewer';
        label1 = uilabel(f,...
            'Text', ['Files loading:'],...
            'Position', [20 20 200 20] );
        refreshBtn = uibutton(f,'push','text','updating ...','Position',[220 20 100 20],'ButtonPushedFcn', @doRefresh2);%(btn,event) refresh(btn,ax));
        openBtn = uibutton(f,'push','text','Open','Position',[468 130 100 20],'ButtonPushedFcn', @openData);%(btn,event) refresh(btn,ax));
        explorerBtn = uibutton(f,'push','text','Explorer','Position',[468 110 100 20],'ButtonPushedFcn', @openExplorer);%(btn,event) refresh(btn,ax));
        processBtn = uibutton(f,'push','text','PROCESS','Position',[468 90 100 20],'ButtonPushedFcn', @openProc);%(btn,event) refresh(btn,ax));
        reprocessBtn = uibutton(f,'push','text','rePROCESS','Position',[468 70 100 20],'ButtonPushedFcn', @reProcess);%(btn,event) refresh(btn,ax));
        refreshBtn2 = uibutton(f,'push','text','Full update','Position',[220 0 100 20],'ButtonPushedFcn', @refresh);%(btn,event) refresh(btn,ax));
        %%
        pp{1}=d;
        
        
       % refreshBtn3 = uibutton(f,'push','text','Full update','Position',[220 30 100 20],'ButtonPushedFcn', @setIcon);%(btn,event) refresh(btn,ax));
        
        
        %% Old recursive implementation: does not work
        %[ss, tifdirs]=structSubDir(pp);
        uia=uiaxes(f,'Position',[820 200 500 500]); % The figure area
        %plot(uia,[2:200]);
%        imagesc(uia,imread('F:\share\data\Rajiv\2018\02-03-2018\plate1\Protocol11220180302_110630_20180302_112921\1AP_Analysis\Protocol11220180302_110630_e0002.tif_avg.png'));
        colormap(uia,'hot');
        axis(uia,'equal');
        axis(uia,'off');
        t = uitree(f,'Position',[20 150 550 550]);
        tifViewModeLst = uilistbox(f,'Value',{'avg'},'Items',{'mask','avg','play','analysis','signals','temp','layout'},'Position',[20 130 100 20],'ValueChangedFcn', @changeTifViewMode);
        AL={};%getAnalysises(currentPath);
        analysisLst = uilistbox(f,'Items',AL,'Position',[120 130 200 20],'ValueChangedFcn', @changeAnalysis);
        fullUpdate();
        
       
    end

    function AL = getAnalysises(currentPath)
        gg=strfind(currentPath,'\');
        % Find the _Analysis folders/xml files.
        if ~isempty(gg)
        ttt=dir([currentPath(1:gg(end)) '*_Analysis']); % This takes a few ms which can be avoided, but is OK for now.
        for i=1:size(ttt,1)
            AL{i} = ttt(i).name(1:end-9);
        end
        else
            AL={};%AL={'No Analysises'};
        end
    end

    function openExplorer(e,f,g)
      if exist(currentPath ,'file')
        eval(['!explorer.exe /select,"'  currentPath '" &']);
      else
          if strcmp(currentPath(end-3:end),'.tif')
              gg=strfind(currentPath,'\');
              eval(['!explorer.exe "'  currentPath(1:gg(end)) '" &']);
          else
              eval(['!explorer.exe /select,"'  currentPath '" &']);
          end
      end
    end

    function openData(e,f,g)
        chooseAnalysis(currentPath);
    end


    function openProc(e,f,g)
        segGUIV1(currentPath);
    end

    function reProcess(e,f,g)
        if isdir(currentPath)
            if isdir([currentPath '\process\'])
                rmdir([ currentPath '\process\' ],'s');
            else
                 disp('No process dir found.');
            end
        else
            gg= strfind(currentPath,'\');
            delete([currentPath(1:gg(end)) 'process\process_' currentPath((gg(end)+1):end) '.txt']);
        end
        setNodeUnprocessedIconFct(currentPath);
        %segGUIV1(currentPath);
    end

    function changeAnalysis(e,f,g)
        currentAnalysis = analysisLst.Value; 
        displayNodeFct(currentPath);
    end



    function changeTifViewMode(e,f,g)
        tifViewMode = tifViewModeLst.Value; 
        displayNodeFct(currentPath);
    end

    function setIcon(hObject, eventdata, handles, varargin)
        %% DOES NOT WORK
        %handles= guidata(gcbo)
        jFrame=get(hObject.Parent,'javaframe');
        jicon=javax.swing.ImageIcon('my_icon.png');
        jFrame.setFigureIcon(jicon);
        handles.output = hObject;
        guidata(hObject, handles);
        disp('just to say I am here');
        
        
    end
    function fullUpdate()
        [notf, nopf]=updateStat();
        refreshBtn.Text='indexing ...';
        ss = updateStruct(notf,nopf);
        refreshBtn.Text='Updating ...';
        try
            t.delete();
        catch e
            disp(e.message)
        end
        fff=strfind(d(1:end-1),'\');
        dlastpart=d(fff(end):end);
        [t, rootNode] = structViewer(ss,['experiment: ' dlastpart],f,d,uia);
        oldNopf=nopf;
        refreshBtn.Text='Update';
    end
    function ss= updateStruct(notf,nopf)
        
        %% Number of tif files
        ss=[];
        for i=1:length(notf)
            rr =notf(i).folder(length(d):end);
            rr2=[rr '\'];
            ff=strfind(rr2,'\');
            
            % Cut the path on each '\' and check if each dir name is a valid struct field
            % name.
            rr3=[];
            for j=2:length(ff)
                rr3{j-1}=text2OKname(rr2(ff(j-1)+1:ff(j)-1));
            end
            rr4=[];
            for j=1:length(rr3)
                rr4=[rr4 '.' rr3{j}];
            end
            try
            kk=notf(i);
            eval(['ss' rr4 '.' text2OKname(kk.name) '.processed = 0;']);
            catch e
                disp(e.message)
            end
        end
        ss=setProcess(ss,nopf);
        
        
    end
%%
    function ss=setProcess(ss,nopf)
        for i=1:length(nopf)
            % Number of processed files
            folder = nopf(i).folder;
            folderStructPath = convertPath2StructFormat(folder,d);
            eval(['ss' folderStructPath '.' text2OKname(nopf(i).name(1+length('process_'):end-length('.txt'))) '.processed = 1;']);
        end
    end
%%


%% [notf, nopf]=updateStat(btn,ax)
    function [notf, nopf]=updateStat(btn,ax)
        %% New search in all subdir
        label1.Text=['Counting files...!' ];
        drawnow();
        notf=dir([d '\**\*.tif']); % Number of tif files
        nopf=dir([d '\**\process\process_*.tif.txt']); % Number of processed files
        
        
        notf=notf(~[notf.isdir]); %remove dir called *.tif
        nopf=nopf(~[nopf.isdir]); %remove dir called *.tif
        
        % uifig syntax
        label1.Text=['Files processed: ' num2str(length(nopf)) '/' num2str(length(notf))];
        
    end

%% New faster? refresh routine:

    
    function doRefresh2(a,b,c)
      %  refresh2(nopf,notf,oldNopf);
        
        ttt = timer('StartDelay', 4, 'Period', 4, 'TasksToExecute', 4, ...
          'ExecutionMode', 'fixedSpacing');
       ttt.TimerFcn = @doRefresh3;
       start(ttt);
    end

    function doRefresh3(a,b,c)
        refresh2(nopf,notf,oldNopf);
    end


    function refresh2(nopf,notf,oldNopf)
        disp('r start');
        for i=1:1
            refreshBtn.Text=['Updating .'];
            prevLength=length(nopf);
            nopf=dir([d '\**\process_*.tif.txt']); % Number of processed files
            curLength=length(nopf);
            if curLength~=prevLength
                disp('updating');
                label1.Text=['Files processed: ' num2str(length(nopf)) '/' num2str(length(notf))];
                for j=1:length(nopf) %for all process files
                    intree=0;
                    for k=1:length(oldNopf) % Compare with old process files list
                        if strcmp([nopf(j).folder nopf(j).name],[oldNopf(k).folder oldNopf(k).name])
                            % Was already in tree
                            intree=1;
                        end
                    end
                    if intree
                        % was in tree: do nothing
                    else
                        % Add to the struct and UItree
                        disp('adding')
                        % change struct
                        rr4=convertPath2StructFormat(nopf(j).folder,d);
                        fp1=['ss' rr4 '.' ];
                        fptt=notf(j);
                        fp2a=fptt.name;
                        fp2 = text2OKname(fp2a);
                        fp3=['.processed = 1'];
                        % thecommand=['ss' rr4 '.' text2OKname(notf(j).name) '.processed = 1'];
                        thecommand=[fp1 fp2 fp3];
                        eval(thecommand);
                        % change UI
                        rr4=nopf(j).folder(length(d):end-length('process')); %relative path of file
                        sep=strfind(rr4,'\');% Cut in pieces to traverse the UITree
                        m=t.Children(1);
                        for p=2:length(sep)%traverse the UItree
                            ppp=rr4(sep(p-1)+1:sep(p)-1);
                            ll=find(strcmp(ppp,{m.Children.Text}));
                            m=m.Children(ll);
                        end
                        ll=find(strcmp(nopf(j).name(9:end-4),{m.Children.Text}));
                        nopf(j).name(9:end-4)
                        m=m.Children(ll);
                        m.Icon = 'processsed_icon.png';
                    end
                end
                oldNopf=nopf;
            end
            pause(.1);
            refreshBtn.Text=['Updating  '];
            drawnow();
            %pause(.1);
        end
        refreshBtn.Text=['Update  '];
        disp('r stop');
    end

%% refresh
    function refresh(btn,ax,fd)
        if 0
            refresh2()
        else
            if 1
                fullUpdate();
            else
                refreshBtn.Text=['Updating ...']
                close(f)
                start();
                
                [notf, nopf]=  updateStat();
                ss= updateStruct(notf,nopf);
                %update with reuse of tree does not work correctly (yet).
                t=[];
                [t, rootNode]= structViewer(ss,'experiment',f,d,uia);%,t,rootNode);
                %faster
                %set(rootNode.Children(6).Children(10), 'Icon', 'processsed_icon.png');
            end
        end
    end
end
%% fig synatax
% uicontrol(,'Style', 'Text', ...
%     'String', ['Files processed: ' num2str(length(nopf)) '/' num2str(length(notf))],...
%     'Position', [20 20 200 20] ); % file name