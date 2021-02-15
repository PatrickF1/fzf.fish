set --export fd_args
function fd
    set fd_opts $argv
end
mock fzf \* ""
mock commandline --current-token "echo functions"
mock commandline "--current-token --replace" ""
mock commandline \* ""
__fzf_search_current_dir
if test -d functions
    @test "doesn't change fd's base directory if no slash on current token" -z (string match --entire -- "--base-directory" $fd_opts)
else
    @test "functions/ exists for testing purposes"
end
