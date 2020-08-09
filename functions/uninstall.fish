#!/usr/bin/env fish
if not set --query fzf_fish_custom_keybindings
    bind --erase \cf
    bind --erase \cl
    bind --erase \cr
    bind --erase \cv

    set_color --italics cyan
    echo "fzf_fish_integration key kindings removed"
    set_color normal
end

# Not going to erase FZF_DEFAULT_OPTS because too hard to tell if it set by the user or by this plugin
