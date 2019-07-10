function createRef()

[A, fname, FileName, PathName, U, S, V, error]=loadTiff([],1);
Uref=U;
Vref=V;
Sref=S;
%%
V=squeeze(mean(mean(A)));
%% decompose reference in photobleach and signal
%[bcresponse, dff, BC, mstart]=findBaseFluorPoints(V(:,1)',2);
[bcresponse, dff, BC, mstart]=findBaseFluorPoints(V(:)',2);

% The first signal will be used for the mask creation when using DICT.
Vref=[bcresponse' BC'];

try
    gg=strfind(FileName,'_e0');
    tf=FileName(gg+1:gg+5);
catch
    tf=text2OKname(FileName);
end
writetable(array2table(Vref,'VariableNames',{[tf '_SynResponse'], [tf '_PhotoBleach']}),[PathName '\Vref.csv']);


end