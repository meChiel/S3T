function imStitcher(a1, a2)
if 0
    txtname='D:\data\Michiel\photoshoot\test\NS_920190507_162402.txt';

%% open the text file
fid = fopen(txtname);
S = fscanf(fid,'%s');       
fclose(fid);
%%
 pos=strfind(S,['Fields' num2str(32768)]);
 for L=1:length(pos)  
       xpos(L)=str2num(S(pos(L)+10+(1:10)));
       ypos(L)=str2num(S(pos(L)+22+(1:11)));
 end
    
r{1}=imread('D:\data\Michiel\photoshoot\test\NS_920190507_162402_m000553_tt0018.tif');
r{2}=imread('D:\data\Michiel\photoshoot\test\NS_920190507_162402_m000554_tt0018.tif');
r{3}=imread('D:\data\Michiel\photoshoot\test\NS_920190507_162402_m000555_tt0018.tif');


r{1}=imread('D:\data\Michiel\photoshoot\test\NS_920190507_162402_m001360_tt0018.tif');
r{2}=imread('D:\data\Michiel\photoshoot\test\NS_920190507_162402_m001361_tt0018.tif');
r{3}=imread('D:\data\Michiel\photoshoot\test\NS_920190507_162402_m001362_tt0018.tif');


r{1}=imread('Y:\data\Michiel\photoshoot\stimx10\NS_68_20190514_175204\f1.png');
r{2}=imread('Y:\data\Michiel\photoshoot\stimx10\NS_68_20190514_175204\f2.png');

imStitcher(r);
end
i=1;
if iscell(a1)
    r=a1;
    a1=r{i};
    i=i+1;
    a2=r{i};
else
    r{1}=a1;
    r{2}=a2;
end

figure('KeyPressFcn', @keyPress);
L1=100;
k1=412;
L2=100;
k2=412;
rval=0;
xx=100+(1:length(r));
yy=412+(1:length(r));
ra1=[];
ra2=[];

    function keyPress(src, e)
        %disp(e.Key);
        L2
        k2
        i
       
        switch e.Key
            case 'd'
                k2=k2+1;
                update();
            case 'q'
                k2=k2-1;
                update();
            case 's'
                L2=L2+1;
                update();
            case 'z'
                L2=L2-1;
                update();
           case 'r'
               rval=rval+.1;
                ra1=imrotate(a1,rval);%
                ra2=imrotate(a2,rval);%
                update();
           case 't'
               rval=rval-.1;
                ra1=imrotate(a1,rval);%
                ra2=imrotate(a2,rval);%
                update();
            case 'f'
                xx(i)=k1;
                yy(i)=L1;
                
                k2= xx(i);
                L2=yy(i);
                a2=r{i};
                i=i-1;
                k1= xx(i);
                L1=yy(i);
                a1=r{i};
                update();
            case 'g'
                xx(i)=k2;
                yy(i)=L2;
                k1= xx(i);
                L1=yy(i);
                a1=r{i};
                i=i+1;
                a2=r{i};
                k2= xx(i);
                L2=yy(i);
                update();
        end
        function update()
            t=zeros(2*512,3*512);
            sra1=size(ra1);
            t(L1+(1:sra1(2)),k1+(1:sra1(1)))=ra1;
            
            imagesc(t);
            %pause(.1);
            sra2=size(ra2);
            %t(L2+(1:512),k2+(1:512))=(t(L2+(1:512),k2+(1:512))>4000)*3000-(double(a2)>4000)*3000;
            t(L2+(1:sra2(1)),k2+(1:sra2(2)))=t(L2+(1:sra2(1)),k2+(1:sra2(2)))-double(ra2);
            
            imagesc(t);
            title([num2str(k2) ' ' num2str(L2) ' ' num2str(rval) ])
           % pause(.1);
        end
    end
end