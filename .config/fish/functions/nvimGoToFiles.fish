function nvimGoToFiles
    set nvimExists (which nvim)
    if [ -z "$nvimExists" ]
        return
    end

    set selection (displayFZFFiles)
    if [ -z "$selection" ]
        return
    else
        nvim $selection
    end
end
