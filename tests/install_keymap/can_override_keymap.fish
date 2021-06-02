fzf_simple_mnemonic_keymap --directory=\cq
bind \cq >/dev/null
@test "can override keymap's preconfigured bindings" $status -eq 0
