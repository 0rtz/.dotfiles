# Fish shell configuration

# conf.d/ snippets sourced automatically before this file
# functions/ autoloaded on demand
# Fish configuration files load order: https://fishshell.com/docs/current/language.html#configuration-files

# Do not show any message on startup
set -g fish_greeting ""

# Machine-specific overrides
if test -f $__fish_config_dir/config.fish.local
    source $__fish_config_dir/config.fish.local
end
