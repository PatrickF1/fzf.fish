fzf_configure_keymap simple_mnemonic --directory=\cq
@test "can override the bindings of the specified keymap" (bind \cq) = "bind \cq __fzf_search_current_dir"

# intentionally test both style of passing options with no value
fzf_configure_keymap simple_mnemonic --directory --git_status=
@test "can remove bindings from the specified keymap" -z (bind --user | string match --entire --regex '__fzf_search_current_dir|__fzf_search_git_status')
