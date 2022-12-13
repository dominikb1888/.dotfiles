function set-background-to-macOS
    # Returns 'Dark' if in dark mode fails otherwise.
    if defaults read -g AppleInterfaceStyle &>/dev/null
        set -U term_background dark
    else
        set -U term_background light
    end
end
