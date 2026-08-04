# Toggle sudo prefix on the current command line

function toggle_sudo
    set -l buf (commandline)

    if string match -qr '^sudo\b' -- $buf
        commandline (string replace -r '^sudo\s+' '' -- $buf)
    else
        commandline "sudo $buf"
    end
end
