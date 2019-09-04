function A2=frameswap(A,cfs,sameSize)
% When the value in cfs is a fraction, a linear interpoaltion will be
% made to aproximate the fraction.
if nargin<3
    sameSize=1;
end
if sameSize
    A2 =zeros(size(A,1),size(A,2),size(A,3));
    for k=1:size(A,3)
        CPFrame();
    end
else
    A2 =zeros(size(A,1),size(A,2),length(cfs));
    for k=1:length(cfs)
        CPFrame();
    end
end

    function CPFrame() % Copy/Compute frame 
        fck=floor(cfs(k));
        intp = cfs(k)-fck;
        if intp==0
            A2(:,:,k)=A(:,:,cfs(k));
        else
            A2(:,:,k)=intp*A(:,:,fck)+(1-intp)*A(:,:,fck+1);
        end
    end
end
