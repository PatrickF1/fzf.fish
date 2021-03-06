function __fzf_search_current_dir --description "Search the current directory. Replace the current token with the selected file paths."
    # Make sure that fzf uses fish to execute __fzf_preview_file.
    # See similar comment in __fzf_search_shell_variables.fish.
    set --local --export SHELL (command --search fish)

    set fd_opts --color=always $fzf_fd_opts
    set fzf_arguments --multi --ansi
    set current_token (commandline --current-token)
    set token (string unescape -- $current_token)
    # need to expand ~ in the directory name since fd can't expand it
    set expanded_token (string replace --regex -- "^~/" $HOME/ $token)

    # If the current token is a directory and has a trailing slash,
    # then use it as fd's base directory.
    if string match --quiet -- "*/" $token && test -d $expanded_token
        set --append fd_opts --base-directory=$expanded_token
        # use the directory name as fzf's prompt to indicate the search is limited to that directory
        set --append fzf_arguments --prompt=$token --preview="__fzf_preview_file $token{}"
        set file_paths_selected $expanded_token(fd $fd_opts 2>/dev/null | fzf $fzf_arguments)
    else
        set --append fzf_arguments --query=$token --preview='__fzf_preview_file {}'
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
