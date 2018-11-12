dataDirname =    'F:\share\toBeProcessed\1 NOW\12-10-2018';
%dataDirname = 'Z:\create\_Rajiv_HTS\NS_2018_016174\NS_5320180417_160534_20180417_160821';
dataDirname = 'F:\share\toBeProcessed\1 NOW\23-10-2018\Analyze these please';
dataDirname = 'E:\fastShare\Camille\Analyze these please - Copy\';
dataDirname = 'E:\fastShare\Camille\NS_2018_016619\Raw_Data'
%dataDirname = 'Z:\create\Francisco\16-10-2018 (tau)\'

for i=1:20
    try 
        segGUIV1(dataDirname);
    catch e
        disp(e);
        warning(['TRYING for the ' num2str(i) 'time']); 
    end
end