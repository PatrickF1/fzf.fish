mock git diff "echo \$argv"
set output (_fzf_preview_changed_file "UU out.log")

@test "shows merge conflicts as unmerged" $output[2] = "│ Unmerged │"
