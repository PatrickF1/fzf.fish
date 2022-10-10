set orig_path "tests/_resources/alphabet 26 lines"
set renamed_path "tests/_resources/alphabet lines"
set added_line a-very-unique-line
git mv $orig_path $renamed_path
echo $added_line >>$renamed_path
git add $renamed_path

set output (_fzf_preview_changed_file "R  \"$orig_path\" -> \"$renamed_path\"")

# test that the added line shows up in the diff but not the entire file
# "aaaaaaaaaa" is the first line in the file
string match --entire --quiet $added_line $output &&
    not string match --entire aaaaaaaaaa $output
@test "shows only the modifications made to renamed file" $status -eq 0

git mv $renamed_path $orig_path
git restore --staged --worktree $orig_path
