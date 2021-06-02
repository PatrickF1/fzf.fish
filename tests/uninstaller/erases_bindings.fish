_fzf_uninstall
@test "erases all fzf key bindings" -z (bind | string match --entire "__fzf_search")
