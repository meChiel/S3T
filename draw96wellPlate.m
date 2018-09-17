figure(1);
subplot(2,1,1)
t=0:.1:2*pi;
wellSpacing= 9;
wellDiameter=6.4 ;
xOffset=0;
yOffset=-80;
scale=1000;
hold off;
for j=1:8
    for i=1:12
        plot(scale*(i*wellSpacing+ wellDiameter/2 * sin(t)),scale*(yOffset+j*wellSpacing+wellDiameter/2*cos(t)),'k');
        hold on ;
    end
end
for i=1:12
    text(scale*(i*wellSpacing- wellDiameter/2), 0, num2str(i));
end
letters=['A', 'B','C','D','E','F','G','H'];
for j=1:8
    text(0, scale*(-j*wellSpacing+ wellDiameter/4), letters(j));
end
axis equal
axis off

drawAndorNumbers=0
if drawAndorNumbers
    k=1;
    for j=1:8
        for i=1:12
            text(scale*(i*wellSpacing- wellDiameter/4), scale*(-78+j*wellSpacing- wellDiameter/4), num2str(k));
            k=k+1;
        end
    end
end

%% Test
fid = fopen('NS_720180814_105523.txt');
tt=fread(fid, inf, 'uint8=>char');

fclose(fid);
pos= strfind(tt','Well ');
clear wells;
wells{1} = textscan(tt(pos(2):end), '%s %d','CommentStyle','XY ');
wells{2} = textscan(tt(pos(2):end), '%s %d %s %c %f %c %f %c %f %s %s %s %s %s','CommentStyle','Well ');
% Well 14
% XY 1 - (16515,-63059,6950.35 (IXBX Z Motor (ZDC) 22))

plot(wells{2}{5}, wells{2}{7},'*b')

pos= strfind(tt','Fields	');
clear fields;
expression = {'-?\d{5}\.\d{6}'};
fieldsx = regexpi(tt(pos(1):end)',expression,'match');
fields= reshape(str2double(fieldsx{1})',2,[]);
%             Fields	32768	16515.000000	-63060.000000
%             6950.350000
plot(fields(1,:),fields(2,:),'or')
