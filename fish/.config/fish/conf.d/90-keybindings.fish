status is-interactive; or return

# Enable vi mode: https://fishshell.com/docs/current/cmds/fish_vi_key_bindings.html
fish_vi_key_bindings

# Builtin commands: https://fishshell.com/docs/current/cmds/bind.html
function fish_user_key_bindings
    # Normal mode
    bind -M default H beginning-of-line
    bind -M default L end-of-line
    bind -M default s toggle_sudo

    # Insert mode
    bind -M insert kj 'set fish_bind_mode default; commandline -f repaint-mode'
    bind -M insert ctrl-y fish_clipboard_copy
    bind -M insert ctrl-v fish_clipboard_paste
    bind -M insert ctrl-g edit_command_buffer
    bind -M insert ctrl-e end-of-line
    bind -M insert ctrl-p history-search-backward
    bind -M insert ctrl-n history-search-forward
    bind -M insert ctrl-f list_aliases
    bind -M insert ctrl-s my-ripgrep-fzf
    bind -M insert ctrl-k complete-and-search
    bind -M insert ctrl-j '
        if commandline --search-field >/dev/null
            # Inside pager
            commandline -f complete
        else
            magic_enter
        end
    '
    bind -M insert ctrl-c '
        if commandline --search-field >/dev/null
            # Inside pager
            commandline -f cancel
        else
            commandline -f cancel-commandline
        end
    '

    # Visual mode
    bind -M visual gg beginning-of-buffer
    bind -M visual -m default p vi_visual_paste
    bind -M visual G end-of-buffer
    bind -M visual H beginning-of-line
    bind -M visual L end-of-line
    # Find down/uppercase function name: bind -M visual | grep -i -e "g,u"
    bind -M visual u downcase-selection end-selection repaint-mode
    bind -M visual U upcase-selection end-selection repaint-mode
end
