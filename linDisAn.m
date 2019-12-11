% 2 class or multi-class

global data
compounds={data{1}.Properties.VariableNames{32:end-5}}; % Synapses
%compounds={data{1}.Properties.VariableNames{52:end-1}}; % well avg
%compounds={data{1}.Properties.VariableNames{end-11:end-5}}; % well avg
compounds(3)=[]; % Remove the compound empty well
rr=compounds(end);
compounds(end)=compounds(3);
compounds(3)=rr;
%compounds={'Blockers','WAY'};
%compounds={'TTX','PMA'};
%%
R=[];S=[];T=[];
i=1;j=2;
%%
for i=[1:length(compounds)]%[1:length(kk)]
    for j=[1:length(compounds)]%[1:length(kk)]
        if i~=j
            %%
            ifsa=0; % Individual feature analysis
            S=[];
            if ifsa
                featInd=[1:5 6 10 12:21];% 12:31 41 42];
                LK=length(featInd);
            else
                featInd=[2];%[1:5 8 9:10 12:19 ];[30]
               % featInd=[1:length(featInd)];
                
                
                LK=1;
            end
            
            for k=1:LK
               %
                names = data{1}.Properties.VariableNames;
                            
                if ifsa
                    sel=[featInd(k)];%2:4 7:42];% 9 22 ];% 7:10];% 7:33];%1:5 7:33];
                else
                    sel=[featInd];
                    featSel=1:length(featInd);
                end
                
                names=names(sel);
                adata=table2array(data{1}(:,sel ));
                %adata(:,end)=isnan(adata(:,end))+ 10000000*rand(size(adata,1),1); %Hack
                %featSel=(~isnan(std(adata))) & (std(adata)~=0);
                if ifsa 
                     selDataWN=adata;
                else
                    selDataWN=adata(:,featSel);
                end
                selData=selDataWN;
                
                %Edata=mean(selData,1);
                %SigData=std(selData,1);
                ndata=(selData);
                %ndata=(ndata-Edata)./SigData; % Enable to normalize
                tdata=ndata; %(:,featSel);
                if ifsa
                else
                    names = names(featSel);
                end
                
                % Select different datagroups
                N0=compounds{i};%'TTX';
                N1=compounds{j};%'TBOA';%'DMSO____OB_0_PNT_1_PCT__CB_';
                N2='TTX';
                
                %N2='TTX';
                G0 = data{1}.(N0);
                G1 = data{1}.(N1);
                G2 = data{1}.(N2);
               
                % select the nan 
                tx0 = tdata(~isnan(G0),:);
                tx1 = tdata(~isnan(G1),:);
                tx2 = tdata(~isnan(G2),:);
                
                
                disp([num2str(sum(isnan(sum(tx0,2)))) ' lines removed due to containing nan.']);
                disp([num2str(sum(isnan(sum(tx1,2)))) ' lines removed due to containing nan.']);
                tx0(isnan(sum(tx0,2)),:)=[]; % remove lines with nan
                tx1(isnan(sum(tx1,2)),:)=[]; % remove lines with nan
                
%                 % Normalize
                 Edata=mean([tx0; tx1],1);
                 SigData=std([tx0; tx1],1);
%                                 
                tx0=(tx0-Edata)./SigData;
                tx1=(tx1-Edata)./SigData;
                                
                x0=tx0;
                x1=tx1;
                x2=tx2;
                % De bedoeling is om features te vinden die een verschil tussen de
                % verschillende compounds vinden.
                %t = funn(x0, x1)
                implementation = 'matlab';%my';%'my';%'matlab';
                switch implementation
                    case 'my'
                        u0=mean(x0);
                        u1=mean(x1);
                        
                        sig0=cov(x0);
                        sig1=cov(x1);
                        w = (sig1+sig0)\(u1 - u0)';
                        
                        p0=((x0-Edata)./SigData)*w;
                        p1=((x1-Edata)./SigData)*w;
                        
                        p0=x0*w; % WRONG!! *w is not the projection you want, should be something norm((x0-W0)*w-xo) 
                        p1=x1*w;
                        
                        K=w'*0.5*(u0+u1)'
                        
                    case 'matlab'
                        meas=[...
                            x0;...
                            x1;...
                           % x2...
                            ];
                        species=[...
                            repmat({N0},size(x0,1),1); ...
                            repmat({N1},size(x1,1),1) ; ...
                          %  repmat({N2},size(x2,1),1)...
                            ];
                        MdlLinear  = fitcdiscr(meas,species);%,'DiscrimType','quadratic');
                        %MdlLinear  = fitclinear(meas,species);%,'DiscrimType','quadratic');
                        MdlLinear.ClassNames([1 2])
                        K = MdlLinear.Coeffs(1,2).Const;
                        L = MdlLinear.Coeffs(1,2).Linear;
                        %Edata=K;
                        %SigData=1;
                        w=L;
                        if 0
                        figure(21)
                        h1 = gscatter(meas(:,1),meas(:,2),species,'krb','ov^',[],'off');
                        h1(1).LineWidth = 1;
                        h1(2).LineWidth = 1;
     
                        legend(names)
                        hold on
                        
                        f = @(x1,x2) K + L(1)*x1 + L(2)*x2;
                        f2 = @(x1,x2) K + L(1)*x2 - L(2)*x1; % Orthogonal
                      
                        h2 = ezplot(f,[-2 5.1 -2 5.1]);
                        h3 = ezplot(f2,[-2 5.1 -2 5.1]);
                        
                        
                        h2.Color = 'r';
                        h2.LineWidth = 2;
                        
                        h2.Color = 'c';
                        h2.LineWidth = 2;
                        
                        
                        axis('equal')
                        
                        
                        figure(22);imagesc( confusionmat(species,predict(MdlLinear,meas)))
                        end
                        
                        [meanclass0, pp0]= predict(MdlLinear,x0);
                        [meanclass1, pp1]= predict(MdlLinear,x1);
                        p0=pp0(:,1); %Right number
                        p1=pp1(:,1);
                        
                       % p0=x0*w; %Wrong!! *w Is not proj. you mean., maybe it is correct?
                       % p1=x1*w;
                end
                
                
                mp=min([p0; p1]);
                Mp=max([p0; p1]);
                dhp=(Mp-mp)/3;
                h=  mp:dhp:Mp
                [c0, h0]=hist(p0,h);
                [c1, h1]=hist(p1,h,'color','yellow');
                
                cu=min([c0; c1]);
                
                
                ss=(mean(p0)-mean(p1)).^2/(var(p0)+var(p1))
                ss=1-2*sum(cu)/sum([c0 c1]);
                S(k)=ss;
                
                %%
                figure(10);
                subplot(4,1,1);
                bar(abs(w));xticks(1:length(names));xticklabels(names);xtickangle(-90);
                %title([N0 ' ' N1]);
                %axis('off')
                
                subplot(4,1,2:4);
                [c0, h0]=hist(p0,h1);
                [c1, h1]=hist(p1,h1,'color','yellow');
                
                hold off;
                bar(h0,c0);
                hold on;
                bar(h1,c1);
                legend({OKname2text(N0) OKname2text(N1)})
                %%
                   figure(9);
                subplot(1,4,1);
                barh(abs(flipud(w)));yticks(1:length(names));yticklabels(fliplr(names));ytickangle(0);
                %title([N0 ' ' N1]);
                %axis('off')
                title('LDA')
                
                subplot(1,4,2:4);
                
                hold off;
                bar(h0-dhp/8,c0); %shift 1/8
                hold on;
                bar(h1+dhp/8,c1);
                bar(h1,cu);
                
                legend({OKname2text(N0) OKname2text(N1)})
                title('Hist of projections onto perpendicular LDA')
                xlabel(['Separation score: ' num2str(ss)])
            end
            %%
            T(i,j)=ss;
        end
    end
end
%%

%compounds{2}='DMSO';
%%
figure(11);
names = data{1}.Properties.VariableNames;
names =names(featInd);
%names =names(featSel);
bar(S);xticks(1:length(names));xticklabels(names);xtickangle(-90);

%%
figure(12);
names = data{1}.Properties.VariableNames;
names =names(featInd);
imagesc(S');yticks(1:length(names));yticklabels(names);ytickangle(0);
%%

figure(13);
names =compounds;
imagesc((T'));yticks(1:length(names));yticklabels(OKname2text(names));ytickangle(0);
xticks(1:length(names));xticklabels(OKname2text(names));xtickangle(0);
title('Compound separability')


%%
cmm=colormap('gray');
%colormap('jet')
figure(14);
names =compounds;
T2=(1-(normcdf(T,0,1)-.5)*2)*100;
imagesc(T2);yticks(1:length(names));yticklabels(OKname2text(names));ytickangle(0);
axis('equal')
xticks(1:length(names));xticklabels(OKname2text(names));xtickangle(0);
title('Compound similarity probability ')
for i=1:length(T2)
    for j=1:length(T2)
        text(i,j,[int2str(T2(i,j)) '%'],'HorizontalAlignment','center', 'VerticalAlignment','middle','Color',[squeeze(ind2rgb([1-T2(i,i)]/100,cmm))]);
    end
end
caxis([0 100]);

%%
[St Ut]=eig(T2/100);
Ut




% w=vector
% projecteer alle data op W en zet htreshold op
% kijk hist op projectie



