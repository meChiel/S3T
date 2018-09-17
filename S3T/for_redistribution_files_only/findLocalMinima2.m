function minima = findLocalMinima2(dataY,nbP,range)
% Dit zou een local minima zoeker moeten worden die werkt met energie.
% Kinetische en potentiele energie en zo het minima vindt.
figure(8);
for i=1:1
    dataY=[inf; dataY; inf];
end

startX=((range+1):floor(length(dataY)/nbP):(length(dataY)-(range+1)))';

Ek=Ek;
