function theStruct = stimReader(tt)
if nargin<1
    [fn dn]=uigetfile('*.xml');
    %rr=xmlread([dn fn]);
    theStruct = parseXML( [dn fn]) 
end
% xDoc=rr;
%  xRoot = xDoc.getDocumentElement

