fzf_configure_keymap simple_mnemonic --directory=\cq
@test "can override the bindings of the specified keymap" (bind \cq) = "bind \cq __fzf_search_current_dir"

fzf_configure_keymap simple_mnemonic --directory
@test "can remove bindings from the specified keymap" -z (bind \cf | string match --entire __fzf_search_current_dir)
