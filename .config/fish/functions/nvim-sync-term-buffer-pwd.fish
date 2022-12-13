function nvim-sync-term-buffer-pwd --on-variable="PWD"
    if test -n "$NVIM"
        /nix/store/yyfwy71dk8nnh4p0y1sxjvagxvgng5xg-neovim-remote-2.5.1/bin/nvr -c "let g:term_buffer_pwds.$fish_pid = '$PWD' | call Set_term_buffer_pwd() "
    end
end
