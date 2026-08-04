# yazi file manager wrapper with cd-on-quit support

function f --description 'yazi file manager with cd-on-quit'
    # Do nothing if already inside Yazi
    if set -q YAZI_LEVEL; and test "$YAZI_LEVEL" -ge 1
        echo "Already inside yazi"
        return 0
    end

    set -l tmp (mktemp -t "yazi-cwd.XXXXXX")
    command yazi $argv --cwd-file="$tmp"
    set -l cwd (cat "$tmp" 2>/dev/null)
    if test -n "$cwd"; and test "$cwd" != "$PWD"; and test -d "$cwd"
        cd -- "$cwd"
    end
    rm -f -- "$tmp"
end
