function ss=projViewer(tifDir)
global nopf notf oldNopf uia
global defaultdir t rootNode f label1 refreshBtn refreshBtn2
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
defaultdir=d;
% d='Y:\data\rajiv\';
% d='Y:\data\Rajiv\2018\02-03-2018\plate1\Protocol11220180302_110630_20180302_112921\';
% d='Y:\data\Rajiv\';
% d='Y:\data\Rajiv\20171027\';
%d='Y:\data\Rajiv\';

% projViewer_OpeningFcn;
%     function projViewer_CreateFcn(hObject, eventdata, handles, varargin)
%
%     end
%%
start();
%%
    function start()
        
        %% Create the figure:
        f=uifigure('Name','ProjViewer','Resize','on','AutoResizeChildren','off');
        f.Name='S3T: Project Viewer';
        label1 = uilabel(f,...
            'Text', ['Files loading:'],...
            'Position', [20 20 280 20] );
        refreshBtn = uibutton(f,'push','text','updating ...','Position',[220 20 100 20],'ButtonPushedFcn', @doRefresh2);%(btn,event) refresh(btn,ax));
        refreshBtn2 = uibutton(f,'push','text','Full update','Position',[220 0 100 20],'ButtonPushedFcn', @refresh);%(btn,event) refresh(btn,ax));
        %%
        pp{1}=d;
        
       % refreshBtn3 = uibutton(f,'push','text','Full update','Position',[220 30 100 20],'ButtonPushedFcn', @setIcon);%(btn,event) refresh(btn,ax));
        
        
        %% Old recursive implementation: does not work
        %[ss, tifdirs]=structSubDir(pp);
        uia=uiaxes(f,'Position',[820 200 500 500]);
        %plot(uia,[2:200]);
%        imagesc(uia,imread('F:\share\data\Rajiv\2018\02-03-2018\plate1\Protocol11220180302_110630_20180302_112921\1AP_Analysis\Protocol11220180302_110630_e0002.tif_avg.png'));
        colormap(uia,'hot');
        axis(uia,'equal');
        axis(uia,'off');
        t = uitree(f,'Position',[20 150 550 550]);
        fullUpdate();
        
       
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
        [t, rootNode] = structViewer(ss,'experiment',f,d,uia);
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
        nopf=dir([d '\**\process_*.tif.txt']); % Number of processed files
        
        
        notf=notf(~[notf.isdir]); %remove dir called *.tif
        nopf=nopf(~[nopf.isdir]); %remove dir called *.tif
        
        % uifig syntax
        label1.Text=['Files processed: ' num2str(length(nopf)) '/' num2str(length(notf))];
        
    end

%% New faster? refresh routine:

    function doRefresh2(a,b,c)
        refresh2(nopf,notf,oldNopf);
    end
    function refresh2(nopf,notf,oldNopf)
        
        disp('r start');
        for i=1:100
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
            refreshBtn.Text=['Updating  '];
            drawnow();
            pause(1);
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