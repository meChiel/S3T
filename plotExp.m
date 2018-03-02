l(200)=1;

for i=1:200
    k(i+1)=k(i)*0.94;
end
for i=200:-1:2
l(i-1)=l(i)*0.48;

end

kk=[l k ];

figure;plot(kk)