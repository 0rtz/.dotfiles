alias e='my-eval-var'
if ! alias m >/dev/null 2>&1; then
	alias m='my-man-fzf'
fi
alias v='my-editor-open'
alias vt='my-create-edit-tmp'
alias vx='my-create-script'
alias pw='my-powermenu-fzf'
alias cpf='my-yank-to-clipboard'
alias rn='my-tmux-session-run-cmd ""'
alias pss='my-processes-search'
alias rnd='my-tmux-session-create-run-cmd ""'
alias rgf='my-ripgrep-fzf'
alias nf='my-notfiy-wrapper'
alias -g Y='| my-yank-to-clipboard'
alias -g F='| my-yank-fzf'