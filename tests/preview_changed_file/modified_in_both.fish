mock git diff "echo \$argv"
set output (_fzf_preview_changed_file "MM dir/file.txt")

contains -- "| Unstaged |" $output && contains -- "| Staged |" $output
@test "shows staged and unstaged changes if the file is modified in both places" $status -eq 0
