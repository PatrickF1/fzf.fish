function __fzf_grep_current_dir --description "Search current directory content for current token. Replace the current token with the selected file paths."
    # Make sure that fzf uses fish as shell.
    set --local --export SHELL (command --search fish)

    set rg_cmd rg --color=always --line-number --smart-case --no-heading
    set token (commandline --current-token | string unescape)

    set fzf_arguments --multi --ansi --delimiter=: --with-nth=1,3 --disabled --query=$token \
        --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
        # center the preview window on the highlighted line
        --preview-window +{2}-/2 \
        # reload the search when the query change
        --bind "change:reload:$rg_cmd {q} || true"

    for file in ($rg_cmd $token | fzf $fzf_arguments)
        set file_paths_selected $file_paths_selected (string split : $file)[1]
    end

    if test $status -eq 0
        commandline --current-token --replace -- (string escape -- $file_paths_selected | string join ' ')
    end

    commandline --function repaint
end
