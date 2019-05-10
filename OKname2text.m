function label = OKname2text(okname)
% Converts variableName compliant strings into text with spaces and special
% characters. 

    label=okname;
    label=strrep(label,'SU_','_');
    label=strrep(label,'SP_','.');
    label=strrep(label,'ID_','');
	label=strrep(label,'_COMMA_',',');
    label=strrep(label,'_MIN_','-');
    label=strrep(label,'_PLUS_','+');
    label=strrep(label,'_PCT_'	,'%');
    label=strrep(label,'_OB_'	,'(');
    label=strrep(label,'_CB_'	,')');
    label=strrep(label,'_OCB_'	,'{');
    label=strrep(label,'_CCB_'	,'}'); % Close Curly Brackets
    label=strrep(label,'_PNT_'	,'.');
    label=strrep(label,'_FSLSH_','/'); % Forward-Slash
    label=strrep(label,'_BSLSH_','\'); % Back-Slash
    label=strrep(label,'_MICRO_','µ'); % Back-Slash
    label=strrep(label,'___'	,' '); % Do this last because 3x_ gives problems with subsequent _


end