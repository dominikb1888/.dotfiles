if status is-interactive
    # Commands to run in interactive sessions can go here
end

if not set -q TMUX
  set -g TMUX tmux new-session -d -s base
  eval $TMUX
  tmux attach-session -d -t base
end

set -U fish_greeting ""
set -gx LANG en_US
set -gx LC_ALL en_US.UTF-8

fish_add_path /usr/local/bin/
fish_add_path /Users/dboehler/.local/bin/
fish_add_path /Users/dboehler/.cargo/bin/
fish_add_path /Users/dboehler/.config/db_scripts/
 . ~/perl5/perlbrew/etc/perlbrew.fish 


# neofetch 

alias cl 'clear'

alias vim 'lvim'
alias vi 'lvim'
alias v 'lvim'

alias ll  'exa --icons --long --header --git'
alias l  'exa'
alias lr 'exa --tree --recurse --level=2'
alias lrr 'exa --tree --recurse --level=3'
alias ld 'exa -aG | grep "^\."'

alias cat 'bat'
alias agenda 'gcalcli agenda --details location'

set -gx EDITOR vim

function crop 
   open -a /System/Applications/Photos.app/Contents/MacOS/Photos $argv --args Editor
end

function fish_user_key_bindings
      fzf_key_bindings
end

function google
  open 'https://www.google.de/search?q='$argv
end

# TokyoNight Color Palette
    set -l foreground c0caf5
    set -l selection 33467C
    set -l comment 565f89
    set -l red f7768e
    set -l orange ff9e64
    set -l yellow e0af68
    set -l green 9ece6a
    set -l purple 9d7cd8
    set -l cyan 7dcfff
    set -l pink bb9af7
    
    # Syntax Highlighting Colors
    set -g fish_color_normal $foreground
    set -g fish_color_command $cyan
    set -g fish_color_keyword $pink
    set -g fish_color_quote $yellow
    set -g fish_color_redirection $foreground
    set -g fish_color_end $orange
    set -g fish_color_error $red
    set -g fish_color_param $purple
    set -g fish_color_comment $comment
    set -g fish_color_selection --background=$selection
    set -g fish_color_search_match --background=$selection
    set -g fish_color_operator $green
    set -g fish_color_escape $pink
    set -g fish_color_autosuggestion $comment
    
    # Completion Pager Colors
    set -g fish_pager_color_progress $comment
    set -g fish_pager_color_prefix $cyan
    set -g fish_pager_color_completion $foreground
    set -g fish_pager_color_description $comment

starship init fish | source
