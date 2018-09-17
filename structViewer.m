function structViewer(s,name)
if nargin<2
    name='struct';
end
f = uifigure;
t = uitree(f,'Position',[20 20 150 150]);

rootNode = uitreenode(t,'Text',name,'NodeData',[]);
if length(s)~=1
    s3=s;
    for pk=1:length(s3)
        s=s3(pk);
         rNode2{pk} = uitreenode(rootNode,'Text',[ name ': ' '[' num2str(pk) ']'],'NodeData',[]);
        createStructFieldNodes(rNode2{pk},s,[name ': ' num2str(pk)]);
    end
else
    
    createStructFieldNodes(rootNode,s,name);
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
                L1Node{i} = uitreenode(parentNode,'Text',fnn{i},'NodeData',[]);
                if length(s2.(fnn{i}))~=1
                    for kk=1:length(s2.(fnn{i})) % create for each element in the array a node
                        Node2{i,kk} = uitreenode(L1Node{i},'Text',[fnn{i} '[' num2str(kk) ']'],'NodeData',[]);
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
            leaveNode = uitreenode(parentNode,'Text',[fnj ': ' s2],'NodeData',[s2]);
        else
            if (isnumeric(s2))
                leaveNode = uitreenode(parentNode,'Text',[fnj ': ' num2str(s2)],'NodeData',[s2]);
            else
                if (islogical(s2))
                    leaveNode = uitreenode(parentNode,'Text',[fnj ': ' num2str(s2)],'NodeData',[]);
                else
                    leaveNode = uitreenode(parentNode,'Text',[fnj ': ' 'unsupported format'],'NodeData',[]);
                end
            end
        end
        
    end

    function nodechange(src,event)
        %check here if the particular node has some more information, which
        %can be retreived.
        node = event.SelectedNodes;
        display(node.NodeData);
    end
end
