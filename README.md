
# My linux dotfiles ⌨

![desktop](https://user-images.githubusercontent.com/46892933/276923500-ff86f299-7037-4d13-b110-33c1d2d80ebf.png)

*Includes configuration files for*:
| **Window manager**       | **[sway](https://github.com/swaywm/sway)**              |
|:-------------------------|:--------------------------------------------------------|
| **Status bar**           | **[waybar](https://github.com/Alexays/Waybar)**         |
| **Application launcher** | **[wofi](https://hg.sr.ht/~scoopta/wofi)**              |
| **Notification daemon**  | **[dunst](https://github.com/dunst-project/dunst)**     |
| **Terminal**             | **[alacritty](https://github.com/alacritty/alacritty)** |
| **File manager**         | **[nnn](https://github.com/jarun/nnn)**                 |
| **Editor**               | **[neovim](https://github.com/neovim/neovim)**          |
| **Terminal multiplexer** | **[tmux](https://github.com/tmux/tmux.git)**            |
| **Shell**                | **[zsh](https://github.com/zsh-users/zsh.git)**         |

*Deploybale to \$HOME with GNU Stow*:

```bash
# link configuration files for cli programs
./install.sh --term
# link configuration files for programs available in desktop environment
./install.sh --desktop
```
