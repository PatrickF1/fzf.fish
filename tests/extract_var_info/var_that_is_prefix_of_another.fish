# example of when this actually happens: TERM_PROGRAM and TERM_PROGRAM_VERSION
set prefix 1
set prefixed 2
set actual (_fzf_extract_var_info prefix (set --show | psub) | string collect)
set expected "set in global scope, unexported, with 1 elements"\n"[1] 1"
@test "var whose name is the prefix of another var" "$actual" = "$expected"
