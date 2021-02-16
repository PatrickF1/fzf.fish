set --export fd_captured_opts
function fd
    set fd_captured_opts $argv
end
mock fzf \* ""
mock commandline --current-token "echo ~/"
mock commandline "--current-token --replace" ""
mock commandline \* ""
__fzf_search_current_dir
set expected_arg "--base-directory=$HOME"
@test "~/ is expanded to HOME" -n (string match --entire -- $expected_arg $fd_captured_opts)
