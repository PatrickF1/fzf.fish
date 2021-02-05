function __fzf_grep_current_dir --description "Search current directory content for $token. Replace the current token with the selected file paths."
    # Make sure that fzf uses fish to execute __fzf_preview_file.
    # See similar comment in __fzf_search_shell_variables.fish.
    set --local --export SHELL (command --search fish)

    set rg_cmd rg --ignore-case --files-with-matches
    set redirect "< /dev/tty > /dev/tty 2>&1"

    set token (commandline --current-token | string unescape)

    set fzf_arguments --multi --ansi --exact --phony --query=$token \
        --preview='rg --ignore-case --pretty --context 10 {q} {}' \
        # reload the search when the query cange
        --bind "change:reload:$rg_cmd {q} || true" \
        # launch vim on ctrl-e, if there is a query start a search in vim
        --bind "ctrl-e:execute(if test {q}; vim -c "/{q}" {} $redirect; else; vim {} $redirect; end)" \
        # launch less on ctrl-v, if there is a query start a search in less
        --bind "ctrl-v:execute(if test {q}; less -i -p "{q}" {} $redirect; else; less {} $redirect; end)" \

    set file_paths_selected ($rg_cmd $token | fzf $fzf_arguments)

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

        commandline --current-token --replace -- (string escape -- $file_paths_selected | string join ' ')
    end

    commandline --function repaint
end
