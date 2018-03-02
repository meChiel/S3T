function dir = getProjDir(project,str)
    dir = project.exp{getProjNb(project,str)}.dir;
end