function fdFzf
    set fdExists (which fd)
    if [ -z "$fdExists" ]
        return
    else
        if [ "(pwd)" = "$HOME" ]
            set goTo (fd -t d -d 1 . | fzf --preview "bat --style=numbers --color=always --line-range :500 {}")
            if [ -z "$goTo" ]
                return
            else
                cd $goTo
                return
            end
        end

        set goTo (fd -t d . | grep -vE '(node_modules)' | fzf --preview "bat --style=numbers --color=always --line-range :500 {}")
        if [ -z "$goTo" ]
            return
        else
            cd $goTo
        end
    end
end
