set multi_word_dir "tests/_resources/multi word dir"

set fzf_preview_dir_cmd ls

set actual (__fzf_preview_file "$multi_word_dir")
@test "correctly uses custom command to preview directories" "$actual" = "file 1.txt file 2.txt"
