function displayRgPipedFzf
    echo $(rg . -n --glob '!.git/' --glob '!vendor/' --glob '!node_modules/' | fzf -d ':' -n 2.. --ansi --no-sort --preview 'bat --style=numbers --color=always --highlight-line {2} {1};' --preview-window +{2}-5)
end
