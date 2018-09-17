function [a,b,c,p,q]=exp2fit(x,y)
    % Should fit y = a exp(b x)+c exp(d x)
    % from https://math.stackexchange.com/questions/1428566/fit-sum-of-exponentials

    n=length(x);
    S(1)=0;
    for k=2:n
        S(k)=S(k-1)+1/2*(y(k)+y(k-1))*(x(k)-x(k-1));
    end

    SS(1)=0;
    for k=2:n
        SS(k)=SS(k-1)+1/2*(S(k)+S(k-1))*(x(k)-x(k-1));
    end

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
% 
%     SSSreg = SSS;
%     BBreg=BB;
%    
%     SSSreg(:,4) = SSS(:,4)*1e1;
%     SSSreg(4,:) = SSS(4,:)*1e1;
%    % BBreg(4,:) = BB(4,:)*1e3;
%     SSSreg(:,5) = SSS(:,5)*1e1;
%     SSSreg(5,:) = SSS(5,:)*1e1;
%     %BBreg(5,:) = BB(5,:)*1e3;
%    
%     
%     X=SSSreg\BBreg; % Ok werkt niet geeft slechtere resultaten

    X=SSS\BB;

    A=X(1);B=X(2);%C=X(3);D=X(4);E=X(5);

    p=1/2*(B+sqrt(B^2 + 4*A));
    q=1/2*(B-sqrt(B^2 + 4*A));

    beta=exp(p*x);
    neta=exp(q*x);

    S4 =[...
        n sum(beta) sum(neta);...
        sum(beta) sum(beta.^2) sum(beta.*neta);...
        sum(neta) sum(beta.*neta) sum(neta.^2)];
    B4=[sum(y);sum(beta.*y);sum(neta.*y) ];

    xO=S4\B4;

    a=xO(1);b=xO(2);c=xO(3);


    %%
end

function test()
% f=@(x) b * exp(p * x) + c * exp(q * x);

a=0; b=1; c=1; p=-1; q=-10;
x=0:.01:20;
y = b * exp(p * x)+c * exp(q * x);
[a,b,c,p,q]=exp2fit(x,y);
end
