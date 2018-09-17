 vidObj = VideoWriter('clean4.avi');
    open(vidObj);  
figure
  mmmc=max(max(max(clean)));
  mmmd=min(min(min(clean)));
for k = 1:270
       %surf(sin(2*pi*k/20)*Z,Z)
 %image(reshape(clean(:,k),512,512)./max(max(max(clean))));
       % Write each frame to the file.
  %     currFrame = getframe;

       writeVideo(vidObj,reshape((clean(:,k)-mmmd)/(mmmc-mmmd),512,512));
    end
  
    % Close the file.
    close(vidObj);