mock commandline \* "" # mock all other commandline executions to do nothing
mock commandline --current-token "echo \\\$variable" # simulate current token starting with $
mock commandline "--current-token --replace" "echo \$argv" # instead of updating commandline with the result, just output it
mock fzf \* "echo a\nb\nc"

set actual (eval $_fzf_search_vars_command)
@test "doesn't overwrite \$ when replacing current token with selected variable" "$actual" = "\$a \$b \$c"
