set --local a_local_variable
set --export --append FZF_DEFAULT_OPTS "--filter=a_local_variable"
mock commandline "--current-token --replace" "echo \$argv" # instead of updating commandline with the result, just output it
mock commandline \* "" # mock all other commandline executions to do nothing
set actual (eval $__fzf_vars_cmd)
@test "can find a local variable" $actual = a_local_variable
