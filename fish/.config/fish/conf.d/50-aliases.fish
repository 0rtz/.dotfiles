status is-interactive; or return

function maybe_abbr
    if command -q $argv[1]
        abbr -a -p command $argv[2] $argv[3]
    end
end

########################################
# Filesystem
########################################

# Read filesystem
if command -q df
    # Disk Usage Files
    abbr -a duf 'fd -t f -x du -h {} | sort -h'
    abbr -a dufh 'fd --hidden --no-ignore -t f -x du -h {} | sort -h'
    # Disk Usage Directories
    abbr -a dud 'fd -t d -x du -sh {} | sort -h'
else
    abbr -a duf 'find . -type f -exec du -csh --apparent-size {} + | sort --human-numeric-sort'
    abbr -a dud 'du -d 1 -ch --apparent-size | sort --human-numeric-sort'
end
# Disk Usage Tui
maybe_abbr gdu dut 'gdu'
maybe_abbr duf df 'duf'
abbr -a l 'eza -aglbh --git --icons --color always --sort old --smart-group'
abbr -a tree "eza -glbh --git --icons -T -I ".git" --git-ignore -a --color always"

# Modify filesystem
abbr -a cp 'cp -i'
abbr -a mv 'mv -i'
abbr -a md 'mkdir -p'
abbr -a dd 'dd status=progress'
abbr -a ddr 'dd if=/dev/urandom bs=4K count=1 | base64 > output.dat'
abbr -a rm trash-put
abbr -a rmr 'trash-put --force --recursive --verbose'
abbr -a RM 'rm -rf --verbose'

maybe_abbr nautilus fm 'nautilus $PWD >/dev/null 2>&1 &'

########################################
# Files
########################################

abbr -a diff 'diff --color=auto'
abbr -a grep 'grep --color=auto'

abbr -a h sha1sum
abbr -a log 'my-lnav-wrapper'
abbr -a follow 'tail -n 10k -F'

abbr -a --set-cursor rg 'rg --hidden --no-ignore 2>/dev/null "%"'
abbr -a --set-cursor rga 'rga --hidden --no-ignore 2>/dev/null "%"'
abbr -a --set-cursor rgase 'my-ripgrep-all-fzf "%"'

abbr -a v my-editor-open
abbr -a vv my-open-recent
abbr -a vx my-create-script

if command -q hexyl
    abbr -a hx 'hexyl'
else
    abbr -a hx 'hexdump -C'
end
maybe_abbr bat c bat
if command -q plocate
    abbr -a ff 'sudo plocate --ignore-case'
    abbr -a ffu 'sudo updatedb'
end

########################################
# Tools
########################################

# Processes
abbr -a k kill
abbr -a K 'kill -9'
abbr -a prls 'ps aux'
abbr -a prse my-processes-search

abbr -a u 'uptime --pretty'
abbr -a make "make --jobs=(math (nproc) + 1)"
abbr -a genstr "LC_ALL=C tr -dc 'A-Za-z0-9_' </dev/urandom | head -c 12"
abbr -a mm tldr
abbr -a mmse "tldr --list | fzf"
abbr -a e my-eval-var
abbr -a nf my-notify-wrapper
abbr -a cpf my-yank-to-clipboard
abbr -a dmesg 'sudo dmesg --color=auto --follow'

maybe_abbr systeroid-tui sysctl 'systeroid-tui'
maybe_abbr zenith top 'zenith'
maybe_abbr qalc q 'qalc'

if command -q batman
    abbr -a m batman
else
    abbr -a m my-man-fzf
end
if command -q direnv
    abbr -a ea 'direnv allow .'
    abbr -a eb 'direnv block .'
end
if command -q qrencode
    abbr -a qr --set-cursor 'qrencode -m 2 -t UTF8 "%"'
end

abbr -a vs my-vscode-open

########################################
# Networking
########################################

abbr -a s my-ssh-fzf
abbr -a st 'TERM=xterm-256color ssh -Y'

abbr -a ip 'ip -color=auto'
abbr -a curl 'curl --location'
abbr -a curls 'curl --tlsv1.3 --location --proto https'
if command -q bandwhich
    abbr -a bw 'sudo bandwhich'
else
    abbr -a bw 'sudo nethogs -s'
end
maybe_abbr impala wifi 'impala'
maybe_abbr impala iwctl 'impala'

abbr -a ptse my-network-ports-fzf
abbr -a myip 'curl -s https://ipinfo.io'

########################################
# Git
########################################

### Clone ###
abbr -a gcl 'git clone --recurse-submodules --jobs (nproc)'
abbr -a gcls 'git clone --depth 1'

### Add/Stage ###
abbr -a ga 'git-forgit add'
abbr -a gaa 'git add --all'
abbr -a gas 'git add --all; git-forgit diff --staged'
abbr -a guna 'git-forgit reset_head'
# Only add already tracked modified files
abbr -a gat 'git add -u'

### Diff ###
abbr -a gd 'git-forgit diff'
abbr -a gds 'git-forgit diff --staged'
abbr -a gdh 'git-forgit diff HEAD~1 HEAD'
abbr -a gbd my-git-main-branch-diff

### Commit ###
abbr -a gc 'git commit -v && git config user.name && git config user.email'
abbr -a --set-cursor gcm 'git commit -m "%"'
abbr -a gac 'git add --all && git commit -v; git config user.name; git config user.email'
abbr -a gacp 'git add --all && git commit -v; git config user.name; git config user.email; git push'
abbr -a --set-cursor gacm 'git add --all && git commit -m "%"'
abbr -a gcca 'git commit -v --amend --no-edit --author="(git config user.name) <(git config user.email)>"'
abbr -a gccmsg 'git commit -v --amend'
abbr -a grice "git add --all && git commit -m 'ricing...'"
abbr -a gsq my-git-commit-and-squash-into-prev
abbr -a gasq 'git add --all && my-git-commit-and-squash-into-prev'
abbr -a gcoc 'git-forgit checkout_commit'

### Push ###
abbr -a gp 'git push'
abbr -a gpf 'git push --force-with-lease'
abbr -a gpu 'git push --set-upstream origin (git rev-parse --abbrev-ref HEAD)'

### Pull ###
abbr -a gl 'git pull'
abbr -a glr 'git pull --rebase'
abbr -a gla my-git-checkout-all-branches
abbr -a gf 'git fetch'
abbr -a gprune 'git fetch origin --prune'

### Branches ###
abbr -a gb 'git-forgit checkout_branch'
abbr -a gba my-git-create-branch-remote
abbr -a gbls my-git-list-branches
abbr -a gbrm my-git-delete-branch-remote
abbr -a gbrn my-git-rename-branch-remote
abbr -a gbmv 'git branch --force $BRANCH'
abbr -a gbmvcp my-git-move-on-current-cherrypick-last

### Remote ###
abbr -a gra my-add-git-remote
abbr -a grup 'git remote update'
abbr -a grls 'git remote -v'
abbr -a grrm 'git remote remove'

### History ###
abbr -a glg 'git-forgit log'
abbr -a glgfull 'git log --graph --decorate --format=full --pretty=fuller'
abbr -a glgol "my_git_log_pretty --style=15 2>&1 | less --use-color -r"
abbr -a glgb 'git log --graph --decorate --pretty=oneline --abbrev-commit --all'
abbr -a gblm 'git-forgit blame'

### Cherry-pick ###
abbr -a gcp 'git-forgit cherry_pick_from_branch'
abbr -a gcpc 'git cherry-pick --continue'
abbr -a gcpa 'git cherry-pick --abort'

### Rebase ###
abbr -a grb 'git-forgit rebase'
abbr -a grbc 'git rebase --continue'
abbr -a grba 'git rebase --abort'

### Merge ###
abbr -a gm 'git merge'
abbr -a gma 'git merge --abort'

### Submodules ###
abbr -a gsub 'git submodule init; git submodule update'
abbr -a gsu 'git submodule update --checkout --init --jobs (nproc) --depth 1'
abbr -a gsa 'git submodule add -b $BRANCH $URL'
abbr -a gsrm 'git rm $SUBMODULE_PATH'

### Revert ###
abbr -a gunmodify 'git checkout --'
abbr -a grh 'git reset --hard'
abbr -a gclean 'git-forgit clean'
abbr -a gundo 'git reflog'
abbr -a grv 'git revert'
abbr -a grvc 'git-forgit revert_commit'

### Tags ###
abbr -a gtls 'git tag | sort -V'
abbr -a gcot 'git-forgit checkout_tag'

### Ignore ###
abbr -a gia 'git-forgit ignore >> .gitignore'
abbr -a gignore 'git update-index --assume-unchanged'
abbr -a gunignore 'git update-index --no-assume-unchanged'
abbr -a gkeep 'echo >> .gitkeep'
abbr -a gignorels 'git ls-files --others --i --exclude-standard'

### Stash ###
abbr -a gsta 'git-forgit stash_push'
abbr -a gstf 'git-forgit stash_show'
abbr -a gstA 'git stash pop'
abbr -a gstls 'git stash list'
abbr -a gstrm 'git stash drop'

### Misc ###
abbr -a gst 'git status'
abbr -a gcfg my-git-repo-config
abbr -a --set-cursor ggrep 'git grep "%" (git rev-list --all)'
abbr -a gso 'git show'
abbr -a ginf "my-git-repo-info 2>&1 | $PAGER"

########################################
# npm
########################################

abbr -a npmr 'npm run start'
abbr -a npma 'npm install -g'
abbr -a npmrm 'npm uninstall -g'
abbr -a npmls 'npm list -g'

########################################
# Python
########################################

abbr -a p python3
abbr -a pv my-create-python-env
if command -q pipx
    abbr -a pxa 'pipx install'
    abbr -a pxls 'pipx list'
    abbr -a pxrm 'pipx uninstall'

end
if command -q pip
    abbr -a pipa 'pip install'
    abbr -a piprm 'pip uninstall'
    abbr -a pipls 'pip list'
end

########################################
# Distribution-specific
########################################

if command -q pacman
    abbr -a pu 'sudo pacman -Syu'
    abbr -a pa my-packages-install
    abbr -a prm 'sudo pacman -Rns'
    abbr -a pls my-packages-list
    abbr -a plsa 'pacman -Q'
    abbr -a pse 'pacman -F'
    abbr -a pown 'pacman -Qo'

    abbr -a ya "yay --aur -Sl | fzf --multi --preview-window=wrap --preview 'cat <(yay -Si {2})' | cut -d' ' -f2 | xargs -ro yay -S"
end

########################################
# Zellij
########################################

abbr -a ta 'zellij attach --force-run-commands --create'
abbr -a tls 'zellij list-sessions'
abbr -a trm 'zellij delete-session --force'
abbr -a trms 'zellij kill-all-sessions'

########################################
# Systemd
########################################

maybe_abbr isd sc 'isd'

abbr -a scstart 'sudo systemctl start'
abbr -a scustart 'systemctl --user start'

abbr -a scstop 'sudo systemctl stop'
abbr -a scustop 'systemctl --user stop'

abbr -a screstart 'sudo systemctl restart'
abbr -a scurestart 'systemctl --user restart'

abbr -a scenable 'sudo systemctl enable --now'
abbr -a scuenable 'systemctl --user enable --now'

abbr -a scdisable 'sudo systemctl disable --now'
abbr -a scudisable 'systemctl --user disable --now'

abbr -a scfailr 'sudo systemctl reset-failed'
abbr -a scufailr 'systemctl --user reset-failed'

abbr -a sclist 'systemctl list-unit-files'
abbr -a sculist 'systemctl --user list-unit-files'

abbr -a sctimers 'systemctl list-timers --all'
abbr -a scutimers 'systemctl --user list-timers --all'

abbr -a scstatus 'systemctl status'
abbr -a scustatus 'systemctl --user status'

abbr -a scshow 'systemctl show'
abbr -a scushow 'systemctl --user show'

abbr -a scfail 'systemctl --failed'
abbr -a scufail 'systemctl --user --failed'

abbr -a sclogs 'journalctl -u'
abbr --set-cursor -a sculogs 'journalctl --user-unit=%'
abbr -a scfollow 'journalctl --follow -u'
abbr --set-cursor -a scufollow 'journalctl --follow --user-unit=%'

abbr -a scedit 'sudo EDITOR=vim systemctl edit'
abbr -a scuedit 'systemctl --user edit'

abbr -a screload 'sudo systemctl reload'
abbr -a scureload 'systemctl --user reload'

abbr -a screloadall 'sudo systemctl daemon-reload'
abbr -a scureloadall 'systemctl --user daemon-reload'

########################################
# Global-style abbreviations (position=anywhere)
########################################

abbr -a --position anywhere C '| wc -l'
abbr -a --position anywhere --set-cursor G '| grep -i -e "%"'
abbr -a --position anywhere X '| xargs --no-run-if-empty --open-tty -I{}'
abbr -a --position anywhere H -- '--help 2>&1'
abbr -a --position anywhere L "2>&1 | $PAGER"
abbr -a --position anywhere T '2>&1 | tee .my.log'
abbr -a --position anywhere N '>/dev/null 2>&1'
abbr -a --position anywhere B '>/dev/null 2>&1 & disown'
abbr -a --position anywhere V '| begin; set f (mktemp); cat > $f; nvim $f; end'
abbr -a --position anywhere Y '| my-yank-to-clipboard'
abbr -a --position anywhere F '| fzf'
abbr -a --position anywhere J '| jiq'

# Erase `maybe_abbr` function after use
functions -e maybe_abbr
