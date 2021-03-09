set fzf_preview_dir_cmd ls
set dir (mktemp -d)
touch $dir/{file.txt,.hidden}
set actual (__fzf_preview_file $dir)
@test "correctly uses custom command to preview directories" "$actual" = file.txt
