# mock everything so that the only thing that gets sent to stdout are the args passed into fd
mock fd \* "echo \$argv"
mock fzf \* ""
mock commandline --current-token "echo ~/"
mock commandline \* ""
set fd_args (__fzf_search_current_dir)
@test "~/ is expanded to $HOME" -z (string match --invert "~" $fd_args)