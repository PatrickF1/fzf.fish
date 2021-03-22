mock commandline --current-token "echo tests/_resources/multi\\ word\\ dir/"
mock commandline "--current-token --replace" ""
mock commandline \* ""
set --export --append FZF_DEFAULT_OPTS "--filter=''" # automatically select all
set actual (__fzf_search_current_dir)

@test "uses current token as base directory if it ends in / and is a directory" (count $actual) -eq 2
