 function goDeep(func,filterOptions,rootDir)
        % GoDeep will evaluate the function func on specific files in
        % current directory or subdirectory. 
        % It wil look in subdirectories up to 6 deep to find files of a
        % particular type. If the file is found than, the function
        % is evaluated on that directory.
        % The type can be specified with filterOptions.
        % If these particular files are found, than the subsequent
        % subdirectories of that folder are NOT looked into. 
        global defaultDir;
        
        if nargin<3  
            if exist('defaultDir')
            [dataDirname] = uigetdir(defaultDir,'Select dir:');
            defaultDir =  [dataDirname '\..'];
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
                      
        if 1 %Try to overwrite goDeep wit goAllsubdir
        goAllSubDir(func,filterOptions,rootDir);
        else
        if isempty(dir([dataDirname filterOptions]))
            d2= dir([dataDirname '\*.*']);
            d2(~[d2.isdir])=[]; % remove files, keep subdirs
            for  i=1:(length(d2)-2) % remove . and ..
                if isempty(dir([dataDirname '\' d2(i+2).name filterOptions]))
                    d3= dir([dataDirname '\' d2(i+2).name '\*.*']);
                    d3(~[d3.isdir])=[]; % remove files, keep subdirs
                    for  ii=1:(length(d3)-2) % remove . and ..
                        if isempty(dir([dataDirname '\' d2(i+2).name '\' d3(ii+2).name filterOptions]))
                            d4= dir([dataDirname '\' d2(i+2).name '\' d3(ii+2).name '\*.*']);
                            d4(~[d4.isdir])=[]; % remove files, keep subdirs
                            for  iii=1:(length(d4)-2) % remove . and ..
                                if isempty(dir([dataDirname '\' d2(i+2).name '\' d3(ii+2).name '\' d4(iii+2).name filterOptions]))
                                    d5= dir([dataDirname '\' d2(i+2).name '\' d3(ii+2).name '\' d4(iii+2).name '\*.*']);
                                    d5(~[d5.isdir])=[]; % remove files, keep subdirs
                                    for  iiii=1:(length(d5)-2) % remove . and ..
                                        if isempty(dir([dataDirname '\' d2(i+2).name '\' d3(ii+2).name '\' d4(iii+2).name '\' d5(iiii+2).name filterOptions]))
                                        else
                                            func([dataDirname '\' d2(i+2).name '\' d3(ii+2).name '\' d4(iii+2).name '\' d5(iiii+2).name]);
                                        end
                                    end
                                else
                                    func([dataDirname '\' d2(i+2).name '\' d3(ii+2).name '\' d4(iii+2).name]);
                                end
                            end
                        else
                            func([dataDirname '\' d2(i+2).name '\' d3(ii+2).name]);
                        end
                    end
                else
                    func([dataDirname '\' d2(i+2).name]);
                end
            end
        else
            func(dataDirname);
        end
        end
        end