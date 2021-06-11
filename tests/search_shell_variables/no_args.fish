mock fzf \* "" # do nothing if we reach fzf so we don't get stuck
_fzf_search_shell_variables 2>/dev/null
@test "fails if no arguments given" $status -ne 0
