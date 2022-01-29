# test pid extraction from fzf multi-line output
mock commandline \* ""
mock commandline "--current-token --replace --" "echo \$argv"
set --export --append FZF_DEFAULT_OPTS "--filter=''" # automatically select all input lines sent to fzf

set pids (_fzf_search_processes)
# test that only valid numbers are outputted (i.e. nothing else polluting the output of pids)
# this string regex will return 0 if a single non-digit character exists in the output
string match --regex --quiet '\D' $pids
@test "outputs only pids" $status -eq 1
