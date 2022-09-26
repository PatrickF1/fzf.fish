mock git diff "echo \$argv"
set output (_fzf_preview_changed_file " D out.log")

contains -- "| Unstaged |" $output && not contains "| Staged |" $output
@test "only shows unstaged changes if file was only deleted in working tree" $status -eq 0
