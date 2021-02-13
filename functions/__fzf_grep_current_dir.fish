function __fzf_grep_current_dir --description "Search current directory content for current token. Replace the current token with the selected file paths."
    # Make sure that fzf uses fish as shell.
    set --local --export SHELL (command --search fish)

    set rg_cmd rg --color=always --smart-case --no-heading --count --auto-hybrid-regex
    set token (commandline --current-token | string unescape)

    set fzf_arguments --multi --ansi --disabled --delimiter=: --query=$token \
        --preview='rg --smart-case --auto-hybrid-regex --pretty --context 2 {q} {1}' \
        # reload the search when the query change
        --bind "change:reload:$rg_cmd {q} || true"

    set file_paths_selected
    for file in ($rg_cmd $token | fzf $fzf_arguments)
       set --append file_paths_selected (string split : $file)[1]
    end

    if test $status -eq 0
        commandline --current-token --replace -- (string escape -- $file_paths_selected | string join ' ')
    end

    commandline --function repaint
end
