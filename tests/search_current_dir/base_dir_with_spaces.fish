mock commandline --current-token "echo tests/_resources/multi word dir/"
mock commandline "--current-token --replace --" "echo \$argv"
mock commandline \* ""
set --export --append FZF_DEFAULT_OPTS "--filter=''" # automatically select all input lines sent to fzf

set actual (_fzf_search_directory)
set expected "'tests/_resources/multi word dir/file 1.txt' 'tests/_resources/multi word dir/file 2.txt'"
@test "uses current token as base directory if it ends in / and is a directory" "$actual" = $expected
