if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -U fish_greeting ""
set -gx LANG en_US
set -gx LC_ALL en_US.UTF-8

fish_add_path /usr/local/bin/
fish_add_path /Users/dboehler/.local/bin/
fish_add_path /Users/dboehler/.cargo/bin/
fish_add_path /Users/dboehler/.zk/bin
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
alias icat 'kitty +kitten icat'

# alias agenda 'gcalcli agenda --details location' # Some auth issue hence deactivated
alias agenda "icalBuddy -f -npn -nc -iep 'datetime,title,location' -ps '/ | /' -po 'datetime,title,location' -ec ecri_shared_by_jrieder eventsToday"
alias agendavim "icalBuddy -b '## ' -npn -nc -iep 'datetime,title,location' -ps '| - | - | \\n\\n |' -po 'datetime,title,location' -ec ecri_shared_by_jrieder eventsToday"
set -gx EDITOR vim
set -gx ZK_PATH /Users/dboehler/Notes

alias pytest 'python3 -m pytest'

function crop 
   open -a "/System/Applications/Photos.app/Contents/MacOS/Photos" $argv --args Editor
end

function google
  open 'https://www.google.de/search?q='$argv
end

function rgvim
    set choice (rg -il $argv | fzf -0 -1 --ansi --preview "cat {} | rg $argv --context 3")
    if [ $choice ]
        nvim "+/"(string lower $argv) $choice
    end
end


function mail
    export FZF_DEFAULT_COMMAND='himalaya list -s 200' &&
      fzf --bind "space:execute(himalaya reply {1})+reload($FZF_DEFAULT_COMMAND),esc:execute-silent(himalaya delete {1})+reload($FZF_DEFAULT_COMMAND),ctrl-f:execute(himalaya forward {1})+reload($FZF_DEFAULT_COMMAND),ctrl-a:execute(himalaya attachments {1})" \
      --preview 'himalaya read {1} -t html | w3m -T text/html' \
      --header-lines=2\
      --header 'Space: Reply, Esc: Delete, Ctrl-f: Foward, Ctrl-a: Attachments, Ctrl-c: Exit'\
      --layout=reverse\
      --ansi
end

function zmd
    open -a "Google Chrome" "https://th-deg-de.zoom.us/j/9730540869" 
end


function zm
   open -a "Google Chrome"  "https://us04web.zoom.us/j/7166244957?pwd=S0llcjU1S0FWb1lwUnR3TXpndUNadz09"
end

if status is-interactive && test -f ~/.config/fish/custom/git_fzf.fish
	source ~/.config/fish/custom/git_fzf.fish
	git_fzf_key_bindings
end

function brdiff
    set -l paths
    set current (git branch --show-current)
    for branch in (git branch -l | fzf -m | tr -d '[*+ ]') 
        if [ $branch = $current ]
           set -a paths $argv[1]
        else
           git worktree add "../$branch"
           set -a paths "../$branch/$argv[1]"
        end
    end
    vim -O $paths
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
fish_add_path /usr/local/opt/python@3.10/bin

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /Users/dboehler/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<
