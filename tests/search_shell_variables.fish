@echo === search_shell_variables ===

set --local a_local_variable
set --local --export --append FZF_DEFAULT_OPTS "--filter=a_local_variable"
mock commandline \* "echo \$argv"
set --local actual (__fzf_search_shell_variables (set --show | psub) (set --names | psub))

@test "searches local variables" $actual = a_local_variable