mock commandline \* "" # mock all other commandline executions to do nothing
mock commandline --current-token "echo \\\$variable"
mock commandline "--current-token --replace" "echo \$argv" # instead of updating commandline with the result, just output it
mock fzf \* "echo selection"

set actual (eval $__fzf_vars_cmd)
@test "doesn't overwrite \$ when replacing current token with selected variable" $actual = "\$selection"
