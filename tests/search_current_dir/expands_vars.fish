set target "file 1.txt"

set --global fzf_dir_opts --select-1
mock commandline --current-token "echo \$target"
mock commandline "--current-token --replace --" "echo \$argv"
mock commandline \* ""

set actual (__fzf_search_current_dir)
@test "expands variables in current token" (basename "$actual") = "file 1.txt"
