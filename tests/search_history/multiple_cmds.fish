set fish_history test
set history_file_path ~/.local/share/fish/test_history
printf "%s" "- cmd: z fzf
  when: 1612201432
- cmd: git log
  when: 1612201440
- cmd: git status
  when: 1612201444
- cmd: function select_me\necho I\\'m just testing\nend
  when: 1612201475
- cmd: git pull
  when: 1612201479
- cmd: cd ~/.local/share/fish/
  when: 1612201487" >$history_file_path
mock commandline "--replace --" "printf %s\n \$argv"
mock commandline \* ""
set --export --append FZF_DEFAULT_OPTS "--filter=git"


set actual (_fzf_search_history)
# for some reason, \n doesn't appear in what is passed to commandline --replace --, and it's in reverse order
set expected "git pull git status git log"
@test "ouputs selected commands without timestamp" "$actual" = "$expected"

rm $history_file_path
