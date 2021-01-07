function __fzf_search_current_dir --description "Search the current directory using fzf and fd. Insert the selected relative file path into the commandline at the cursor."
    # Make sure that fzf uses fish to execute __fzf_preview_file.
    # See similar comment in __fzf_search_shell_variables.fish.
    set --local --export SHELL (command --search fish)
    set file_paths_selected (
        fd --hidden --color=always --exclude=.git 2>/dev/null |
        fzf --multi --ansi --preview='__fzf_preview_file {}' --query=(commandline --current-token)
    )

    if test $status -eq 0
        # If this function was triggered with an empty commandline and the only thing selected is a directory, then
        # prepend ./ to the dir path. Because fish will attempt to cd implicitly if a directory name starting with a dot
        # is provided, this allows the user to hit Enter one more time to quickly cd into the selected directory.
        set first_token_length (string length (commandline --tokenize)[1])

        if test -z "$first_token_length"
            set first_token_length 0
        end

        if test (string length (commandline)) = $first_token_length && test (count $file_paths_selected) = 1 && test -d $file_paths_selected
            set file_paths_selected ./$file_paths_selected
        end

        commandline --current-token --replace (string escape $file_paths_selected | string join ' ')
    end

    commandline --function repaint
end
