@echo === search_shell_variables ===

set --local a_local_variable
set --local --export --append FZF_DEFAULT_OPTS "--filter=a_local_variable"
mock commandline "--current-token --replace" "echo \$argv" # instead of updating commandline with the result, just output it
mock commandline \* "" # mock all other commandline executions to do nothing
set --local actual (eval $__fzf_search_vars_cmd)
@test "searches local variables" $actual = a_local_variable
set --erase a_local_variable
set --erase --local FZF_DEFAULT_OPTS

mock fzf \* "" # do nothing if we reach fzf so we don't get stuck
__fzf_search_shell_variables 2>/dev/null
@test "fails if no arguments given" $status -ne 0

mock commandline --current-token "echo \\\$variable"
mock fzf \* "echo selection"
set actual (eval $__fzf_search_vars_cmd)
@test "doesn't overwrite \$ when replacing current token with selected variable" $actual = "\$selection"
