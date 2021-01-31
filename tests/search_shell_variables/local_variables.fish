set --local a_local_variable
set --local --export --append FZF_DEFAULT_OPTS "--filter=a_local_variable"
mock commandline "--current-token --replace" "echo \$argv" # instead of updating commandline with the result, just output it
mock commandline \* "" # mock all other commandline executions to do nothing
# grab the command used to execute search shell directly from the bindings
set --local search_vars_cmd (bind --user \cv | cut -d" " -f 3- | string unescape)
set --local actual (eval $search_vars_cmd)
@test "searches local variables" $actual = a_local_variable
