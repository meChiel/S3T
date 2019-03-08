   function rr4=convertPath2StructFormat(folder,d)
        rr =folder(length(d):end-length('process'));
        rr2=[rr];% '\'];
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
    end