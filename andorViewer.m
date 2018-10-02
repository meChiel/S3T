%% Creates a dynamic tree view of the Andor file.
function andorViewer(tt)

if nargin<1
    [fn dn]=uigetfile('*.txt');
    fid = fopen([dn fn]);
    tt=fread(fid, inf, 'uint8=>char');
    fclose(fid);
end
if 0 % for test
    fid = fopen('NS_720180814_105523.txt');
    tt=fread(fid, inf, 'uint8=>char');
    fclose(fid);
end    
    % Get paragraph between begin[ and End]
    expression = {'\[(.*?)End\]'};
    fieldsx = regexpi(tt',expression,'match');
    expression = {'(.*?)\['};
    rooTxt = regexpi(tt',expression,'match');
    
    f = uifigure('Name','Andor Viewer');
    t = uitree(f,'Position',[20 20 150 150]);

    record = uitreenode(t,'Text','Andor Recording','NodeData',[]);

    itxt=textscan(rooTxt{1}{1},'%s','Delimiter','\n');%inside Text
    for j=1:length(itxt{1})
        rootTxtNode{j} = uitreenode(record,'Text',itxt{1}{j},'NodeData',[]);
    end
    
    
    for i=1:length(fieldsx{1})
            % extract title
            ltxt=fieldsx{1}{i};
            ttlEnd=strfind(ltxt,']');
            ttl=ltxt(2:(ttlEnd(1)-1));%title
            ttlNode{i} = uitreenode(record,'Text',ttl,'NodeData',[]);
            itxt=textscan(ltxt,'%s','Delimiter','\n');%inside Text
            for j=2:(length(itxt{1})-1)
                iTxtNode{i,j} = uitreenode(ttlNode{i},'Text',itxt{1}{j},'NodeData',[]);
            end
        end
    

% Assign Tree callback in response to node selection
t.SelectionChangedFcn = @nodechange;

% Expand the tree
%  expand(t);

    function nodechange(src,event)
        node = event.SelectedNodes;
        display(node.NodeData);
    end
end