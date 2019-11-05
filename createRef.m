function createRef()
% Create reference dictionare.
% Function to create a set of reference signals which are used to decompose the movie into. 
% Choosing in the analysis configurator
% in the Mask Creation Time Projection: DICT.
% Then all pixel temporal responses are decomposed into the dictionare.
% This function decomposes the spatial avg response into a photobleach
% component and a synapse/neuron component.
% The result is written in a Vref.csv table.
% The first collumn is the collumn which is used to create the mask when
% using the DICT. option.
try
    [A, fname, FileName, PathName, U, S, V, error]=loadTiff([],1);
    
    Uref=U;
    Vref=V;
    Sref=S;
catch
    [A, fname, FileName, PathName, U, S, V, error]=loadTiff([],0);
end

%%
V=squeeze(mean(mean(A)));
%% Decompose reference in photobleach- and synapse-signal
%[bcresponse, dff, BC, mstart]=findBaseFluorPoints(V(:,1)',2);
[bcresponse, dff, BC, mstart]=findBaseFluorPoints(V(:)','2exp');

% The first signal will be used for the mask creation when using DICT.
Vref=[bcresponse' BC'];

try
    gg=strfind(FileName,'_e0');
    tf=FileName(gg+1:gg+5);
catch
    tf=text2OKname(FileName);
end
 [filename, PathName]=uiputfile([PathName '\Vref.csv'],'Select save location of Vref.');
writetable(array2table(Vref,'VariableNames',{[tf '_SynResponse'], [tf '_PhotoBleach']}), [PathName filename]);


end