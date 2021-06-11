function binding_contains_func --argument-names sequence function_
    string match --entire $function_ (bind $sequence) >/dev/null
end

@test "default binding for directory works" (binding_contains_func \cf __fzf_search_current_dir) $status -eq 0
@test "default binding for git log works" (binding_contains_func \e\cl __fzf_search_git_log) $status -eq 0
@test "default binding for git status works" (binding_contains_func \e\cs __fzf_search_git_status) $status -eq 0
@test "default binding for history works" (binding_contains_func \cr __fzf_search_history) $status -eq 0
@test "default binding for variables works" (binding_contains_func \cv $_fzf_search_vars_command) $status -eq 0

fzf_configure_bindings --directory=\ca --git_log=\cb --git_status=\cc --history=\cd --variables=\ce
@test "can override the default bindings for directory" (binding_contains_func \ca __fzf_search_current_dir) $status -eq 0
@test "can override the default bindings for git log" (binding_contains_func \cb __fzf_search_git_log) $status -eq 0
@test "can override the default bindings for git status" (binding_contains_func \cc __fzf_search_git_status) $status -eq 0
@test "can override the default bindings for history" (binding_contains_func \cd __fzf_search_history) $status -eq 0
@test "can override the default bindings for variables" (binding_contains_func \ce $_fzf_search_vars_command) $status -eq 0

bind --mode insert \ca >/dev/null && bind --mode insert \ce >/dev/null
@test "installs bindings for insert mode" $status -eq 0

_fzf_uninstall_bindings
@test "custom key sequences are properly erased on uninstalling bindings" -z (bind --user | string match --entire __fzf_)

# intentionally test both style of passing options with no value
fzf_configure_bindings --directory --git_status=
@test "can erase bindings by passing no key sequence" -z (bind --user | string match --entire --regex '__fzf_search_current_dir|__fzf_search_git_status')
binding_contains_func \e\cl __fzf_search_git_log && binding_contains_func \cr __fzf_search_history && binding_contains_func \cv $_fzf_search_vars_command
@test "installs default bindings that aren't customized" $status -eq 0

fzf_configure_bindings --unknown=\cq &>/dev/null
@test "fails if passed unknown option" $status -ne 0

fzf_configure_bindings arg --directory &>/dev/null
@test "fails if passed a positional arg" $status -ne 0
