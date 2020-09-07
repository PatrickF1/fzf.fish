#!/usr/bin/env fish
if not set --query fzf_fish_custom_keybindings
    bind --erase --all \cf
    bind --erase --all \cr
    bind --erase --all \cv
    bind --erase --all \e\cl
    bind --erase --all \e\cs

    set_color --italics cyan
    echo "fzf.fish key bindings removed"
    set_color normal
end

# Not going to erase FZF_DEFAULT_OPTS because too hard to tell if it was set by the user or by this plugin
