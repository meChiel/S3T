% n = dir('doc_*.txt');
function n01=natsort(n)
n1 = {n.name};
%z = regexp(n1,'(?<=iGlu_)\d*(?=\_analysis.txt)','match');
z = regexp(n1,'\d*','match');
z1 = str2double(cat(1,z{:}));
if size(z,2)~=size(z1,1)
    error('Files without names can''t be naturally sorted')
end
[~,ii] = sort(z1(:,end));
%n01.name = n1(ii);
n01 = n(ii);
