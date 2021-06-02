fzf_install_keymap --unknown=\cq 2>/dev/null
@test "fails if passed unknown option" $status -ne 0
