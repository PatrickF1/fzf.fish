#!/usr/bin/env fish
# --erase does not error if keybinding is not set, so don't have to account for fzf_fish_custom_keybindings
bind --erase \cf
bind --erase \cl
bind --erase \cr
bind --erase \cv
echo "fzf_fish_integration key kindings removed"

# Not going to erase FZF_DEFAULT_OPTS because too hard to tell if it set by the user or by this plugin
