mock git diff "echo \$argv"
set file dir/file.txt
set output (_fzf_preview_changed_file "MM $file")

contains -- "| Unstaged |" $output && contains "| Staged |" $output
@test "shows staged and unstaged changes if the file is modified in both places" $status -eq 0
