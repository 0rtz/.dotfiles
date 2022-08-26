# direnv: load and unload environment variables from .envrc file depending on the current directory ###
# https://github.com/romkatv/powerlevel10k#how-do-i-initialize-direnv-when-using-instant-prompt
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# load and unload environment variables from .envrc file depending on the current directory ###
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"

# my dotfiles
[ -f $HOME/.zsh/configs.zsh ] && source $HOME/.zsh/configs.zsh
[ -f $HOME/.zsh/variables.zsh ] && source $HOME/.zsh/variables.zsh
[ -f $HOME/.zsh/plugins.zsh ] && source $HOME/.zsh/plugins.zsh
[ -f $HOME/.zsh/functions.zsh ] && source $HOME/.zsh/functions.zsh
[ -f $HOME/.zsh/aliases.zsh ] && source $HOME/.zsh/aliases.zsh
[ -f $HOME/.zsh/keymaps.zsh ] && source $HOME/.zsh/keymaps.zsh

# To update prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
