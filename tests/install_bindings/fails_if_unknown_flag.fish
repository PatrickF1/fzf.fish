fzf_install_bindings --typo-flag=\cq
@test "fails if passed unknown flag" $status -ne 0
