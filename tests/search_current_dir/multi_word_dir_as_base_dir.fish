set --export fd_captured_opts
function fd
    set fd_captured_opts $argv
end
mock fzf \* ""
mock commandline --current-token "echo tests/_resources/multi\\ word\\ dir/"
mock commandline "--current-token --replace" ""
mock commandline \* ""
__fzf_search_current_dir

contains -- "--base-directory=tests/_resources/multi word dir/" $fd_captured_opts
@test "uses current token as base directory if it ends in / and is a directory" $status -eq 0
