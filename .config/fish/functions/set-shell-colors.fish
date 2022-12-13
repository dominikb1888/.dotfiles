function set-shell-colors --on-variable="term_background"
    # Set LS_COLORS
    set -xg LS_COLORS (/nix/store/dyp97wn2rz87wimh22qshpprdrfjhmsi-vivid-0.8.0/bin/vivid generate solarized-$term_background)

    # Set color variables
    if test "$term_background" = light
        set emphasized_text brgreen # base01
        set normal_text bryellow # base00
        set secondary_text brcyan # base1
        set background_light white # base2
        set background brwhite # base3
    else
        set emphasized_text brcyan # base1
        set normal_text brblue # base0
        set secondary_text brgreen # base01
        set background_light black # base02
        set background brblack # base03
    end

    # Set Fish colors that change when background changes
    set -g fish_color_command $emphasized_text --bold # color of commands
    set -g fish_color_param $normal_text # color of regular command parameters
    set -g fish_color_comment $secondary_text # color of comments
    set -g fish_color_autosuggestion $secondary_text # color of autosuggestions
    set -g fish_pager_color_prefix $emphasized_text --bold # color of the pager prefix string
    set -g fish_pager_color_description $selection_text # color of the completion description
    set -g fish_pager_color_selected_prefix $background
    set -g fish_pager_color_selected_completion $background
    set -g fish_pager_color_selected_description $background

    # Use correct theme for `bat`.
    set -xg BAT_THEME "Solarized ($term_background)"

    # Use correct theme for `btm`.
    if test "$term_background" = light
        alias btm "btm --color default-light"
    else
        alias btm "btm --color default"
    end

    # Set `background` of all running Neovim instances.
    for server in (/nix/store/yyfwy71dk8nnh4p0y1sxjvagxvgng5xg-neovim-remote-2.5.1/bin/nvr --serverlist)
        /nix/store/yyfwy71dk8nnh4p0y1sxjvagxvgng5xg-neovim-remote-2.5.1/bin/nvr -s --nostart --servername $server \
            -c "set background=$term_background" &
    end
end
