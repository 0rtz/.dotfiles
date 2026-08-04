# XDG Base Directory Specification
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state
set -gx XDG_CACHE_HOME $HOME/.cache

set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx LC_CTYPE en_US.UTF-8

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER 'less -r -M'

# https://github.com/sharkdp/bat
if command -q bat
    set -gx MANPAGER 'bat -plman'
    set -gx BAT_THEME 'Catppuccin Mocha'
end

# /usr/bin/ssh-agent socket
set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

# fzf fuzzy finder https://github.com/junegunn/fzf
set -gx FZF_DEFAULT_OPTS "-m \
--bind ctrl-d:preview-page-down,\
ctrl-u:preview-page-up,\
ctrl-s:jump,\
ctrl-space:toggle,\
ctrl-a:toggle-all,\
'ctrl-v:transform-query:echo -n {q}; if [ \"\$XDG_SESSION_TYPE\" = \"wayland\" ]; then wl-paste; else xclip -o -selection clipboard; fi'"
set -gx FZF_DEFAULT_COMMAND 'rg --files --hidden -g "!.git"'

# Git with fzf (wfxr/forgit)
set -gx FORGIT_NO_ALIASES true
if test "$XDG_SESSION_TYPE" = wayland
    set -gx FORGIT_COPY_CMD wl-copy
else
    set -gx FORGIT_COPY_CMD 'xclip -i -selection clipboard'
end
set -gx FORGIT_FZF_DEFAULT_OPTS "--bind ctrl-s:jump"
# Delta (child process) requires access to COLUMNS environment variable when running inside forgit
# https://github.com/wfxr/forgit/issues/121#issuecomment-1380022751
set -gx COLUMNS $COLUMNS
