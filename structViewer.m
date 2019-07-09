function [t,rootNode]=structViewer(s,rootName,f,rootDir,uia,t,rootNode)
% s =struct to view
% rootName: Name of the rootNode
% f is the uifigure handle, if not, a new figure will be created.
% If a dir is shown, the rootDir;
% t is an existing tree, if not a new tree is created
%
global currentPath
global tifViewMode
tifViewMode='avg';
global displayNodeFct;
displayNodeFct =@displayNode;

if nargin<3
    f = uifigure;
end
% try
%     disp(ctfroot);
% catch
%     disp(pwd);
% end
if nargin<2
    rootName='struct';
end
if nargin<6
    t = uitree(f,'Position',[20 150 550 550]);
    rootNode = uitreenode(t,'Text',rootName,'NodeData',[]);
else
    t = t;
    rootNode=rootNode;
end
%c2 = ;
%c3 = ;


try
    set(rootNode,'Icon',[ctfroot '\S3T\my_icon.png'])
catch
    set(rootNode,'Icon',['my_icon.png'])
end
if length(s)~=1
    s3=s;
    for pk=1:length(s3)
        s=s3(pk);
         rNode2{pk} = uitreenode(rootNode,'Text',[ OKname2text(rootName) ': ' '[' num2str(pk) ']'],'NodeData',[]);
        createStructFieldNodes(rNode2{pk},s,[OKname2text(rootName) ': ' num2str(pk)]);
    end
else
    
    createStructFieldNodes(rootNode,s,rootName);
%    %
%     
%     fn = fieldnames(s);
%     for j=1:(length(fn))
%         if (isstruct(s.(fn{j})))
%             rootTxtNode{j} = uitreenode(rootNode,'Text',fn{j},'NodeData',[]);
%             if length(s.(fn{j}))~=1
%                 for k=1:length(s.(fn{j})) % create for each element in the array a node
%                     rootTxtNode2{j,k} = uitreenode(rootTxtNode{j},'Text',[fn{j} '[' num2str(k) ']'],'NodeData',[]);
%                     % Create for each element in the struct a node.
%                     createStructFieldNodes(rootTxtNode2{j,k},s.(fn{j})(k),fn{j});
%                 end
%             else % Single node: create for each element in the struct a node.
%                 createStructFieldNodes(rootNode{j},s.(fn{j}),fn{j});
%             end
%         else
%             showLeave(rootNode,s.(fn{j}),fn{j})
%         end
%     end
%     

t.SelectionChangedFcn = @nodechange;

end


    function createStructFieldNodes(parentNode,s2,fnj)%s2=s.(fn{j})
        % creates for each field in the struct a node
        %fnn=fieldnames(s.(fn{j}));
        fnn=fieldnames(s2);
        for i=1:(length(fnn))
            %if (isstruct(s.(fn{j})))
            if (isstruct(s2.(fnn{i})))
                %L1Node{j,i} = uitreenode(rootTxtNode{j},'Text',fnn{i},'NodeData',[]);
                L1Node{i} = uitreenode(parentNode,'Text',OKname2text(fnn{i}),'NodeData',[]);
                if length(s2.(fnn{i}))~=1
                    for kk=1:length(s2.(fnn{i})) % create for each element in the array a node
                        Node2{i,kk} = uitreenode(L1Node{i},'Text',[OKname2text(fnn{i}) '[' num2str(kk) ']'],'NodeData',[]);
                        % Create for each element in the struct a node.
                        createStructFieldNodes(Node2{i,kk},s2.(fnn{i})(kk),fnn{i});
                    end
                else % Single node: create for each element in the struct a node.
                    
                    createStructFieldNodes( L1Node{i},s2.(fnn{i}),fnn{i})
                end
            else
                showLeave(parentNode,s2.(fnn{i}),fnn{i})
            end
        end
    end

% If node is a leave display the leave
    function showLeave(parentNode,s2,fnj)%s2=s.(fn{j}),fn{j}
        try ctfroot()
        catch
            ctfroot=pwd;
        end
        if (isstr(s2))
            leaveNode = uitreenode(parentNode,'Text',[OKname2text(fnj) ': ' s2],'NodeData',[s2]);
        else
            if (isnumeric(s2))
                if strcmp(fnj,'processed')
                    if s2==0
                        try
                            set(parentNode,'Icon',[ctfroot '\S3T\unprocesssed_icon.png']);
                        catch
                            set(parentNode,'Icon',['unprocesssed_icon.png']);
                        end
                    else
                        if s2==1
                            try 
                                set(parentNode,'Icon',[ctfroot '\S3T\processsed_icon.png']);
                            catch
                                set(parentNode,'Icon',['processsed_icon.png']);
                            end
                        else
                            try
                                set(parentNode,'Icon',[ctfroot '\S3T\partiallyprocesssed_icon.png']);
                            catch
                                set(parentNode,'Icon',['partiallyprocesssed_icon.png']);
                            end
                        end
                    end
                end 
                leaveNode = uitreenode(parentNode,'Text',[OKname2text(fnj) ': ' num2str(s2)],'NodeData',[s2]);
            else
                if (islogical(s2))
                    leaveNode = uitreenode(parentNode,'Text',[OKname2text(fnj) ': ' num2str(s2)],'NodeData',[]);
                else
                    leaveNode = uitreenode(parentNode,'Text',[OKname2text(fnj) ': ' 'unsupported format'],'NodeData',[]);
                end
            end
        end
        
    end
global isPlaying
    function nodechange(src,event)
        %check here if the particular node has some more information, which
        %can be retreived.
        node = event.SelectedNodes;
        display(node.NodeData);
        display(node.Text);
       %dir(['/**/*' node.Text])
        thePath=node.Text
        p=node.Parent;
        while (isprop(p,'Text')) %Go up the tree, until there is no text field
            thePath=[p.Text '\' thePath];
            p=p.Parent;
        end
        if strcmp(rootDir(end),'\')
            thePath=strrep(thePath,[rootName '\'],rootDir);
        else
            thePath=strrep(thePath,rootName,rootDir);
        end
        thePath=strrep(thePath,rootName,rootDir);
        currentPath = thePath;
        displayNode(thePath,node.Text);
    end

    function displayNode(thePath, nodeText)
        %imagesc(uia,imread(['F:\share\data\Rajiv\2018\02-03-2018\plate1\Protocol11220180302_110630_20180302_112921\1AP_Analysis\' node.Text '_avg.png']));
        maskFile=[thePath '_mask.png'];
        if exist(maskFile,'file')
            %             tifViewMode='mask'
            %             tifViewMode='avg'
            %             tifViewMode='play'
            %             tifViewMode='analysis'
            %             tifViewMode='temp'
            tifViewMode=tifViewMode; %comes from global variable in projViewer
            switch tifViewMode
                case 'mask'
                    imagesc(uia,imread(maskFile));
                    % uia.Position=[700,200,512,512 ];
                    uia.Position=[700,-10,512*2,512*2 ];   
                case 'avg'
                    %t = dir([rootDir '/**/' node.Text '*_avg.png' ]);
                    
                    gg=strfind(thePath,'\');
                    ttt=dir([thePath(1:gg(end)) '*_Analysis']); % This takes a few ms which can be avoided, but is OK for now.
                    io=1;
                    %ttt(io).folder= 'D:\data\Rajiv\m Galenea\Galenea\28-02-2019\NS_320190228_111224_20190228_113209\01AP_1st_Analysis';
                    %ttt(io).folder= thePath(1:gg(end))'D:\data\Rajiv\m Galenea\Galenea\28-02-2019\NS_320190228_111224_20190228_113209\01AP_1st_Analysis';
                    %ttt(1).folder
                    ttt(io).folder=[ttt(io).folder '\' ttt(io).name]
                    ttt(io).name=thePath(gg(end)+1:end);%nodeText;
                    if ~isempty(ttt)
                        for io=1:1%size(t,1)
                        avgFile=[ttt(io).folder '\' ttt(io).name];
                        avgFile=[ttt(io).folder '\' ttt(io).name '_avg.png'];
                        imagesc(uia,imread(avgFile));
                        uia.Position=[700,-10,512*2,512*2 ];    
                        end
                    end
                %    imagesc(uia,imread(maskFile));
                %    uia.Position=[700,200,512,512 ];
                case 'play'
                    M = loadTiff(thePath,1);
                    speed=60;
                    isPlaying=1;
                    for i=1:speed:(size(M,3)-speed)
                        imagesc(uia,max(M(:,:,i+(0:speed)),[],3));
                        uia.Position=[700,-10,512*2,512*2 ]; 
                        drawnow();
                        if isPlaying==0 % Disable continued play when switched before end of movie.
                            break;
                        end
                    end
                    isPlaying=0;
                                    
                case 'analysis'
                    gg=strfind(thePath,'\');
                    % Find the _Analysis folders/xml files.
                    ttt=dir([thePath(1:gg(end)) '*_Analysis']); % This takes a few ms which can be avoided, but is OK for now.
                    io=1;
                    ttt(io).folder = [ttt(io).folder '\' ttt(io).name];
                    ttt(io).name=thePath(gg(end)+1:end);;
                    if ~isempty(ttt)
                        for io=1:1%size(t,1)
                        avgFile=[ttt(io).folder '\' ttt(io).name];
                        avgFile=[ttt(io).folder '\' ttt(io).name '_Analysis.png'];
                        imagesc(uia,imresize(imread(avgFile),'OutputSize',[512,512]));
                        uia.Position=[700,-10,512*2,512*2 ];    
                        end
                    end
               
                case 'temp'
                    gg=strfind(thePath,'\');
                    % Find the _Analysis folders/xml files.
                    ttt=dir([thePath(1:gg(end)) '*_Analysis']); % This takes a few ms which can be avoided, but is OK for now.
                    io=1;
                    ttt(io).folder = [ttt(io).folder '\' ttt(io).name];
                    ttt(io).name=thePath(gg(end)+1:end);;
                    if ~isempty(ttt)
                        for io=1:1%size(t,1)
                        avgFile=[ttt(io).folder '\' ttt(io).name];
                        avgFile=[ttt(io).folder '\' ttt(io).name '_temp.png'];
                        imagesc(uia,imresize(imread(avgFile),'OutputSize',[512,512]));
                        uia.Position=[700,-10,512*2,512*2 ];    
                        end
                    end
 
            end
        else
            overviewFile=[thePath '\mask_overview.png'];
            if exist(overviewFile,'file')
                currentPath = thePath;
                switch tifViewMode
                    case 'mask'
                        imagesc(uia,imresize(imread(overviewFile),'OutputSize',[3102/2.3,5170/2.3]));
                        uia.Position=[560,-600,3102/2.3,5170/2.3 ];
                    case 'analysis'
                        gg=strfind(thePath,'\');
                        % Find the _Analysis folders/xml files.
                        ttt=dir([thePath '\*_Analysis']); % This takes a few ms which can be avoided, but is OK for now.
                        io=1;
                        ttt(io).folder = [ttt(io).folder '\' ttt(io).name];
                       % ttt(io).name=nodeText;
                        if ~isempty(ttt)
                            for io=1:1%size(t,1)
                                %avgFile=[ttt(io).folder '\' ttt(io).name];
                                avgFile=[ttt(io).folder '\' 'analysis_overview.png'];
                                imagesc(uia,imresize(imread(avgFile),'OutputSize',[3102/2.3,5170/2.3 ]));
                                %uia.Position=[700,-10,512*2,512*2 ];
                                uia.Position=[560,-600,3102/2.3,5170/2.3 ]
                            end
                        end
                    case 'avg'
                        ttt=dir([thePath '\*_Analysis']); % This takes a few ms which can be avoided, but is OK for now.
                        io=1;
                        ttt(io).folder = [ttt(io).folder '\' ttt(io).name];
                        %ttt(io).name=nodeText;
                        if ~isempty(ttt)
                            for io=1:1%size(t,1)
                               % avgFile=[ttt(io).folder '\' ttt(io).name];
                                avgFile=[ttt(io).folder '\' 'avg_overview.png'];
                                imagesc(uia,imresize(imread(avgFile),'OutputSize',[3102/2.3,5170/2.3 ]));
                                %uia.Position=[700,-10,512*2,512*2 ];
                                uia.Position=[560,-600,3102/2.3,5170/2.3 ]
                            end
                        end
                            case 'temp'
                        ttt=dir([thePath '\*_Analysis']); % This takes a few ms which can be avoided, but is OK for now.
                        io=1;
                        ttt(io).folder = [ttt(io).folder '\' ttt(io).name];
                        %ttt(io).name=nodeText;
                        if ~isempty(ttt)
                            for io=1:1%size(t,1)
                               % avgFile=[ttt(io).folder '\' ttt(io).name];
                                avgFile=[ttt(io).folder '\' 'temp_overview.png'];
                                imagesc(uia,imresize(imread(avgFile),'OutputSize',[3102/2.3,5170/2.3 ]));
                                %uia.Position=[700,-10,512*2,512*2 ];
                                uia.Position=[560,-600,3102/2.3,5170/2.3 ]
                            end
                        end
                        
                    case 'play'
                         image(uia,imresize(zeros(3102,5170),'OutputSize',[3102/2.3,5170/2.3 ]));
                         uia.Position=[560,-600,3102/2.3,5170/2.3 ]
                         drawnow();
                        playPlateMovie(thePath,0,3,0,8,uia,3);
                end
            end
        end
    end
end
