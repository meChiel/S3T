tt={r.folder};
i=0
k=1;
for i=1:length(tt)
     found=0;
     k=k+1;
     u{k}=tt(i);
    for j=i:length(tt)       
    if ~strcmp ( tt{i},tt{j})
       found=1;
       k=k-1;
       u{k}=tt(i);
       break;
    end
    end
end