set files "filename with space" "filename with \"\""
touch $files
git add --all
mock commandline \* ""
mock commandline "--current-token --replace --" "echo \$argv"
__fzf_search_git_status
set --export --append FZF_DEFAULT_OPTS "--filter="
set actual (__fzf_search_git_status)

@test "outputs correct paths" $actual = $files

git reset --hard
