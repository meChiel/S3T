
    function number = extractNumber(filename)
    % Function to extract the number out of the filename of a 96-well
    % recording.
    if iscell(filename)
        for i=1:length(filename)
            % [~, number(i), ~]= disassembleName(filename{i});
            try
                number(i)=getENumber(filename{i});
            catch
                disp(filename{i});
                number(i-1)
                error(['getENumber of :' filename{i}]);
            end
        end
    else
        [~, number, ~]= disassembleName(filename);
        number=getENumber(filename);
    end
    end
    
    function number=getENumber(filename)
    eidx = strfind(filename,'_e');
    if ~isempty(eidx)
        Nendidx = strfind(filename(eidx+1:end),'_');
        if isempty(Nendidx)
            Nendidx = strfind(filename(eidx+1:end),'.');
        end
        number=str2num(filename(eidx+2:eidx+Nendidx-1));
    else
        number = catNumbers(filename,4);
        disp('Did not find file "_e" in filenames, creating id from last 4 numbers in filename. PLease use  _e0001_as in file for generting unique ids.');
        disp(['Number used == ' num2str(number)]);
    end
    end