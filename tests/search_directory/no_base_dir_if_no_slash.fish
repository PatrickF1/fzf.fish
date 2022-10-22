# though the conf.d directory exists, it should not be used as a base directory
# because there is no / at the end of the token
mock commandline --current-token "echo conf.d"
mock commandline "--current-token --replace" ""
mock commandline \* ""

set --export searched_functions_dir false
function fzf
    while read line
        # use --entire because $line contains ANSI escape codes added by fd
        if string match --entire -- functions/ "$line"
            set searched_functions_dir true
        end
    end
end

_fzf_search_directory

@test "doesn't change fd's base directory if no slash on current token" $searched_functions_dir = true
