set multi_word_dir "tests/_resources/multi word dir"

set fzf_preview_file_cmd rev

set actual (_fzf_preview_file "$multi_word_dir/file 1.txt")
@test "correctly uses custom command to preview files" "$actual" = "1 elif si sihT"
