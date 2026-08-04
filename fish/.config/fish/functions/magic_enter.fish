# Magic enter: run context-aware command when pressing Enter on empty line

function magic_enter --description 'Context-aware default command on empty line'
    set -l cmd (commandline --current-buffer)

    if test -n "$cmd"
        commandline -f execute
        return
    end

    if git rev-parse --is-inside-work-tree &>/dev/null
        commandline -r 'git status'
    else
        commandline -r 'eza -aglbh --git --icons -F --color always --sort old --smart-group'
    end

    commandline -f execute
end
