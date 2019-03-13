% n = dir('doc_*.txt');
function n01=natsort(n)
if ~isempty(n)
    n1 = {n.name};
    %z = regexp(n1,'(?<=iGlu_)\d*(?=\_analysis.txt)','match');
    z = regexp(n1,'\d*','match'); %find all the number is the filename
    if isempty(z{1})
        z={{nan}};
    end
    try
        % z1 = str2double(cat(1,z{2:end})); % concatenate numbers into a number,
        % doesn't work when some are with 1 number and other with 2 numbers.
        
        z1=[];
        for i=1:length(z)
            l=z{i};
            z1(i) = str2double(cat(2,l{:})); % concatenate numbers into a number
        end
    catch e
        disp (e.message);
    end
    if size(z,2)~=size(z1,2)
        warning(['Files without names can''t be naturally sorted: ' n1{1}])
    end
    [~,ii] = sort(z1(:));%z1(:,end));
    %n01.name = n1(ii);
    n01 = n(ii);
else % if isempty
    n01=n;
end
