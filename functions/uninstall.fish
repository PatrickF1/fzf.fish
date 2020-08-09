#!/usr/bin/env fish
if not set --query fzf_fish_custom_keybindings
    bind --erase --all \cf
    bind --erase --all \cl
    bind --erase --all \cr
    bind --erase --all \cv

    set_color --italics cyan
    echo "fzf_fish_integration key kindings removed"
    set_color normal
end

# Not going to erase FZF_DEFAULT_OPTS because too hard to tell if it set by the user or by this plugin
