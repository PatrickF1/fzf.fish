function __fzf_search_current_dir --description "Search the current directory. Replace the current token with the selected file paths."
    # Make sure that fzf uses fish to execute __fzf_preview_file.
    # See similar comment in __fzf_search_shell_variables.fish.
    set --local --export SHELL (command --search fish)

    set fd_arguments --hidden --color=always --exclude=.git
    set fzf_arguments --multi --ansi
    set token (commandline --current-token | string unescape)

    # If the current token is a directory and has a trailing slash,
    # then use it as fd's base directory.
    if string match --quiet -- "*/" $token && test -d $token
        set --append fd_arguments --base-directory=$token
        # use the directory name as fzf's prompt to indicate the search is limited to that directory
        set --append fzf_arguments --prompt=$token --preview="__fzf_preview_file $token{}"
        set file_paths_selected $token(fd $fd_arguments 2>/dev/null | fzf $fzf_arguments)
    else
        set --append fzf_arguments --query=$token --preview='__fzf_preview_file {}'
        set file_paths_selected (fd $fd_arguments 2>/dev/null | fzf $fzf_arguments)
    end


    if test $status -eq 0
        # If the user was in the middle of inputting the first token and only one path is selected,
        # then prepend ./ to the selected path so that
        # - if the path is an executable, the user can hit Enter one more time to immediately execute it
        # - if the path is a directory, the user can hit Enter one more time to immediately cd into it (fish will
        #   attempt to cd implicitly if a directory name starts with a dot)
        if test (count $file_paths_selected) = 1
            set commandline_tokens (commandline --tokenize)
            set current_token (commandline --current-token)
            if test "$commandline_tokens" = "$current_token"
                set file_paths_selected ./$file_paths_selected
            end
        end

        set output (string escape -- $file_paths_selected | string join ' ')
        if status is-command-substitution
            printf $output
        else
            commandline --current-token --replace -- $output
        end
    end

    commandline --function repaint
end
