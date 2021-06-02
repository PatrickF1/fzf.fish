fzf_install_keymap --directory=\co positional_argument 2>/dev/null
@test "fails if provided positional argument" $status -ne 0
