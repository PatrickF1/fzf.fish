_fzf_uninstall

@test "erases all fzf key bindings" -z (bind | grep "fzf")
