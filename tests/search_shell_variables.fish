@echo === search_shell_variables ===

set --local a_local_variable
set --local --export --append FZF_DEFAULT_OPTS "--filter=a_local_variable"
mock commandline "--current-token --replace" "echo \$argv" # instead of updating commandline with the result, just output it
mock commandline \* "" # mock everything else to do nothing
set --local actual (__fzf_search_shell_variables (set --show | psub) (set --names | psub))

@test "searches local variables" $actual = a_local_variable
