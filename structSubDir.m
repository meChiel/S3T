
    function [ss, tifdirs]=structSubDir(pp)
        for k=1:length(pp)
            tifdirs = dir([pp{k} '\*.*']);
            tifdirs=tifdirs([tifdirs.isdir]);
            ss=[];
            if length(tifdirs)>2
                for j=3:length(tifdirs)
                    cp = [pp{k} tifdirs(j).name];
                    tifFiles = dir([cp '\*.tif']);
                    
                    %%
                    s=[];
                    for i=1:length(tifFiles)
                        eval(['s.' text2OKname(tifFiles(i).name) '= 0'] )
                    end
                    eval(['ss.' text2OKname(tifdirs(j).name) '= s']);
                    sst=structSubDir({[pp{k} tifdirs(j).name]});
                    eval(['sss.' text2OKname(tifdirs(j).name) '= sst']);
                end
            else
                ss=[];
            end
        end