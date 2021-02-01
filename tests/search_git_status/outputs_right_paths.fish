set files "filename_with_*.txt" "filename with space.csv"
touch $files
mock commandline \* ""
mock commandline "--current-token --replace --" "echo \$argv"
set --export --append FZF_DEFAULT_OPTS "--filter='filename'"
set actual (__fzf_search_git_status)
@test "outputs correct paths" (string unescape $actual) = "$files"

rm $files
