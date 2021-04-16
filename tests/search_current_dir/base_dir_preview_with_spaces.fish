mock commandline --current-token "echo tests/_resources/multi word dir/"
mock commandline "--current-token --replace --" "echo \$argv"
mock commandline \* ""
set --export --append FZF_DEFAULT_OPTS "--query='file 1'" # automatically select all input lines sent to fzf

set --export bat_succeeded false
function bat
    cat $argv
    if $status -eq 0
        set bat_succeeded true
    end
end
# TODO ask if there's a way for timeout to run a fish autoloaded function
set actual (SHELL=fish timeout 2s __fzf_search_current_dir)

@test "preview works when base directory contains a space" $bat_succeeded = true
