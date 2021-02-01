mock commandline "--current-token --replace" "echo \$argv"
mock commandline \* ""
set --export --append FZF_DEFAULT_OPTS "--filter='Refactor: one folder per test suite, one file per test case'"
set expected "6c558feee95c34ce82ded8e08d98f5f73d0f9b97"
set actual (__fzf_search_git_log)
@test "Outputs right commit" $actual = $expected
