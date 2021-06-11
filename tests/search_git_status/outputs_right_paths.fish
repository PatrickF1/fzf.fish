set files "filename_with_*.txt" "filename with space.csv"
touch $files
mock commandline \* ""
mock commandline "--current-token --replace --" "echo \$argv"
set --export --append FZF_DEFAULT_OPTS "--filter='filename'"
set actual (_fzf_search_git_status)
string match $files[1] --entire -q $actual && string match --entire -q $files[2] $actual
@test "correct paths found in output" $status -eq 0

rm $files
