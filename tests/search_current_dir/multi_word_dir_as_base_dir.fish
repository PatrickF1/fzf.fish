set --export fd_captured_opts
function fd
    set fd_captured_opts $argv
end
mkdir "multi word dir"
mock fzf \* ""
mock commandline --current-token "echo multi\\ word\\ dir/"
mock commandline "--current-token --replace" ""
mock commandline \* ""
__fzf_search_current_dir

test -n "$fd_captured_opts" && test -n (string match --entire -- "--base-directory=multi word dir" $fd_captured_opts)
@test "changes fd's base directory if current token has a slash and is a directory" $status -eq 0

rm -rd "multi word dir"
