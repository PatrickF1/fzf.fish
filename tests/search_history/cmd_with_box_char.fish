set fish_history test
set history_file_path ~/.local/share/fish/test_history
printf "%s" "- cmd: echo 'lots of │ chars
  when: 1612201487" >$history_file_path

mock commandline "--replace --" "echo \$argv"
mock commandline \* ""
set --export --append FZF_DEFAULT_OPTS --select-1

set actual (_fzf_search_history)
set expected "echo 'lots of │ chars"
@test "doesn't erase commands containing box drawing char delineator" "$actual" = "$expected"

rm $history_file_path
