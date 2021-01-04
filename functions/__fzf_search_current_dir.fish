function __fzf_search_current_dir --description "Search the current directory using fzf and fd. Insert the selected relative file path into the commandline at the cursor."
    # Make sure that fzf uses fish to execute __fzf_preview_file.
    # See similar comment in __fzf_search_shell_variables.fish.
    set --local --export SHELL (command --search fish)
    set file_paths_selected (
        fd --hidden --color=always --exclude=.git 2>/dev/null |
        fzf --multi --ansi --preview='__fzf_preview_file {}' --query=(commandline --current-token)
    )

    if test $status -eq 0
        for path in $file_paths_selected
            set escaped_path (string escape "$path")
            commandline --current-token --replace "$escaped_path "
        end
    end

    commandline --function repaint
end
