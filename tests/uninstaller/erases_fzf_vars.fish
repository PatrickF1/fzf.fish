_fzf_uninstall
@test "uninstall removes _fzf_search_vars_command" (set --query _fzf_search_vars_command) $status -ne 0
