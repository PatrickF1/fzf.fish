function _fzf_search_directory --description "Search the current directory. Replace the current token with the selected file paths."
    # --string-cwd-prefix prevents fd >= 8.3.0 from prepending ./ to relative paths
    set fd_opts --color=always --strip-cwd-prefix $fzf_fd_opts

    set fzf_arguments --multi --ansi $fzf_dir_opts
    set token (commandline --current-token)
    # expand any variables or leading tilde (~) in the token
    set expanded_token (eval echo -- $token)
    # unescape token because it's already quoted so backslashes will mess up the path
    set unescaped_exp_token (string unescape -- $expanded_token)

    # If the current token is a directory and has a trailing slash,
    # then use it as fd's base directory.
    if string match --quiet -- "*/" $unescaped_exp_token && test -d "$unescaped_exp_token"
        set --append fd_opts --base-directory=$unescaped_exp_token
        # use the directory name as fzf's prompt to indicate the search is limited to that directory
        set --prepend fzf_arguments --prompt="$unescaped_exp_token" --preview="_fzf_preview_file $expanded_token{}"
        set file_paths_selected $unescaped_exp_token(fd $fd_opts 2>/dev/null | _fzf_wrapper $fzf_arguments)
    else
        set --prepend fzf_arguments --query="$unescaped_exp_token" --preview='_fzf_preview_file {}'
        set file_paths_selected (fd $fd_opts 2>/dev/null | _fzf_wrapper $fzf_arguments)
    end


    if test $status -eq 0
        # Fish will cd implicitly if a directory name ending in a slash is provided.
        # To help the user leverage this feature, we automatically append / to the selected path if
        # - only one path was selected,
        # - the user was in the middle of inputting the first token,
        # - the path is a directory
        # Then, the user only needs to hit Enter once more to cd into that directory.
        if test (count $file_paths_selected) = 1
            set commandline_tokens (commandline --tokenize)
            if test "$commandline_tokens" = "$token" -a -d "$file_paths_selected"
                set file_paths_selected $file_paths_selected/
            end
        end

        commandline --current-token --replace -- (string escape -- $file_paths_selected | string join ' ')
    end

    commandline --function repaint
end
