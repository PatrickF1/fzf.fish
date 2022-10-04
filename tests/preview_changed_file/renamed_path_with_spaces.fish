set orig_path "_resources/multi word dir/file 1.txt"
set renamed_path "_resources/multi word dir/renamed 1.txt"
git mv $orig_path $renamed_path

set output (_fzf_preview_changed_file "R  \"$orig_path\" -> \"$renamed_path\"")

# similarity index is printed by git diff in renames
string match --entire --quiet "similarity index 100%" $output
@test "successfully previews renamed path with spaces" $status -eq 0

git mv $renamed_path $orig_path
