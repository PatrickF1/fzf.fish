function __fzf_search_current_dir --description "Search the current directory using fzf and fd. Insert the selected relative file path into the commandline at the cursor."
    # Make sure that fzf uses fish to execute __fzf_preview_file.
    # See similar comment in __fzf_search_shell_variables.fish.
    set --local --export SHELL (command --search fish)
    set file_paths_selected (
        fd --hidden --color=always --exclude=.git 2>/dev/null |
        fzf --multi --ansi --preview='__fzf_preview_file {}'
    )

    if test $status -eq 0
        if test (count (commandline -poc)) = 0 && test (count $file_paths_selected) = 1 && test -d $file_paths_selected[1]
            set file_paths_selected[1] $file_paths_selected[1]/
        end

        for path in $file_paths_selected
            set escaped_path (string escape "$path")
            commandline --insert "$escaped_path "
        end
    end

    commandline --function repaint
end
