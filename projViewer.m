function ss=projViewer(tifDir)
global defaultdir
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
d='Y:\data\rajiv\';
d='Y:\data\Rajiv\2018\02-03-2018\plate1\Protocol11220180302_110630_20180302_112921\';
d='Y:\data\Rajiv\';
d='Y:\data\Rajiv\20171027\';
d='Y:\data\Rajiv\2018\';



%% Create the figure:
f=uifigure('Name','ProjViewer');
label1 = uilabel(f,...
    'Text', ['Files loading:'],...
    'Position', [20 20 200 20] );
refreshBtn = uibutton(f,'push','text','update','Position',[220 20 100 20],'ButtonPushedFcn', @refresh);%(btn,event) refresh(btn,ax));
%%
pp{1}=d;


%% Old recursive implementation: does not work
%[ss, tifdirs]=structSubDir(pp);

[notf, nopf]=updateStat();
ss = updateStruct(notf,nopf);
[t, rootNode] = structViewer(ss,'experiment',f);
oldNopf=nopf;
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
            eval(['ss' rr4 '.' text2OKname(notf(i).name) '.processed = 0']);
        end
        ss=setProcess(ss,nopf);
        
        
    end

%%
    function ss=setProcess(ss,nopf)
        for i=1:length(nopf)
            % Number of processed files
            folder = nopf(i).folder;
            folderStructPath = convertPath2StructFormat(folder,d);
            eval(['ss' folderStructPath '.' text2OKname(nopf(i).name(1+length('process_'):end-length('.txt'))) '.processed = 1']);
        end
    end

%%
 


%% [notf, nopf]=updateStat(btn,ax)
    function [notf, nopf]=updateStat(btn,ax)
        %% New search in all subdir
        label1.Text=['Files processed: ' 'x/x' ];
        drawnow();
        notf=dir([d '\**\*.tif']); % Number of tif files
        nopf=dir([d '\**\process_*.tif.txt']); % Number of processed files
        
        
        notf=notf(~[notf.isdir]); %remove dir called *.tif
        nopf=nopf(~[nopf.isdir]); %remove dir called *.tif
        
        % uifig syntax
        label1.Text=['Files processed: ' num2str(length(nopf)) '/' num2str(length(notf))];
        
    end

%% New faster? refresh routine:

    function refresh2()
        disp('r start');
        for i=1:100
            prevLength=length(nopf);
            nopf=dir([d '\**\process_*.tif.txt']); % Number of processed files
            curLength=length(nopf);
            if curLength~=prevLength
                disp('updating');
                label1.Text=['Files processed: ' num2str(length(nopf)) '/' num2str(length(notf))];
                for j=1:length(nopf)
                    intree=0;
                    for k=1:length(oldNopf)
                        if strcmp([nopf(j).folder nopf(j).name],[oldNopf(k).folder oldNopf(k).name])
                            % Was already in tree
                            intree=1;
                        end
                    end
                    if intree
                        % was in tree: do nothing
                    else
                        % Add to the tree and struct
                        disp('adding')
                         rr4=convertPath2StructFormat(nopf(j).folder,d);
                        eval(['ss' rr4 '.' text2OKname(notf(j).name) '.processed = 1']);
                        rr4=nopf(j).folder(length(d):end-length('process'))
                        sep=strfind(rr4,'\');
                        m=t.Children(1);
                        for p=2:length(sep)
                            ppp=rr4(sep(p-1)+1:sep(p)-1);               
                            ll=find(strcmp(ppp,{m.Children.Text}));
                            m=m.Children(ll);
                        end
                        ll=find(strcmp(nopf(j).name(9:end-4),{m.Children.Text}));
                        m=m.Children(ll);
                        m.Icon = 'processsed_icon.png';
                    end
                end
                oldNopf=nopf;
            end
            pause(1);
        end
        disp('r stop');    
    end

%% refresh
    function refresh(btn,ax,d)
        if 1
        refresh2()
        else
        [notf, nopf]=  updateStat();
        ss= updateStruct(notf,nopf);
        %update with reuse of tree does not work correctly (yet).
        t=[];
        [t, rootNode]= structViewer(ss,'experiment',f);%,t,rootNode);
        %faster
        %set(rootNode.Children(6).Children(10), 'Icon', 'processsed_icon.png');
        end
    end
end
%% fig synatax
% uicontrol(,'Style', 'Text', ...
%     'String', ['Files processed: ' num2str(length(nopf)) '/' num2str(length(notf))],...
%     'Position', [20 20 200 20] ); % file name