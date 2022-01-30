# test pid extraction from fzf multi-line output
mock commandline \* ""
mock commandline "--current-token --replace --" "echo \$argv"
set --export --append FZF_DEFAULT_OPTS "--filter=''" # automatically select all input lines sent to fzf

# string split output so that each pid is an array rather than a long string
set pids (_fzf_search_processes | string split)

# test that only valid numbers are outputted (i.e. nothing else polluting the output of pids)
# this string match command will return 0 if a single non-digit character exists in the output, otherwise 1
string match --regex --quiet '\D' (string split $pids)
@test "outputs only pids" $status -eq 1
