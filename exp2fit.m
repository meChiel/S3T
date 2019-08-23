function [a,b,c,p,q]=exp2fit(x,y)
    % Should fit y = a exp(b x)+c exp(d x)
    % from https://math.stackexchange.com/questions/1428566/fit-sum-of-exponentials
    % https://www.scribd.com/doc/14674814/Regressions-et-equations-integrales
    % p71 - 74
    % X should be ascending and can not contain double values, because
    % local derivatives are calculated/approximated.
    fail=0;
    n=length(x);
    if n<6
        disp('sp?? exp2fit');
        warning('sp?? exp2fit');
        a=mean(x);
        b=0;c=0;p=0;q=0;
        pause(5);
    else
    S(1)=0;
    try
        S(n)=0; %exp
    catch
        disp('sp?? exp2fit');
        warning('sp?? exp2fit');
    end
    for k=2:n
        S(k-1)=S(k-1)+1/2*(y(k)+y(k-1))*(x(k)-x(k-1)); %changed from S(k)=..
    end
    S(1)=S(2); %exp added for better first derivative??

    SS(1)=0;
    SS(n)=0; %exp
    for k=2:n
        SS(k-1)=SS(k-1)+1/2*(S(k)+S(k-1))*(x(k)-x(k-1)); %changed from S(k)=..
    end
    SS(1)=SS(2); %exp added for better first derivative??

    SSS = [...
        sum(SS.^2) sum(SS.*S) sum(SS.*x.^2) sum(SS.*x) sum(SS);...
        sum(SS.*S) sum(S.^2)  sum(S.*x.^2)  sum(S.*x)  sum(S);...
        sum(SS.*x.^2) sum(S.*x.^2) sum(x.^4) sum(x.^3) sum(x.^2);...
        sum(SS.*x) sum(S.*x) sum(x.^3) sum(x.^2) sum(x); ...
        sum(SS) sum(S) sum(x.^2) sum(x) sum(n)
       ];

    BB = [sum(SS.*y); sum(S.*y); sum(x.^2.*y);...% 
        sum(x.*y); ...
        sum(y)];
    
    if cond(SSS)<1e9
% 
     SSSreg = SSS;
     BBreg=BB;
    else
     % or only first 2 are used
     SSSreg = SSS(1:4,:);
     BBreg=BB(1:4);
     disp('Saved fit by condition number modification.')
    end
%    
%     SSSreg(:,4) = SSS(:,4)*1e1;
%     SSSreg(4,:) = SSS(4,:)*1e1;
%    % BBreg(4,:) = BB(4,:)*1e3;
%     SSSreg(:,5) = SSS(:,5)*1e1;

    %SSSreg(4,:) = SSS(4,:)*1e4;
    %BBreg(4) = BB(4)*1e4;

     %SSSreg(5,:) = SSS(5,:)*1e4;
     %BBreg(5) = BB(5)*1e4;
%    
%     
     X=SSSreg\BBreg; % Ok werkt niet geeft slechtere resultaten
%    X=SSS\BB;

    A=X(1);B=X(2);%C=X(3);D=X(4);E=X(5);

    p=1/2*(B+sqrt(B^2 + 4*A));
    q=1/2*(B-sqrt(B^2 + 4*A));
    
    if imag(q)~=0
        SSSreg = SSS(1:2,:);
        BBreg=BB(1:2);
        disp('Saved fit by extreme condition number modification.')
        %pause(.1)
        X=SSSreg\BBreg; % Ok werkt niet geeft slechtere resultaten
        %    X=SSS\BB;
        
        A=X(1);B=X(2);%C=X(3);D=X(4);E=X(5);
        
        p=1/2*(B+sqrt(B^2 + 4*A));
        q=1/2*(B-sqrt(B^2 + 4*A));
    end
    
    if imag(q)==0 % check if not complex
       % normal case
        beta=exp(p*x);
        neta=exp(q*x);
        
        if (sum(y)/sum(neta)<1e6) % check if 2nd exp makes sense
            % normal case
            S4 =[...
                n sum(beta) sum(neta);...
                sum(beta) sum(beta.^2) sum(beta.*neta);...
                sum(neta) sum(beta.*neta) sum(neta.^2)];
            
            if sum(sum(isinf(S4)))
                fail=1;
            else
                disp('normal');
            end
            B4=[sum(y);sum(beta.*y);sum(neta.*y) ];
            xO=S4\B4;
            a=xO(1);b=xO(2);c=xO(3);
        else % if condition number makes no sense.
            S4 =[...
                n sum(beta) ;...
                sum(beta) sum(beta.^2) ;...
                ];
            B4=[sum(y);sum(beta.*y) ];
            xO=S4\B4;
            a=xO(1);b=xO(2);c=0;%xO(3);
            disp('saved by conditioning?');
        end
        if isnan(a+b+c+p+q)
            fail=1;
        end
    else
        fail=1;
        warning('could not fit 2exp, fall back to linear');
    end
    if fail==1
        disp('fallback on lin. interp.')
       
        LMSricox=[x'*0+1 x']\y';
        a=LMSricox(1);
        b=LMSricox(2);
        c=0;
        p=0;
        q=0;
        %pause(.3);
    end
    end
    %%
end

function test()
% f=@(x) a + b * exp(p * x) + c * exp(q * x);

a=700; b=2; c=1; p=-1; q=-10;
x=0:.1:20;
y =a+ b * exp(p * x)+c * exp(q * x)+ rand(size(x));
[a,b,c,p,q]=exp2fit(x,y);
BC = real(a') + real(b)' .* exp(real(p)'* x)+real(c)'.*exp(real(q)'*x); 
figure;plot(x,y,x,BC)
end
