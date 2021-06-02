fzf_simple_mnemonic_keymap --directory=\cq
@test "can override keymap's preconfigured bindings" (bind \cq) = "bind \cq __fzf_search_current_dir"
