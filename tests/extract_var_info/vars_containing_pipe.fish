set variable "| a | b | c | d |"
set actual (__fzf_extract_var_info variable (set --show | psub) | string collect)
set expected "set in global scope, unexported, with 1 elements"\n"[1] | a | b | c | d |"
@test "vars containing '|'" "$actual" = "$expected"
