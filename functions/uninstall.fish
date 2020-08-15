#!/usr/bin/env fish
if not set --query fzf_fish_custom_keybindings
    bind --erase --all \cf
    bind --erase --all \cr
    bind --erase --all \cv
    bind --erase --all \c\el

    set_color --italics cyan
    echo "fzf.fish key kindings removed"
    set_color normal
end

# Not going to erase FZF_DEFAULT_OPTS because too hard to tell if it set by the user or by this plugin
