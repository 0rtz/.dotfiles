#!/bin/bash

function check_prog() {
	for prg in "$@"
	do
		if ! hash "$prg" > /dev/null 2>&1; then
			echo "Command not found: $prg. Aborting..."
			exit 1
		fi
	done
}

term_configs=(zsh nnn nvim tmux)
desktop_configs=(desktop)

function install_term() {
	echo -e "\n\n======================================== Linking cli programs dotfiles ========================================\n"
	for e in "${term_configs[@]}"; do
		stow --verbose=2 --target "$HOME" "$e"|| { echo -e "\n\nError: stow terminal failed" >&2; exit 1; }
	done

	# Plug 'iamcco/markdown-preview.nvim' is not installed correctly when run headless
	# https://github.com/iamcco/markdown-preview.nvim/issues/497
	# echo -e "\n\n======================================== Installing neovim plugins ========================================\n"
	# nvim --headless -c "PlugInstall --sync" +qall

	echo -e "\n\n======================================== Installing tmux plugins ========================================\n"
	./tmux/.config/tmux/plugins/tpm/bin/install_plugins

	echo -e "\n\n======================================== Installing zsh plugins ========================================\n"
	zsh -ic "fast-theme XDG:overlay"
}

function install_desktop() {
	echo -e "\n\n======================================== Linking desktop programs dotfiles ========================================\n"
	for e in "${desktop_configs[@]}"; do
		stow --verbose=2 --target "$HOME" "$e" || { echo -e "\n\nError: stow desktop failed" >&2; exit 1; }
	done
}

function update() {
	local -a submodules_paths
	local is_init=true
	cd "$(dirname "$0")" || { echo "cd failure" >&2; exit 1; }
	IFS=$'\n' read -r -d '' -a submodules_paths < <( git config --file .gitmodules --path --get-regexp 'submodule.*.path$' | cut -d " " -f 2 )
	for i in "${submodules_paths[@]}"
	do
		if ! ls "$i"/.git >/dev/null 2>&1 ; then
			echo >&2 "$i module not initialized."
			is_init=false
		fi
	done
	if [ "$is_init" = true ]; then
		if [ -f "$HOME/.config/nvim/init.vim" ]; then
			echo -e "\n\nvim plugins:\n"
			nvim --headless -c "PlugInstall --sync" +qall
		fi
		if [ -f "$HOME/.config/tmux/tmux.conf" ]; then
			echo -e "\n\ntmux plugins:\n"
			./tmux/.config/tmux/plugins/tpm/bin/update_plugins all
		fi
		if [ -f "$HOME/.zshrc" ]; then
			echo -e "\n\nzsh plugins:\n"
			zsh -i -c "zinit update --parallel | sed 's/\x1B\[[0-9;]\{1,\}[A-Za-z]//g'"
			zsh -i -c "zinit self-update | sed 's/\x1B\[[0-9;]\{1,\}[A-Za-z]//g'"
		fi
		echo -e "\n\nVim updated. Do not forget:\n1) ':Mason' -> 'Shift+U' to update outdated LSPs\n2) my_vim_check_plugins.sh"
	else
		echo "Initializing repo submodules..."
		git submodule update --checkout --init --jobs "$(nproc)" --depth 1
	fi
}

function clear() {
	for e in "${term_configs[@]}"; do
		stow --verbose=2 -D --target "$HOME" "$e"
	done
	for e in "${desktop_configs[@]}"; do
		stow --verbose=2 -D --target "$HOME" "$e"
	done
}

function check_health() {
	printf "Lines of colors should be continuous:\n"
	curl -s https://raw.githubusercontent.com/JohnMorales/dotfiles/master/colors/24-bit-color.sh | bash
	zsh -i -c "echo 123 | my-yank-to-clipboard "
}

usage="
$(basename "$0") [OPTION]

Script to install dotfiles

OPTION:
	-t | --term
		link dotfiles only for programs that are available through terminal interface
		install plugins with (nvim, tmux, zsh) plugin manager

	-d | --desktop
		link dotfiles only for desktop programs

	-u | --update
		update:
			nvim plugins
			tmux plugins
			zsh plugins
		or initialize git submodules if they are not initialized already

	-c | --clear
		unlink configuration files from \$HOME

	--checkhealth
		check whether everything set up right
"

CLI=1
DESK=1
while (( $# )); do
	case "$1" in
		-t|--term)
			DESK=0
			shift
			;;
		-d|--desktop)
			CLI=0
			shift
			;;
		-h|--help)
			echo "$usage"
			exit
			;;
		-u|--update)
			update
			exit
			;;
		--checkhealth)
			check_health
			exit
			;;
		-c|--clear)
			clear
			exit
			;;
		-*)
			echo "Error: Unsupported flag $1" >&2
			exit 1
			;;
	esac
done

if [[ $CLI -eq 0 && $DESK -eq 0 ]]
then
	echo "Error: specify --term or --desktop flags" >&2
	exit 1
fi

check_prog stow curl zsh nvim tmux

if [[ $CLI -ne 0 ]]
then
	install_term
fi
if [[ $DESK -ne 0 ]]
then
	install_desktop
fi
