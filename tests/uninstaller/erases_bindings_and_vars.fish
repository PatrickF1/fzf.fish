_fzf_uninstall >/dev/null
@test "erases all fzf key bindings" -z (bind --user | string match --entire "_fzf_search__")
@test "erases _fzf_search_vars_command" (set --query _fzf_search_vars_command) $status -ne 0
