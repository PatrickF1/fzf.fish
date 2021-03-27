set variable "| a | b | c | d |" "1 | 2 | 3"
set actual (__fzf_extract_var_info variable (set --show | psub) | string collect)
set expected "set in global scope, unexported, with 2 elements"\n"[1] $variable[1]"\n"[2] $variable[2]"
@test "vars containing '|'" "$actual" = "$expected"
