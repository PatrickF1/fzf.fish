# by adding a binding for insert mode, insert mode is automatically created
bind --mode insert q ""
fzf_simple_mnemonic_bindings

# now for __fzf_search_history, there should be one binding for default mode and one for insert mode
@test "installs insert mode bindings if insert mode" (bind | grep __fzf_search_history | wc -l) -eq 2
