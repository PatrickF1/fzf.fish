mock commandline --current-token "echo /Users/"
mock commandline "--current-token --replace --" "echo \$argv"
mock commandline \* ""
mock fd \* "echo patrickf/"
set --export --append FZF_DEFAULT_OPTS "--select-1"
set result (__fzf_search_current_dir)
@test "doesn't prepend ./ if path already starts with /" $result = "/Users/patrickf/"
