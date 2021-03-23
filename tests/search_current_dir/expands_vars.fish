set target "file 1.txt"

set --global --export fzf_dir_opts --filter=""
mock commandline --current-token "echo \$target"
mock commandline "--current-token --replace" "echo \$argv"
mock commandline \* ""

set actual (__fzf_search_current_dir)
@test "expands variables in current token" "$actual" = "file 1.txt"
