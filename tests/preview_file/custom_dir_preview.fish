set multi_word_dir = "tests/_resources/multi word dir"

set fzf_preview_dir_cmd exa
function exa
    @test "passes file path as a single argument to fzf_preview_dir_cmd" (count $argv) -eq 1
    ls $argv
end
set actual (__fzf_preview_file "$multi_word_dir")
@test "correctly uses custom command to preview directories" "$actual" = "file 1.txt file2.txt"
