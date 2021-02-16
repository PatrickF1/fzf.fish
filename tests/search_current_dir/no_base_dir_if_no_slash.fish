set --export fd_captured_args "overwrite me"
function fd
    set fd_captured_args $argv
end
mock fzf \* ""
mock commandline --current-token "echo functions"
mock commandline "--current-token --replace" ""
mock commandline \* ""
__fzf_search_current_dir
if test -d functions
    @test "doesn't change fd's base directory if no slash on current token" -z (string match --entire -- "--base-directory" $fd_captured_args)
else
    @test "functions/ doesn't exists for testing purposes"
end
