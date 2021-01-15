@echo === extract_var_info ===

set --local variable "| a | b | c | d |"
set --local output (__fzf_extract_var_info variable (set --show | psub) | string collect)
@test "vars containing |" "$output" = "set in local scope, unexported, with 1 elements
[1] | a | b | c | d |"