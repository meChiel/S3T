  function well = readAndorFile(andorfilename)
        fileID = fopen(andorfilename);
        A = fread(fileID,'*char')';
        fclose(fileID);
        wellPositions = strfind(A,'Well ');
        nWells = str2num(A(wellPositions(1)+7+(0:1)));
        if nWells == (length(wellPositions)+1)
            warning ('Something wrong with Andor file')
        end
        for i=2:length(wellPositions)
            well(i-1) = str2num(A(wellPositions(i)+5+(0:1)));
        end
        
    end