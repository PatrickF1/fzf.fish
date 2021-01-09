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
        # If this function was triggered with an empty command line and the only thing selected is a directory, then
        # prepend ./ to the dir path. Because fish will attempt to cd implicitly if a directory name starting with a dot
        # is provided, this allows the user to hit Enter one more time to quickly cd into the selected directory.
        if test (count (commandline --tokenize)) = 0 && test (count $file_paths_selected) = 1 && test -d $file_paths_selected
            set file_paths_selected ./$file_paths_selected
        end

        commandline --current-token --replace (string escape $file_paths_selected | string join ' ')
    end

    commandline --function repaint
end
