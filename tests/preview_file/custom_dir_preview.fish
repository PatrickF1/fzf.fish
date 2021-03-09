set fzf_preview_dir_cmd ls
touch file.txt .hidden
set actual (__fzf_preview_file .)
@test "correctly uses custom command to preview directories" "$actual" = file.txt
