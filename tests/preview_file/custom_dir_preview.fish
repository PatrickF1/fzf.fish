set multi_word_dir = "multi word dir"
mktemp multi_word_dir

set fzf_preview_dir_cmd exa
function exa
    @test "passes file path as a single argument to fzf_preview_dir_cmd" (count $argv) -eq 1
    echo $argv
end
set actual (__fzf_preview_file "$multi_word_dir")
@test "correctly uses custom command to preview directories" "$actual" = "multi word path"

rm -rdmulti_word_dir
