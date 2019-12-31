function [signal, mask, synProb, maskSize, timings, synRegio] = miniAnalysis(data,time)

A = data;
PAD=15; % The stepsize for looking for minis.

threshold=150;
[mini3, sqMask] = findMinis(A,time,threshold);
if size(mini3,1)>1
    timings = mini3(:,3);
else
    timings =[nan];    
end
[signal, mask, synProb, maskSize, synRegio] = extractSignals(mini3,A);

%mask=sqMask;


    function [mini3, sqMask]=findMinis(A,time,threshold)
        % Find spiking minis in: 
        %                data: A 
        %                in the time frames given by: time
        %
        % Returns minis: mini3(1)=vertical block position 
        %                mini3(2)=horz. block position 
        %                mini3(3)=time point/ frame
        %                mini(4)= max change in time frame.
        
        
        %%
        maxK=1000;
        %%
        mini=[];
        AA=mean(A,3);
        dAA=AA;
        k=1;
        
        for i=1:floor((512-25)/PAD)
            for j=1:floor((512-25)/PAD)
                pA1=i*PAD+(1:25);
                pA2=j*PAD+(1:25);
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
                
                TF=10; %total Frames
                for t=time
                    df=max(tr(t+(1:TF)))-min(tr(t+(1:TF)));
                    if df>threshold
                        %df
                        if k<maxK
                        mini(k,:)=[i,j,t,df];
                        trn(k,:)=tr;
                        k=k+1
                        else
                            disp('maxK reached');
                        end
                    end
                end
            end
        end
        % sort
        if size(mini,1)>2
            [sd, sdi]=sort(mini(:,4),'descend');
            mini2=mini(sdi,:);
            trn2=trn(sdi,:);
        else
            disp('No mini''s found.');
            mini2=[];
            trn2=[];
        end
        
        %%
        % Remove doubles
        mini3=mini2;
        trn3=trn2;
        sqMask=zeros(size(A,1),size(A,2));
        
        if size(mini2,1)>2
            for k=1:(size(mini2,1)-1)
                for l=(k+1):size(mini2,1)
                    rr1=mini2(k,1:3);
                    rr2=mini2(l,1:3);
                    rr1(3)=rr1(3)/2; % scale time cost vs possition
                    rr2(3)=rr2(3)/2;
                    if 5>norm((rr1-rr2))
                        mini3(l,4)=0;
                    end
                end
            end
            for k=size(mini3,1):-1:1
                if mini3(k,4)==0
                    mini3(k,:)=[];
                    trn3(k,:)=[];
                end
            end
            size(mini3,1)
        end
            % create Mask
            for k = 1:(size(mini3,1)) % set the mask to 1
                i = mini3(k,1);
                j = mini3(k,2);
                pA1 = i*PAD+(1:25);
                pA2 = j*PAD+(1:25);
                sqMask(pA1,pA2) = sqMask(pA1,pA2)+1;
            end
    end
    function [signal, mask, synProb, maskSize, synRegio] = extractSignals(mini3,A)
        %% Find pixels in F.O.V.
        m=mini3;
        synProb=zeros(size(A,1),size(A,2));
        mask=zeros(size(A,1),size(A,2));
        if size(m,1)<1
            signal=nan; 
            maskSize=nan;
            synRegio=[];
        else
            debug =0;
            k=2;
            signal=[];
            for k=1:size(m,1)
                i=m(k,1);
                j=m(k,2);
                pA1=i*PAD+(1:25);
                pA2=j*PAD+(1:25);
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
                        lmask=rrU;
                        se = strel('cube',3);
                        lmask=imclose(lmask,se);
                        lmask=imopen(lmask,se);
                        maskSize=sum(lmask(:));
                        sig=2;
                        while maskSize==0
                            rrU(rU>(sig*sru+mean(rU(:))))=1;
                            lmask=rrU;
                            se = strel('cube',3);
                            lmask=imclose(lmask,se);
                            lmask=imopen(lmask,se);
                            maskSize=sum(lmask(:));
                            sig=sig*2/3;
                        end
                end
                if debug
                    figure(19);imagesc(rrU)
                end
                synProb(pA1,pA2)=synProb(pA1,pA2)+rU;
                mask(pA1,pA2)=mask(pA1,pA2)+lmask;
                
                cmask=zeros(512,512);
                cmask(pA1,pA2)=cmask(pA1,pA2)+lmask;
                LsynRegio  = regionprops(cmask(:,:),'PixelList','PixelIdxList');
                synRegio(k) = LsynRegio(1);
                rrUn=rrU/sum(rrU(:)); % Normalize mask
                es=rrUn.*Att;
                es2=squeeze(sum(sum(es,1),2));
                signal(k,:)=es2;
                if debug
                    figure(20);plot(es2)
                end
            end
        end
    end
end