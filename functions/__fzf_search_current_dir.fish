function __fzf_search_current_dir --description "Search the current directory using fzf and fd. Insert the selected relative file path into the commandline at the cursor."
    # Make sure that fzf uses fish to execute __fzf_preview_file.
    # See similar comment in __fzf_search_shell_variables.fish.
    set --local --export SHELL (command --search fish)

    set fd_arguments --hidden --color=always --exclude=.git
    set fzf_arguments --multi --ansi --preview='__fzf_preview_file {}'
    set token (commandline --current-token | string unescape)

    # If the token under the cursor is a directory, use it as a base directory.
    if test -d $token && test (count *$token*) = 1
        # Add a trailing slash if not present
        string match --quiet "*/" $token || set token $token/
        set --append fd_arguments --base-directory=$token
        set --append fzf_arguments --prompt=$token
        set file_paths_selected $token(fd $fd_arguments 2>/dev/null | fzf $fzf_arguments)
    else
        set --append fzf_arguments --query=$token
        set file_paths_selected (fd $fd_arguments 2>/dev/null | fzf $fzf_arguments)
    end


    if test $status -eq 0
        # If this function was triggered with an empty commandline and the only thing selected is a directory, then
        # prepend ./ to the dir path. Because fish will attempt to cd implicitly if a directory name starting with a dot
        # is provided, this allows the user to hit Enter one more time to quickly cd into the selected directory.
        if test (count (commandline --tokenize)) = 0 && test (count $file_paths_selected) = 1 && test -d $file_paths_selected
            set file_paths_selected ./$file_paths_selected
        end

        commandline --current-token --replace (string escape $file_paths_selected | string join ' ')
    end

    commandline --function repaint
end
