# https://github.com/jorgebucaran/fisher/issues/640
set -gx fisher_path $XDG_CONFIG_HOME/fish/fisher

# Inject $fisher_path/functions
set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..-1]
# Inject $fisher_path/completions
set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..-1]

for file in $fisher_path/conf.d/*.fish
    source $file
end

# IlanCosman/tide
set --global tide_character_icon '󰞔'
set --global tide_character_vi_icon_default '│'
set --global tide_character_vi_icon_visual 'V'
