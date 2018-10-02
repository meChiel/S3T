
    function number = extractNumber(filename)
    % Function to extract the number out of the filename of a 96-well
    % recording.
    if iscell(filename)
        for i=1:length(filename)
        [~, number(i), ~]= disassembleName(filename{i});
        end
    else
    [~, number, ~]= disassembleName(filename);
    end
    end