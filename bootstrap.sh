#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES_DIR"

TERM_PACKAGES=(fish nvim yazi zellij scripts)
DESKTOP_PACKAGES=(desktop)
ALL_PACKAGES=("${TERM_PACKAGES[@]}" "${DESKTOP_PACKAGES[@]}")

# --- Logging ---

info()    { printf '\033[1;34m::\033[0m %s\n' "$*"; }
success() { printf '\033[1;32m::\033[0m %s\n' "$*"; }
error()   { printf '\033[1;31m::\033[0m %s\n' "$*" >&2; }
header()  { printf '\n\033[1;35m>>> %s\033[0m\n' "$*"; }

require() {
	for cmd in "$@"; do
		command -v "$cmd" &>/dev/null || { error "Required command not found: $cmd"; exit 1; }
	done
}

# --- Core operations ---

link_packages() {
	header "Linking packages: $*"
	stow --restow --verbose=1 --target "$HOME" --dir "$DOTFILES_DIR" "$@"
}

unlink_packages() {
	header "Unlinking packages: $*"
	stow -D --verbose=1 --target "$HOME" --dir "$DOTFILES_DIR" "$@"
}

# --- Plugin installers ---

configure_yazi() {
	header "Installing yazi plugins"
	ya pkg install
}

configure_fish() {
	header "Set fish theme Catppuccin Mocha"
	# set -o pipefail requires to swallow exit code
	yes | fish -c 'fish_config theme save "catppuccin-mocha" --color-theme=dark' || true

	header "Installing fish plugins (Fisher)"
	fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update"
	# https://github.com/IlanCosman/tide/wiki/Syncing-your-tide-config-in-your-dotfiles
	fish -c "tide configure --auto --style=Lean --prompt_colors='True color' --show_time=No --lean_prompt_height='Two lines' --prompt_connection=Disconnected --prompt_spacing=Sparse --icons='Few icons' --transient=No"
}

# --- Commands ---

cmd_install() {
	local scope="${1:-all}"
	local term_bin_names=(stow fish yazi nvim)
	local desktop_bin_names=(stow alacritty dunst hyprland rofi sway waybar)
	case "$scope" in
		term)
			require "${term_bin_names[@]}"
			link_packages "${TERM_PACKAGES[@]}"
			configure_fish
			configure_yazi
			;;
		desktop)
			require "${desktop_bin_names[@]}"
			link_packages "${DESKTOP_PACKAGES[@]}"
			;;
		all)
			require "${term_bin_names[@]}" "${desktop_bin_names[@]}"
			link_packages "${ALL_PACKAGES[@]}"
			configure_fish
			configure_yazi
			;;
		*) error "Unknown scope: $scope (use term, desktop, or all)"; exit 1 ;;
	esac
	success "Install complete"
	echo
	show_banner
}

cmd_update() {
	if command -v fish &>/dev/null && [[ -f "$HOME/.config/fish/fish_plugins" ]]; then
		header "Updating fish plugins"
		fish -c "fisher update"
		header "Generating fish completions from man pages"
		fish -c "fish_update_completions"
	fi
	if [[ -d "$HOME/.config/nvim" ]]; then
		header "Updating neovim plugins"
		nvim --headless -c 'lua vim.pack.update(nil, { force = true })' -c 'sleep 10' -c 'qa!'
	fi
	if command -v ya &>/dev/null; then
		header "Updating yazi plugins"
		ya pkg upgrade
	fi
	success "Update complete"
}

cmd_unlink() {
	unlink_packages "${ALL_PACKAGES[@]}"
	success "All packages unlinked"
}

cmd_health() {
	local ok=$'\033[1;32m✓\033[0m' fail=$'\033[1;31m✗\033[0m' warn=$'\033[1;33m!\033[0m'
	check() {
	  if command -v "$1" >/dev/null 2>&1; then
		version=$({ "$1" --version 2>/dev/null || "$1" -V 2>/dev/null; } | head -n 1)
		printf " $ok %-12s %s\n" "$1" "$version"
	  else
		printf " $fail %-12s not found\n" "$1"
	  fi
	}

	header "Required tools"
	for cmd in fish nvim yazi zellij stow git fzf rg eza; do check "$cmd"; done

	header "Environment"
	[[ "$TERM" == *256color* || "$TERM" == *alacritty* ]] \
									 && printf " %s TERM=%s\n" "$ok" "$TERM" || printf " %s TERM=%s (may lack color support)\n" "$warn" "$TERM"
	[[ "$(locale charmap 2>/dev/null)" == UTF-8 ]] \
									 && printf " %s locale is UTF-8\n" "$ok" || printf " %s locale is not UTF-8\n" "$warn"
	[[ -n "$(git config user.name)" && -n "$(git config user.email)" ]] \
									 && printf " %s git user configured\n" "$ok" || printf " %s git user.name/email not set\n" "$warn"

	header "Symlinks"
	local stow_ok=true
	for pkg in "${ALL_PACKAGES[@]}"; do
		[[ -d "$DOTFILES_DIR/$pkg" ]] || continue
		if stow --simulate --verbose "$pkg" 2>&1 | grep -q "LINK"; then
			printf " $fail %s has missing links\n" "$pkg"
			stow_ok=false
		fi
	done
	$stow_ok && printf " %s all stow symlinks intact\n" "$ok"

	header "Plugin managers"
	fish -c 'type -q fisher' 2>/dev/null && printf " %s fisher present\n" "$ok" || printf " %s fisher not found\n" "$fail"

	header "Truecolor test (lines should be continuous)"
	fish -c "my-24-bit-color.sh"
	header "Clipboard test"
	fish -c "echo 123 | my-yank-to-clipboard"
}

show_banner() {
	printf '\033[1;35m'
	cat << 'EOF'
                             😈
  😈                                     😈                            😈
██████╗  █████╗ ███████╗███████╗██████╗     ██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗
██╔══██╗██╔══██╗██╔════╝██╔════╝██╔══██╗    ██║     ██║████╗  ██║██║   ██║╚██╗██╔╝
██████╔╝███████║███████╗█████╗  ██║  ██║    ██║  😈 ██║██╔██╗ ██║██║   ██║ ╚███╔╝
██╔══██╗██╔══██║╚════██║██╔══╝  ██║  ██║    ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗
██████╔╝██║  ██║███████║███████╗██████╔╝    ███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗
╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝╚═════╝     ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝
                       😈              😈
 ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗                😈
██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝
██║     ██║😈 ██║██╔██╗ ██║█████╗  ██║██║  ███╗      😈
██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║                         😈
╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝
 ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝
                                                😈
😈██████╗ ███████╗██████╗ ██╗ 😈   ██████╗ ██╗   ██╗███████╗██████╗
  ██╔══██╗██╔════╝██╔══██╗██║     ██╔═══██╗╚██╗ ██╔╝██╔════╝██╔══██╗
  ██║  ██║█████╗  ██████╔╝██║     ██║   ██║ ╚████╔╝ █████╗  ██║  ██║
  ██║  ██║██╔══╝  ██╔═══╝ ██║     ██║   ██║  ╚██╔╝  ██╔══╝  ██║  ██║  😈
  ██████╔╝███████╗██║ 😈  ███████╗╚██████╔╝   ██║   ███████╗██████╔╝
  ╚═════╝ ╚══════╝╚═╝     ╚══════╝ ╚═════╝    ╚═╝   ╚══════╝╚═════╝
                                    😈                    😈
 █████╗ ███╗ 😈██╗██████╗     ██████╗ ███████╗ █████╗ ██████╗ ██╗   ██╗
██╔══██╗████╗  ██║██╔══██╗    ██╔══██╗██╔════╝██╔══██╗██╔══██╗╚██╗ ██╔╝
███████║██╔██╗ ██║██║  ██║ 😈 ██████╔╝█████╗  ███████║██║  ██║ ╚████╔╝
██╔══██║██║╚██╗██║██║  ██║    ██╔══██╗██╔══╝  ██╔══██║██║  ██║  ╚██╔╝    😈
██║  ██║██║ ╚████║██████╔╝    ██║  ██║███████╗██║  ██║██████╔╝   ██║
╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝    ╚═╝
 😈                                                        😈
          😈
EOF
	printf '\033[0m'
}

usage() {
	cat <<-EOF
	Usage: $(basename "$0") <command>

	Commands:
	    install [term|desktop|all]  Link dotfiles and install plugins (default: all)
	    update                      Update all managed plugins
	    unlink                      Remove all symlinks from \$HOME
	    health                      Verify setup

	Options:
	    -h, --help                  Show this help
	EOF
}

# --- Main ---

case "${1:-}" in
	install)  shift; cmd_install "${1:-all}" ;;
	update)   cmd_update ;;
	unlink)   cmd_unlink ;;
	health)   cmd_health ;;
	-h|--help)
		usage
		;;
	*)
		usage
		exit 1
		;;
esac