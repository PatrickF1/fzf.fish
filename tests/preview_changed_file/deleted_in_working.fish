mock git diff "echo \$argv"
set file dir/file.txt

set output (_fzf_preview_changed_file " D $file")
contains -- "--color=always -- $file" $output && not string match -- "*--staged*" $output
@test "only shows unstaged changes if file was only deleted in working tree" $status -eq 0
