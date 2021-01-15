@echo === extract_var_info ===

set --local variable "| a | b | c | d |"
set --local actual (__fzf_extract_var_info variable (set --show | psub) | string collect)
set --local expected "set in local scope, unexported, with 1 elements
[1] | a | b | c | d |"
@test "vars containing '|'" $actual = $expected
