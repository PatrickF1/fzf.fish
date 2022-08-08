mock git diff "echo \$argv"
set file dir/file.txt

set output (_fzf_preview_changed_file " D $file")

contains -- "| Unstaged |" $output && not contains "| Staged |" $output
@test "only shows unstaged changes if file was only deleted in working tree" $status -eq 0
