function oklabel= text2OKname(label)
% Converts text with spaces and special characters in to a variableName
% compliant string(s).
oklabel=label;
%if ~isempty(str2num(oklabel))
if ~isempty(str2num(oklabel(1)))
    oklabel= ['ID_' oklabel];
end
if strcmp(oklabel(1),'_')
    oklabel= ['SU_' oklabel(2:end)]; %Starting Underscore
end
if strcmp(oklabel(1),'.')
    oklabel= ['SP_' oklabel(2:end)]; %Starting Point
end

oklabel=strrep(oklabel,',','_COMMA_');
oklabel=strrep(oklabel,'-','_MIN_');
oklabel=strrep(oklabel,'%','_PCT_');
oklabel=strrep(oklabel,'(','_OB_');
oklabel=strrep(oklabel,')','_CB_');
oklabel=strrep(oklabel,'{','_OCB_');
oklabel=strrep(oklabel,'}','_CCB_'); % Close Curly Brackets
oklabel=strrep(oklabel,'.','_PNT_');
oklabel=strrep(oklabel,'/','_FSLSH_'); % Forward-Slash
oklabel=strrep(oklabel,'\','_BSLSH_'); % Back-Slash
oklabel=strrep(oklabel,'µ','_MICRO_'); % Back-Slash
oklabel=strrep(oklabel,' ','___');

end