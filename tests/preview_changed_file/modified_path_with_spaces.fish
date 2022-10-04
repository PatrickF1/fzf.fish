set path_with_space "tests/_resources/multi word dir/file 1.txt"
set expected_diff a-very-unique-line
echo $expected_diff >>$path_with_space
set output (_fzf_preview_changed_file " M \"$path_with_space\"")

string match --entire --quiet $expected_diff $output
@test "successfully previews modified path with spaces" $status -eq 0

git restore $path_with_space
