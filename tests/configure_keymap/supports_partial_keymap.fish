fzf_configure_keymap --directory=\co && test -z (bind | string match --entire __fzf_search_history)
@test "allows not installing key bindings for all entities" $status -eq 0
