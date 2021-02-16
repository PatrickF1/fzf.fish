set --export fd_captured_args
function fd
    set fd_captured_args $argv
end
mock fzf \* ""
mock commandline --current-token "echo functions"
mock commandline "--current-token --replace" ""
mock commandline \* ""
__fzf_search_current_dir

if test -d functions
    test -n "$fd_captured_args" && test -z (string match --entire -- "--base-directory" $fd_captured_args)
    @test "doesn't change fd's base directory if no slash on current token" $status -eq 0
else
    @test "functions/ doesn't exists for testing purposes"
end
