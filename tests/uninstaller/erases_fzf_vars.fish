_fzf_uninstall
@test "uninstall removes all vars including fzf in name" -z (set --names | grep "fzf" | grep -v "fisher")
