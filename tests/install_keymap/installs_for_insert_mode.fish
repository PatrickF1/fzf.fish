# by adding a binding for insert mode, insert mode is automatically created
bind --mode insert q ""
fzf_simple_mnemonic_keymap

# now for __fzf_search_history, there should be one binding for default mode and one for insert mode
bind --mode insert \cr >/dev/null
@test "installs insert mode bindings if insert mode" $status -eq 0
