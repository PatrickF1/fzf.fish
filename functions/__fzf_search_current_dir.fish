function __fzf_search_current_dir --description "Search the current directory. Replace the current token with the selected file paths."
    # Make sure that fzf uses fish to execute __fzf_preview_file.
    # See similar comment in __fzf_search_shell_variables.fish.
    set --local --export SHELL (command --search fish)

    set fd_opts --color=always $fzf_fd_opts
    set fzf_arguments --multi --ansi $fzf_dir_opts
    set token (commandline --current-token)
    # expand any variables or leading tilde (~) in the token
    set expanded_token (eval echo -- $token)
    # unescape token because it's already quoted so backslashes will mess up the path
    set unescaped_exp_token (string unescape -- $expanded_token)

    # If the current token has a leading dot,
    # then include hidden files in the search.
    if string match --quiet -- ".*" $token
        set --append fd_opts --hidden
    end

    # If the current token is a directory and has a trailing slash,
    # then use it as fd's base directory.
    if string match --quiet -- "*/" $token && test -d "$unescaped_exp_token"
        set --append fd_opts --base-directory=$unescaped_exp_token
        # use the directory name as fzf's prompt to indicate the search is limited to that directory
        set --prepend fzf_arguments --prompt="$unescaped_exp_token" --preview="__fzf_preview_file $expanded_token{}"
        set file_paths_selected $unescaped_exp_token(fd $fd_opts 2>/dev/null | fzf $fzf_arguments)
    else
        set --prepend fzf_arguments --query="$unescaped_exp_token" --preview='__fzf_preview_file {}'
        set file_paths_selected (fd $fd_opts 2>/dev/null | fzf $fzf_arguments)
    end


    if test $status -eq 0
        # Fish will implicitly take action on a path when a path is provided as the first token and it
        # begins with a dot or slash. If the path is a directory, Fish will cd into it. If the path is
        # an executable, Fish will execute it. To help users harness this convenient behavior, we
        # automatically prepend ./ to the selected path if
        # - only one path was selected,
        # - the user was in the middle of inputting the first token,
        # - and the path doesn't already begin with a dot or slash
        # Then, the user only needs to hit Enter once more to potentially cd into or execute that path.
        if test (count $file_paths_selected) = 1 \
                && not string match --quiet --regex "^[.|/]" $file_paths_selected
            set commandline_tokens (commandline --tokenize)
            if test "$commandline_tokens" = "$current_token"
                set file_paths_selected ./$file_paths_selected
            end
        end

        commandline --current-token --replace -- (string escape -- $file_paths_selected | string join ' ')
    end

    commandline --function repaint
end
