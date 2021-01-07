function __fzf_search_current_dir --description "Search the current directory using fzf and fd. Insert the selected relative file path into the commandline at the cursor."
    # Make sure that fzf uses fish to execute __fzf_preview_file.
    # See similar comment in __fzf_search_shell_variables.fish.
    set --local --export SHELL (command --search fish)
    set file_paths_selected (
        fd --hidden --color=always --exclude=.git 2>/dev/null |
        fzf --multi --ansi --preview='__fzf_preview_file {}' --query=(commandline --current-token)
    )

    if test $status -eq 0
        # If this function was triggered when the user is inputing the first token and only one path is selected,
        # then prepend ./ to the selected path.
        # If the path is an executable, the user can hit Enter one more time to open it.
        # If the path is a directory, the user can hit Enter one more time to quickly cd into it, because fish will
        # attempt to cd implicitly if a directory name starts with a dot.
        set first_token_length (string length (commandline --tokenize)[1])

        if test -z "$first_token_length"
            set first_token_length 0
        end

        if test (string length (commandline)) = $first_token_length && test (count $file_paths_selected) = 1
            set file_paths_selected ./$file_paths_selected
        end

        commandline --current-token --replace (string escape $file_paths_selected | string join ' ')
    end

    commandline --function repaint
end
