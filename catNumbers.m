function number = catNumbers(textwithNumbersIn,nn)
% number = catNumbers(textwithNumbersIn,nn)
% Extract all the numeric numbers out of a string and concatenates them to
% a number. the argument 
% nn defines, to keep only the last n numbers.
%
% See also extractNumber and extractNumbers
if exist('nn','var')
    n = nn-1;
end

r=[];
if iscell(textwithNumbersIn)
    for j=1:length(textwithNumbersIn)
        k=[];
        t=textwithNumbersIn{j};
        for i=1:length(t)
            p=str2num(t(i));
            if isreal(p)
            k = [k, num2str(p)];
            end
        end
        if exist('n','var')
            if length(k)>n
                r(j)=real(str2num(k(end-n:end)));
            else
                r(j)=real(str2num(k));
            end
        else
            r(j)=real(str2num(k));
        end
    end
    number= r;
else
    for i=1:length(textwithNumbersIn)
        if textwithNumbersIn(i)~='i'
        r = [r, num2str(str2num(textwithNumbersIn(i)))];
        end
    end
number = real(str2num(r));    
end
