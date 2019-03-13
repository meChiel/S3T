function [t,rootNode]=structViewer(s,rootName,f,rootDir,uia,t,rootNode)
% s =struct to view
% rootName: Name of the rootNode
% f is the uifigure handle, if not, a new figure will be created.
% If a dir is shown, the rootDir;


if nargin<3
    f = uifigure;
end
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



set(rootNode,'Icon','my_icon.png')
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
        if (isstr(s2))
            leaveNode = uitreenode(parentNode,'Text',[OKname2text(fnj) ': ' s2],'NodeData',[s2]);
        else
            if (isnumeric(s2))
                if strcmp(fnj,'processed')
                    if s2==0
                        set(parentNode,'Icon','unprocesssed_icon.png');
                    else
                        if s2==1
                            set(parentNode,'Icon','processsed_icon.png');
                        else
                            set(parentNode,'Icon','partiallyprocesssed_icon.png');
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
        %imagesc(uia,imread(['F:\share\data\Rajiv\2018\02-03-2018\plate1\Protocol11220180302_110630_20180302_112921\1AP_Analysis\' node.Text '_avg.png']));
        maskFile=[thePath '_mask.png'];
        if exist(maskFile,'file')
            imagesc(uia,imread(maskFile));
        else
            overviewFile=[thePath '\mask_overview.png'];
            if exist(overviewFile,'file')
                 imagesc(uia,imread(overviewFile));
                 uia.Position=[560,0,800,1100];
            end
        end
    end
end
