# $PATH
fish_add_path $HOME/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/go/bin
fish_add_path $HOME/npm/bin

# Custom scripts directories
fish_add_path $HOME/usr/bin/local
if test -d $HOME/usr/bin/my-scripts
    for dir in $HOME/usr/bin/my-scripts/**/
        fish_add_path $dir
    end
end

# Ruby gems
if test -d $HOME/.local/share/gem/ruby
    for dir in $HOME/.local/share/gem/ruby/*/bin
        fish_add_path $dir
    end
end

# Luarocks
if test -d $HOME/.luarocks/bin
    fish_add_path $HOME/.luarocks/bin
end

if test -d /home/linuxbrew/.linuxbrew
    set --global --export HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew";
    set --global --export HOMEBREW_CELLAR "/home/linuxbrew/.linuxbrew/Cellar";
    set --global --export HOMEBREW_REPOSITORY "/home/linuxbrew/.linuxbrew/Homebrew";
    fish_add_path --global --move --path "/home/linuxbrew/.linuxbrew/bin" "/home/linuxbrew/.linuxbrew/sbin";
    if test -n "$MANPATH[1]"; set --global --export MANPATH '' $MANPATH; end;
    if not contains "/home/linuxbrew/.linuxbrew/share/info" $INFOPATH; set --global --export INFOPATH "/home/linuxbrew/.linuxbrew/share/info" $INFOPATH; end;
end
