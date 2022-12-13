function nvimGoToLine
    set nvimExists (which nvim)
    if [ -z "$nvimExists" ]
        return
    end

    set selection (displayRgPipedFzf)
    if [ -z "$selection" ]
        return
    else
        set filename (echo $selection | cut -d: -f1)
        set line (echo $selection | cut -d: -f2)
        nvim $filename "+$line" "+normal zz^"
    end
end
