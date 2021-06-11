_fzf_configure_bindings_help -h >/dev/null && _fzf_configure_bindings_help --help >/dev/null
@test "fzf_configure_bindings help option works" $status -eq 0
