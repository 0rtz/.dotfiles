status is-interactive; or return

# https://github.com/direnv/direnv
if command -q direnv
    direnv hook fish | source
end

# https://docs.atuin.sh/cli/guide/installation
if command -q atuin
    atuin init fish | source
end

# https://github.com/ajeetdsouza/zoxide
if command -q zoxide
    zoxide init fish | source
end

# https://lasantosr.github.io/intelli-shell/guide/installation.html#updating-profile-files
if command -q intelli-shell
    # `bind -M default | grep -i -e "intelli"`
    intelli-shell init fish | source
end
