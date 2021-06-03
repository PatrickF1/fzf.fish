function binding_contains_func --argument-names sequence function_name
    string match --entire $function_name (bind $sequence) >/dev/null
end

fzf_configure_keymap conflictless_mnemonic --directory=\ca --git_log=\cb --git_status=\cc --history=\cd --variables=\ce
@test "can override the keymap's sequence for directory" (binding_contains_func \ca __fzf_search_current_dir) $status -eq 0
@test "can override the keymap's sequence for git log" (binding_contains_func \cb __fzf_search_git_log) $status -eq 0
@test "can override the keymap's sequence for git status" (binding_contains_func \cc __fzf_search_git_status) $status -eq 0
@test "can override the keymap's sequence for history" (binding_contains_func \cd __fzf_search_history) $status -eq 0
@test "can override the keymap's sequence for variables" (binding_contains_func \ce __fzf_search_shell_variables) $status -eq 0

bind --mode insert \ca >/dev/null && bind --mode insert \ce >/dev/null
@test "installs bindings for insert mode" $status -eq 0

_fzf_uninstall_keymap
@test "custom key sequences are properly erased on keymap uninstall" -z (bind --user | string match --entire __fzf_)

# intentionally test both style of passing options with no value
fzf_configure_keymap simple_mnemonic --directory --git_status=
@test "can remove bindings from the specified keymap" -z (bind --user | string match --entire --regex '__fzf_search_current_dir|__fzf_search_git_status')

fzf_configure_keymap blank --unknown=\cq &>/dev/null
@test "fails if passed unknown option" $status -ne 0
