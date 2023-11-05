set target "file 1.txt"

set --global fzf_directory_opts --select-1
mock commandline --current-token "echo \$target"
mock commandline "--current-token --replace --" "echo \$argv"
mock commandline \* ""
# string unescape because the args passed into commandline --current-token --replace are escaped
set actual (string unescape (_fzf_search_directory))

@test "expands variables in current token" (basename $actual) = $target
