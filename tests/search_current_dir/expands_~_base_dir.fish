set --export fd_args
function fd
    set fd_args $argv
end
mock fzf \* ""
mock commandline --current-token "echo ~/"
mock commandline "--current-token --replace" ""
mock commandline \* ""
__fzf_search_current_dir
set expected_arg "--base-directory=$HOME"
@test "~/ is expanded to HOME" -n (string match --entire -- $expected_arg $fd_args)
