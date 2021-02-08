function __fzf_grep_current_dir --description "Search current directory content for current token. Replace the current token with the selected file paths."
    # Make sure that fzf uses fish.
    set --local --export SHELL (command --search fish)

    set rg_cmd rg --ignore-case --files-with-matches
    set redirect "< /dev/tty > /dev/tty 2>&1"

    set token (commandline --current-token | string unescape)

    set fzf_arguments --multi --exact --disabled --query=$token \
        --preview='rg --smart-case --pretty --context 10 {q} {}' \
        # reload the search when the query cange
        --bind "change:reload:$rg_cmd {q} || true" \
        # launch vim on ctrl-e, if there is a query start a search in vim
        --bind "ctrl-e:execute(if test {q}; vim -c "/{q}" {} $redirect; else; vim {} $redirect; end)" \
        # launch less on ctrl-v, if there is a query start a search in less
        --bind "ctrl-v:execute(if test {q}; less -i -p "{q}" {} $redirect; else; less {} $redirect; end)" \

    set file_paths_selected ($rg_cmd $token | fzf $fzf_arguments)

    if test $status -eq 0
        commandline --current-token --replace -- (string escape -- $file_paths_selected | string join ' ')
    end

    commandline --function repaint
end
