fzf_simple_mnemonic_bindings --dir=\cq
@test "can override keymap bindings" (bind | grep "\\\cq") = "bind \cq __fzf_search_current_dir"
