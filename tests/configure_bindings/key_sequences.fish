function binding_contains_func --argument-names sequence function_
    string match --entire $function_ (bind $sequence) >/dev/null
end

@test "default binding for directory works" (binding_contains_func ctrl-alt-f _fzf_search_directory) $status -eq 0
@test "default binding for git log works" (binding_contains_func ctrl-alt-l _fzf_search_git_log) $status -eq 0
@test "default binding for git status works" (binding_contains_func ctrl-alt-s _fzf_search_git_status) $status -eq 0
@test "default binding for history works" (binding_contains_func ctrl-r _fzf_search_history) $status -eq 0
@test "default binding for variables works" (binding_contains_func ctrl-v $_fzf_search_vars_command) $status -eq 0

fzf_configure_bindings --directory=ctrl-a --git_log=ctrl-b --git_status=ctrl-c --history=ctrl-d --variables=ctrl-e
@test "can override the default binding for directory" (binding_contains_func ctrl-a _fzf_search_directory) $status -eq 0
@test "can override the default binding for git log" (binding_contains_func ctrl-b _fzf_search_git_log) $status -eq 0
@test "can override the default binding for git status" (binding_contains_func ctrl-c _fzf_search_git_status) $status -eq 0
@test "can override the default binding for history" (binding_contains_func ctrl-d _fzf_search_history) $status -eq 0
@test "can override the default binding for variables" (binding_contains_func ctrl-e $_fzf_search_vars_command) $status -eq 0

bind --mode insert ctrl-a >/dev/null && bind --mode insert ctrl-e >/dev/null
@test "installs bindings for insert mode" $status -eq 0

_fzf_uninstall_bindings
@test "custom key sequences are properly erased on uninstalling bindings" -z (bind --user | string match --entire _fzf_)

# intentionally test both style of passing options with no value
fzf_configure_bindings --directory --git_status=
@test "can erase bindings by passing no key sequence" -z (bind --user | string match --entire --regex '_fzf_search_directory|_fzf_search_git_status')
binding_contains_func ctrl-alt-l _fzf_search_git_log && binding_contains_func ctrl-r _fzf_search_history && binding_contains_func ctrl-v $_fzf_search_vars_command
@test "installs default bindings that aren't customized" $status -eq 0

fzf_configure_bindings --unknown=ctrl-q &>/dev/null
@test "fails if passed unknown option" $status -ne 0

fzf_configure_bindings arg --directory &>/dev/null
@test "fails if passed a positional arg" $status -ne 0
