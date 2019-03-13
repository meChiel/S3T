function goAllSubDir(func,filterOptions,rootDir)
        % goAllSubDir will evaluate the function func on specific files in
        % current directory or subdirectory. 
       
        global defaultDir;
        if nargin<3  
            if exist('defaultDir')
            [dataDirname] = uigetdir(defaultDir,'Select dir:');
            defaultDir =  [dataDirname '\..'];
            dataDirname = [dataDirname '\'];
            else
                [dataDirname] = uigetdir('','Select dir:');
            defaultDir =  [dataDirname '\..'];
            end
        else
            dataDirname=rootDir;  
        end
        if nargin<2
            filterOptions='\*.tif';
        end
        if 1%~isempty(dir([dataDirname filterOptions]))
            d2= dir([dataDirname '\*.*']);
            d2(~[d2.isdir])=[]; % remove files, keep subdirs
            for  i=1:(length(d2)-2) % remove . and ..
                goAllSubDir(func,filterOptions,[dataDirname '\' d2(i+2).name])
                func([dataDirname '\' d2(i+2).name]);
            end
        end