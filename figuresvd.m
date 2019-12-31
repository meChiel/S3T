function figuresvd()
kkL=35; %0:59;
figure(6);
cl=uicontrol('Style', 'list','Max',10,'Min',1, 'String', {'eig1','eig2','eig3','eig4'},...
    'Position', [10 400 150 175], 'BackgroundColor',[.35 .35 .38], 'ForegroundColor',[.05 .05 .08],...
    'Visible','on','CallBack',@doUpdateImage );


for kk=kkL
    pkk=num2str(kk+100);
    [A, fname, FileName, PathName, U, S, V, error]=loadTiff(...
    'D:\data\Data for Michiel\bckup\SygCaMP (16365)\InFocus\NS_420180822_164118_e0010.tif',1);
    
%%
  %  [A, fname, FileName, PathName, U, S, V, error]=loadTiff(...
  %      ['D:\data\reprocess\NS_2019_017179\NS_520190201_110228_20190201_112418\'...
  %      'NS_520190201_110228_e00' pkk(2:3) '.tif'],1);
    
    
    %%
    for t=[]
        %%
        sx=size(A,2);336;512;
        sy=size(A,1);256;512;
        E1=reshape(U(:,1),sy,sx);
        E2=reshape(U(:,2),sy,sx);
        E3=reshape(U(:,3),sy,sx);
        P=[];
        P(:,:,3) = 0.0+E1*100; %R
        P(:,:,1) = 0.0+(E2>0).*E2*100.0; %R
        P(:,:,2)=0.0+E1*100; %G
        %P(:,:,2)=P(:,:,2)+(E2<0).*abs(E2)*180; %Y
        
        %P(:,:,2)=P(:,:,2)+(E1>0).*E1; %G
        %P(:,:,3)=0.0+E3*0; %B
        
        P(:,:,3)=P(:,:,3)+0.0042-(E2<0).*abs(E2)*100.000; %Y
        %P(:,:,2)=P(:,:,2)+0.0042-(E2<0).*abs(E2)*100.000; %Y
        %P(:,:,2)=P(:,:,2)-(E2<0).*abs(E2)*100.000; %Y
        
        
        %subplot(1,4,1);imagesc(E1);
        %subplot(1,4,2);
        %imagesc(E2);
        %subplot(1,4,3);imagesc(E3);
        %subplot(1,4,4);
        
        %figure('color',[0 0 0]);
        figure(5);
        if length(kkL)>1
            ssubplot(ceil(lenght(kkL)/10),10,kk+1)
        end
        set(gcf,'color',[0 0 0]);
        hold off;
        
        image(P*1);
        hold on;
        plot(((1:800).*[1 1 1]')'/800*500,V(:,1:3)*-500+[150 250 350],'linewidth', 0.5)
        set(gcf,'color',[0 0 0]);
        colormap gray
        axis tight;axis equal
        axis off
    end
    
    %%
    updateImage()
    
end

    function doUpdateImage(e,f,g)
        updateImage();
    end
%% HSV implementatie
    function updateImage()
        %%
        sx=size(A,2);
        sy=size(A,1);
        E1=reshape(U(:,1),sy,sx);
        E2=reshape(U(:,2),sy,sx);
        E3=reshape(U(:,3),sy,sx);
        E4=reshape(U(:,4),sy,sx);
        E5=reshape(U(:,5),sy,sx);
        P=[];
        P1 = 0.0*E1;
        P2 = 0.0*E1;
        P3 = 0.0*E1;
        
        P(:,:,1) = P1;
        P(:,:,2) = P2;
        P(:,:,3) = P3;
        Q=P*0;
        
        C(:,:,1)=E1*100.0;%s
        
        C(:,:,2)=(E2>0).*E2*100.0;%s
        C(:,:,3)=(E2<0).*-E2*100.0;%s
        
        C(:,:,4)=(E3<0).*-E3*100.0;%s
        C(:,:,5)=(E3>0).*E3*100.0;%s
        
        C(:,:,6)=(E4<0).*-E4*10.0;%s
        C(:,:,7)=(E4>0).*E4*10.0;%s
        
        C(:,:,8)=(E5>0).*E5*10.0;%s
        
        %blauw=.5 groen=0.25 rood=0%
        
        col=[0.1333 0.506666 0.521012  0.1505 .1025 0.00075 0.09125];%0.0:1/size(C,3):1;
        
        col=[0.250005333 0.000506666 0.521012  0.1505 .1025 0.00075 0.09125];%0.0:1/size(C,3):1;
        %col=0:.1:1;
        
        
        for i=1:7size(C,3)
            P1=col(i);    %hue
            P2=atan(10*(C(:,:,i)))*1;%saturation
            P3=atan(1*(C(:,:,i)));  %value
            
            P(:,:,1) = P1;
            P(:,:,2) = P2;
            P(:,:,3) = P3;
            QQ= hsv2rgb(P);
            %Q =  Q*sum(cl.Value==i) + QQ;
            Q =  0*Q+ QQ;
            figure('color',[0 0 0]);
            imagesc(Q*1);
            axis equal
            axis off
            pause(1)
            
        end
        %%
        figure(6);
        VV=[];
        if length(kkL)>1
            ssubplot(ceil(length(kkL)/10),10,kk+1)
        end
        image(Q);
        hold on;
        VV(:,1)=V(:,1);
        
        VV(:,2)=V(:,2);
        VV(:,3)=-V(:,2);
        
        VV(:,4)=-V(:,3);
        VV(:,5)=V(:,3);
        
        VV(:,6)=-V(:,4);
        VV(:,7)=V(:,4);
        
        LL=VV*-100+[50 100 150 250 350 400 450];
        LL=(LL<512).*(LL>0).*LL; % Saturate
        %plot(((1:800).*ones(5,1))'/800*500,LL,'linewidth', 0.5,'color',[1 0 0;0 1 0; 0 0 1; 1 1 0; 0 1 1])
        for i=1:7
            %ccc=[1 0 0;0 1 0; 0 0 1; 1 1 0; 0 1 1];
            %col=[0 0.666 .3333 0.5 .25 0.75 ]
            ccc=hsv2rgb([col(i) 1 1]);
            lLL=length(LL);
            plot((1:lLL)/lLL*500,LL(:,i),'linewidth', 0.5,'color',ccc);
        end
        set(gcf,'color',[0 0 0]);
        axis tight;axis equal;axis off
        figure('color',[0 0 0]);
        image(Q*1);
        hold on;
        for i=1:7
            %ccc=[1 0 0;0 1 0; 0 0 1; 1 1 0; 0 1 1];
            %col=[0 0.666 .3333 0.5 .25 0.75 ]
            ccc=hsv2rgb([col(i) 1 1]);
            plot((1:800)/800*200+550,LL(:,i),'linewidth', 1.5,'color',ccc);
        end
        
        %colormap gray
        axis equal
        axis off
    end
%%
    function some2
        R2=reshape(U(:,4),sy,sx);
        G2=reshape(U(:,5),sy,sx);
        B2=reshape(U(:,6),sy,sx);
        P2=[];
        P2(:,:,1)=R2;
        P2(:,:,2)=G2;
        P2(:,:,3)=B2;
        figure('color',[0 0 0]);image(P2*100);axis equal;axis off;
        col=[0 1 0;1 0 0; 0 0 1;...%];
            0 1 0;1 0 0; 0 0 1];
        
        
        %%
        figure('color',[0 0 0]);
        subplot(1,2,1);
        image(P*100);axis equal, axis off
        
        subplot(1,2,2)
        image(P2*100);
        axis equal, axis off
        
        %%
        %pause
        
        for channel=1:16
            
            %%
            
            
            clf
            movWrite=1;
            if movWrite
                
                accuracy=16;
                %vidObj = VideoWriter([PathName FileName(1:end-4) '__SVDVideo_a' num2str(accuracy) '.avi']);
                
                accuracy=1;
                
                %vidObj = VideoWriter([PathName FileName(1:end-4) '__SVDVideo_a' num2str(accuracy) '_c' num2str(channel) '.avi'],'Grayscale AVI');
                vidObj = VideoWriter([ FileName(1:end-4) '__SVDVideo_a' num2str(accuracy) '_c' num2str(channel) '.avi'],'Grayscale AVI');
                
                %vidObj = VideoWriter('overviewVideo.avi','MPEG-4');
                % vidObj = VideoWriter('overviewVideo.avi','Motion JPEG 2000');
                %vidObj.CompressionRatio=1000;
                %vidObj.Quality=90;
                open(vidObj);
            end
            
            
            %col=colormap('hsv');
            %col=colormap('gray');
            %col=colormap('hot');
            % col=[
            % 2 2 2;...
            % 6 0 0;...
            % 0 10 0;...
            % 0 0 10;...
            % 0 10 10;...
            % 10 10 0;...
            % 1 0 1;...
            % 1 0 1;...
            % 1 0 1;...
            % 1 0 1;...
            % 1 0 1;...
            % 1 0 1;...
            % 1 0 1;...
            % 1 0 1;...
            % 1 0 1;...
            % 1 0 1;...
            % 1 0 1;...
            % ]*1/10*2;
            
            
            bgCol=[0 0 .5]*.6;
            cbCol=[1 0 0]*2;
            Acol=[0 1 0]*1.3;
            Bcol=[0 1 1]*0.5;
            col=[bgCol;cbCol; Bcol;...%];
                Acol;Acol; Acol;...
                Acol;Acol; Acol;...
                Acol;Acol; Acol;...
                Acol;Acol; Acol;...
                Acol;Acol; Acol;...
                Acol;Acol; Acol;...
                ]*.6;
            
            comp=zeros(sy,sx,3);
            f1=figure(2);
            set(f1,'color',[0 0 0]);
            for h=channel;%16:16
                for t=1:1:size(A,3)
                    t
                    fullcomp=zeros(sy,sx,3);
                    comp=zeros(sy,sx,1);
                    % comp=zeros(sy,sx);
                    for hh=channel;%1:h
                        % E=reshape(U(:,hh)*log(S(hh,hh))*V(t,hh)'*col(hh*10,:),[sy,sx,3]);
                        %E=reshape(U(:,hh)*sqrt(S(hh,hh))*V(t,hh)'*col(hh*10,:),[sy,sx,3]);
                        %E=reshape(U(:,hh)*(S(hh,hh))*.41*col(mod((hh-1)*45,64)+1,:),[sy,sx,3 ]);
                        %E=reshape((0+U(:,hh)*(S(hh,hh))*V(t,hh)')*col(hh*1,:),[sy,sx,3 ]);
                        E=reshape((0+U(:,hh)*(S(hh,hh))*V(t,hh)'),[sy,sx,1 ]);
                        
                        % Other
                        %   F=reshape((0+U(:,hh)*(S(hh,hh))*V(t,hh)')*[.3 .3 .3],[sy,sx,3 ]);
                        %E=reshape(U(:,hh)*(S(hh,hh))*.1*col(hh*1,:),[sy,sx,3 ]);
                        %E=reshape(U(:,hh)*2000*1*col(hh*1,:),[sy,sx,3 ]);
                        
                        % Saturate E
                        % E(E>1)=1;
                        % E(E<0)=0;
                        
                        comp=comp+E;
                        % fullcomp=fullcomp+F;
                    end
                    
                    figure(2);
                    currFrame=comp/60/4+0.5;
                    
                    %currFrame = [fullcomp/26 zeros([size(A,1),30,3]) comp/26];
                    image(currFrame);
                    % Saturate
                    currFrame(currFrame>1)=1;
                    currFrame(currFrame<0)=0;
                    
                    %     image(currFrame);
                    %     subplot(1,2,1)
                    %     image(fullcomp);
                    %     subplot(1,2,2)
                    %     r=gcf
                    if movWrite
                        writeVideo(vidObj,currFrame);
                        %writeVideo(vidObj,r);
                    end
                    axis equal,axis off;
                    title(num2str(t),'color',[.5 .5 .5]);
                    pause(.1)
                end
                
            end
            
            %
            if movWrite
                close(vidObj);
                disp([PathName '\' FileName(1:end-4) '__synapseSVDVideo_a' num2str(accuracy) '.avi'])
            end
        end
        image(comp/20)
        
        %%
        figure;
        %image([1:60]');
        %colormap('hsv');
        image(permute(reshape(repmat(col(1:16,:)',100,1)*64,[3,100*16,1]),[2,3,1]));
        %colormap('hsv');
        
        %yticklabels({'eig1','eig2','eig3','eig4','eig5','eig6'})
        yticklabels({'eig1','eig2','eig3','eig4','eig5','eig6','eig7','eig8','eig9','eig10','eig11','eig12','eig13','eig14','eig15','eig16'})
        xticklabels({' '})
    end
%%
end
