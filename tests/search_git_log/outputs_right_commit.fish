# This test has two versions:  one for CI and one for local
mock commandline "--current-token --replace" "echo \$argv"
mock commandline \* ""
if git cat-file -e c6326dbda6b1f48ecbd015838073213be3bf6ec1 2>/dev/null # sha is a random commit that CI wouldn't pull
    # This test is running locally.
    set --export --append FZF_DEFAULT_OPTS "--filter='Refactor: one folder per test suite, one file per test case'"
    set actual (_fzf_search_git_log)
    set expected 6c558feee95c34ce82ded8e08d98f5f73d0f9b97
    @test "outputs right commit (local)" "$actual" = "$expected"
else
    # This test is running on CI. Since we don't want to have CI download the entire git log just
    # for a few tests, we will just test if it is able to output the sha of the only commit available
    # by forcing fzf to select only commit available and checking if the ouputted sha exists
    set --export --append FZF_DEFAULT_OPTS --select-1
    git cat-file -e (_fzf_search_git_log) 2>/dev/null
    @test "outputs a valid git sha (CI)" $status -eq 0
end
