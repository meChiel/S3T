 kk=35;
    [A, fname, FileName, PathName, U, S, V, error]=loadTiff(...
        ['D:\data\reprocess\NS_2019_017179\NS_520190201_110228_20190201_112418\'...
        'NS_520190201_110228_e00' pkk(2:3) '.tif'],0);
    %%
    mini=[];
    AA=mean(A,3);
    dAA=AA;
    k=1;
    for i=1:48 
        for j=1:48
            pA1=i*10+(1:25);
            pA2=j*10+(1:25);
            dAA=AA;
            dAA(pA1,pA2)=1e4;
            %figure(16)
            %imagesc(dAA);
            %drawnow()
            sA=A(pA1,pA2,:);
            tr=squeeze(mean(mean(sA,1),2));
            %figure(17)
            %plot(tr);
           % pause;
            for t=150:5:470
                df=max(tr(t+(1:10)))-min(tr(t+(1:10)));
                if df>150
                    %df
                   mini(k,:)=[i,j,t,df];
                   trn(k,:)=tr;
                   k=k+1
                end
            end
        end
    end
    % sort
    [sd, sdi]=sort(mini(:,4),'descend');
    mini2=mini(sdi,:);
      trn2=trn(sdi,:);
    
    %%
    % Remove doubles
    mini3=mini2;
    trn3=trn2;
    for k=1:(length(mini2)-1)
        for l=k+1:length(mini2)
            rr1=mini2(k,1:3);
            rr2=mini2(l,1:3);
            rr1(3)=rr1(3)/2; % scale time cost vs possition
            rr2(3)=rr2(3)/2;
            if 5>norm((rr1-rr2))
                mini3(l,4)=0;
            end
        end
    end
    for k=length(mini3):-1:1
        if mini3(k,4)==0
            mini3(k,:)=[];
            trn3(k,:)=[];
        end
    end
    
    size(mini3,1)
    %%
    figure
    mt=mini(:,3);
    hist(mt,40)               
    
    %% Find pixels in F.O.V.
    m=mini3;
    debug =0;
    k=2;
    signal=[];
    for k=1:size(m,1)
        
        i=m(k,1);
        j=m(k,2);
        pA1=i*10+(1:25);
        pA2=j*10+(1:25);
        tpp=1:30;
        Att=A(pA1,pA2,m(k,3)+tpp);
        if debug
            figure;plot(squeeze(mean(mean(Att,1),2)));
            figure(5);colormap('gray');
            
            for tppp=tpp
                image((Att(:,:,tppp)-Att(:,:,1))/30);
                pause(.1)
            end
        end
        tt2=reshape(Att, 25*25,[]);
        [U, S, V]=svd(tt2-mean(tt2,2)); %Calculate SVD of recentered patch
        dV=diff(V(:,1));
        [madV, madVi]=max(abs(dV)); % Correct sign with max dV/dt
        sSVD=sign(dV(madVi));
        U=sSVD*U;
        V=sSVD*V;
        if debug
            figure;plot(V(:,1));
        end
        %% Show mini's
        rU=reshape(U(:,1),25,25);
        if debug
            figure;colormap('gray');
            imagesc(rU);
            hold on
            plot(-mean(rU,1)*100);
            plot(-mean(rU,2)*100,1:25);
            axis([-5 25 -5 25])
            axis off
        end
        
        %
        % Extract synapse pixel weighted signal
        Mtype='binMask';'cont';
        switch Mtype
            case 'cont'
                rrU=rU;
                rrU(rU<0)=0;
                
            case 'binMask'
                rrU=rU*0;
                sru=std(rU(:));
                rrU(rU>(2*sru+mean(rU(:))))=1;
        end
        if debug
            figure(19);imagesc(rrU)
        end
        rrU=rrU/sum(rrU(:));
        es=rrU.*Att;
        es2=squeeze(sum(sum(es,1),2));
        
        signal(k,:)=es2;
        if debug
            figure(20);plot(es2)
        end
    end
    %%
    
    figure;plot(signal(:,:)')
    %%
    figure; 
    for k = 1:length(signal)
        [mamp, mi]=max((signal(k,:)));
        plot((1:30)-mi,signal(k,:)-min(signal(k,:))');
        hold off
        pause(1)
    end
    
    
    %%
    
    
    
    %%
    
    figure;plot(squeeze(mean(mean(Att,1),2)))
    
    
    %%
    figure;
    colormap('gray')
    k=3;
    for ii=1:10
        for t=1:10
            imagesc(A(mini3(k,1)*10+(1:25),mini3(k,2)*10+(1:25),mini3(k,3)+t))
            pause(.1)
        end
    end
    
    %% Look at squares
    m=mini3;
    figure;
    colormap('gray')
    k=3;
    for k=(1:length(m))
    subplot(1,2,1)
    
    AA=mean(A,3);
    AA(m(k,1)*10+(1:25),m(k,2)*10+(1:25))=3e4;
    imagesc(AA(:,:));
    title(['t=' num2str(m(k,3))]);
    
    
        subplot(1,2,2)
        for ii=1:3
            for t=1:10
                image(A(m(k,1)*10+(1:25),m(k,2)*10+(1:25),m(k,3)+t)/100);
                A(m(k,1)*10+(1:25),m(k,2)*10+(1:25),m(k,3)+t);
                pause(.1)
            end
        end
        pause()
    end
    
                
    %%
    figure; 
    for k = 1:length(mini3)
        %plot(trn3(k,mini3(k,3)+(1:20))');
        %plot(trn3(k,mini3(k,3)+(1:20))-min(trn3(k,mini3(k,3)+(1:10)))');
        [mamp, mi]=max((trn3(k,mini3(k,3)+(1:20))));
        plot(trn3(k,mini3(k,3)+mi-8+(1:20))-min(trn3(k,mini3(k,3)+(1:10)))');
        hold on
    end
    %%
    figure;hist(mini(:,4))
    %%
    figure; plot(mini(:,1),mini(:,2),'.');
            
            