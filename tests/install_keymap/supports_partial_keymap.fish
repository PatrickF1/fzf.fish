fzf_install_keymap --directory=\co && test -z (bind | grep __fzf_search_history)
@test "allows not installing key bindings for all entities" $status -eq 0
