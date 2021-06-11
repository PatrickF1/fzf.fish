set --export searched_hidden false
function fzf
    while read line
        # use --entire because $line contains ANSI escape codes added by fd
        if string match --entire -- ".github" "$line"
            set searched_hidden true
            break
        end
    end
end

mock commandline "*" ""
set fzf_fd_opts --hidden --exclude=.git

_fzf_search_current_dir
@test "uses fzf_fd_opts when executing fd" "$searched_hidden" = true
