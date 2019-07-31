function recreateMovie(filepath)
% Creates a *.tif file from the SVD. This is an approximation of the original
% tiff movie.

if nargin<1
    [fname, dirname]=uigetfile('*.tif_mask.png');
    pname = [dirname fname(1:end-9)];
end
[A] = fastLoadTiff(pname);


ffname = [dirname fname(1:end-13) '_SVD.tif']
totFrames = size(A,3);
imwrite(uint16(A(:,:,1)),ffname);

  figure(6)
 for i=2:totFrames
       try
          imwrite(uint16(A(:,:,i)),ffname,'WriteMode','append')
          imagesc(A(:,:,i))
          drawnow();
       catch
           pause(0.01);
           disp('trying imwrite append again');
           try
               pause(1);
               imwrite(uint16(A(:,:,i)),ffname,'WriteMode','append');
           catch
               try
                   pause(1);
                   imwrite(uint16(A(:,:,i)),ffname,'WriteMode','append');
               catch
                   try
                       pause(1);
                       imwrite(uint16(A(:,:,i)),ffname,'WriteMode','append');
                   catch
                       error('tried 4 times but could not write to file')
                   end
               end
               
           end
       end
 end
  
  
  for i=1:size(A,3)
imagesc(A(:,:,i))
drawnow();
end


end