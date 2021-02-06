mock commandline \* ""
mock commandline "--current-token --replace --" "echo \$argv"
mock fd \* ""
mock fzf \* "echo /Users/patrickf"
set result (__fzf_search_current_dir)
@test "doesn't prepend ./ if path already starts with /" $result = "/Users/patrickf"
