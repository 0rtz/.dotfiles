# Browse and insert abbreviations/aliases via fzf

function list_aliases --description 'Pick an abbreviation or alias with fzf'
    command -q fzf; or return 1

    # Collect abbreviations and aliases
    set -l items

    # Abbreviations
    for a in (abbr --show)
        # abbr --show outputs: abbr -a -- name 'expansion'
        set -l parts (string match -r -- '-- (\S+)\s+(.*)' "$a")
        if test (count $parts) -ge 3
            set -a items "$parts[2] : $parts[3]"
        end
    end

    # Functions defined as aliases
    for a in (alias)
        set -a items "$a"
    end

    set -l sel (printf '%s\n' $items | fzf --query=(commandline --current-buffer) | string replace -r ' :.*' '')
    if test -n "$sel"
        commandline -r "$sel"
    end

    commandline -f repaint
end
