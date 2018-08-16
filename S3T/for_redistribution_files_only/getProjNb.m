    function i=getProjNb(project,str)
    % Finds the project containing a particular string   
    % e.g. C10dirname = project.exp{getProjNb('10AP Control')}.Dir;
    
    i=1;
    ff = length (project.exp); 
        while ( ~strcmp([project.exp{i}.Stim ' ' project.exp{i}.Compound],str))
            i=i+1;
            if i>ff
                error(['could not find :' str]);
            end
        end
        i;
    end