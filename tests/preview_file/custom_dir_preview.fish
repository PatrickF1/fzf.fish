set fzf_preview_dir_cmd exa
mock exa . "echo file.txt"
set actual (__fzf_preview_file .)
@test "correctly uses custom command to preview directories" $actual = file.txt
