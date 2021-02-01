# force history to read from a file with pre-populated history
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
- cmd: history
  when: 1612201479
- cmd: cd ~/.local/share/fish/
  when: 1612201487" >$history_file_path

mock commandline "--replace --" "echo \$argv"
mock commandline \* ""
set --export --append FZF_DEFAULT_OPTS "--filter=function"
# for some reason, \n doesn't appear in what is passed to commandline --replace --
set expected "function select_me echo I\'m just testing end"
set actual (__fzf_search_history)
@test "ouputs right command" $actual = $expected

rm $history_file_path
