%labInterface
%add logic well number from a1 notation
[ff, fd]=uigetfile('*.txt');
d.logicWellLocation = d.Metadata_Well;
d.logicWellLocation2 = d.Metadata_Well;
d.logicalWellIndex = d.Metadata_Well;
for i=1:length(d.logicWellLocation2)
    d.logicWellLocation2{i}=strrep(d.logicWellLocation2{i},'A','0+');
    d.logicWellLocation2{i}=strrep(d.logicWellLocation2{i},'B','12+');
    d.logicWellLocation2{i}=strrep(d.logicWellLocation2{i},'C','24+');
    d.logicWellLocation2{i}=strrep(d.logicWellLocation2{i},'D','36+');
    d.logicWellLocation2{i}=strrep(d.logicWellLocation2{i},'E','48+');
    d.logicWellLocation2{i}=strrep(d.logicWellLocation2{i},'F','60+');
    d.logicWellLocation2{i}=strrep(d.logicWellLocation2{i},'G','72+');
    d.logicalWellIndex{i}=eval(d.logicWellLocation2{i});
end
d.logicWellLocation=[]; 
d.logicWellLocation2=[]; 
writetable(d,[fd '\' 'All_' fn]);