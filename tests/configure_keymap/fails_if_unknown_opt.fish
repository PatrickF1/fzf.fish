fzf_configure_keymap blank --unknown=\cq &>/dev/null
@test "fails if passed unknown option" $status -ne 0
