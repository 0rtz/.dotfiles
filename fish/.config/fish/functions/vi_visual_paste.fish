# Vim-like visual mode paste: replace the selection with the last yank

function vi_visual_paste
    # Exclusive end mode, otherwise the cursor clamps one char to the left when
    # the selection touches the end of the buffer and the paste lands too early
    set -g fish_cursor_end_mode exclusive
    # kill-selection pushes the selection onto the killring, yank re-inserts it,
    # yank-pop rotates to the previously yanked entry
    commandline -f kill-selection -f yank -f yank-pop -f end-selection -f repaint-mode
    set -g fish_cursor_end_mode inclusive
end
