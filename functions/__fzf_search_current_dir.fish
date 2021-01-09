function __fzf_search_current_dir --description "Search the current directory. Replace the current token with the selected file paths."
    # Make sure that fzf uses fish to execute __fzf_preview_file.
    # See similar comment in __fzf_search_shell_variables.fish.
    set --local --export SHELL (command --search fish)

    set fd_arguments --hidden --color=always --exclude=.git
    set fzf_arguments --multi --ansi
    set token (commandline --current-token | string unescape)

    # If the current token is a directory and has a trailing slash,
    # then use it as fd's base directory.
    if string match --quiet "*/" $token && test -d $token
        set --append fd_arguments --base-directory=$token
        # use the directory name as fzf's prompt to indicate the search is limited to that directory
        set --append fzf_arguments --prompt=$token --preview="__fzf_preview_file $token{}"
        set file_paths_selected $token(fd $fd_arguments 2>/dev/null | fzf $fzf_arguments)
    else
        set --append fzf_arguments --query=$token --preview='__fzf_preview_file {}'
        set file_paths_selected (fd $fd_arguments 2>/dev/null | fzf $fzf_arguments)
    end


    if test $status -eq 0
        # If this function was triggered when the user is inputing the first token and only one path is selected,
        # then prepend ./ to the selected path.
        # If the path is an executable, the user can hit Enter one more time to execute it.
        # If the path is a directory, the user can hit Enter one more time to quickly cd into it, because fish will
        # attempt to cd implicitly if a directory name starts with a dot.
        set first_token_length (string length (commandline --tokenize)[1])

        if test -z "$first_token_length"
            set first_token_length 0
        end

        if test (count $file_paths_selected) = 1 && test (string length (commandline)) = $first_token_length
            set file_paths_selected ./$file_paths_selected
        end

        commandline --current-token --replace (string escape $file_paths_selected | string join ' ')
    end

    commandline --function repaint
end
