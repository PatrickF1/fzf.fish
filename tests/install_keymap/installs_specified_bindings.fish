function binding_contains_func --argument-names sequence function_name
    string match --entire $function_name (bind $sequence) >/dev/null
end

fzf_install_keymap --directory=\ca --git_log=\cb --git_status=\cc --history=\cd --variables=\ce

@test "installs the specified binding for directory" (binding_contains_func \ca __fzf_search_current_dir) $status -eq 0
@test "installs the specified binding for git log" (binding_contains_func \cb __fzf_search_git_log) $status -eq 0
@test "installs the specified binding for git status" (binding_contains_func \cc __fzf_search_git_status) $status -eq 0
@test "installs the specified binding for history" (binding_contains_func \cd __fzf_search_history) $status -eq 0
@test "installs the specified binding for variables" (binding_contains_func \ce __fzf_search_shell_variables) $status -eq 0
