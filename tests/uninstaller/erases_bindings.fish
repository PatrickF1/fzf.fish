_fzf_uninstall
@test "erases all fzf key bindings" -z (bind --user | string match --entire "__fzf_search__")
