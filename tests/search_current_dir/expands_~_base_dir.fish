# mock everything so that the only thing that gets sent to stdout are the args passed into fd
mock fd \* "echo \$argv"
mock fzf \* ""
mock commandline --current-token "echo ~/"
mock commandline \* ""
set fd_args (__fzf_search_current_dir)
@test "~/ not in fd args" -z (string match "~/" $fd_args)
@test "~/ is expanded to $HOME" -n (string match --entire "$HOME" $fd_args)
