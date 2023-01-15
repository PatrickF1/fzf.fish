set --export --append FZF_DEFAULT_OPTS "--filter=''" # automatically select all input lines sent to fzf
set temp_dir temp_test_99

# escape tilde so it doesn't get expanded when echoed
mock commandline --current-token "echo \~/$temp_dir/"
mock commandline "--current-token --replace --" "string split ' ' \$argv"
mock commandline \* ""

mkdir ~/$temp_dir
touch ~/$temp_dir/{1, 2, 3, 4, 5, 6, 7}
set result (_fzf_search_directory)
@test "~ is expanded to HOME" (count $result) = 7
rm -rf ~/$temp_dir
