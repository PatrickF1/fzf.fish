function _fzf_search_z --description "Search in top visited directories (powered by z)."
    # Make sure that fzf uses fish to execute _fzf_preview_file.
    # See similar comment in _fzf_search_variables.fish.
    set --local --export SHELL (command --search fish)

    set fd_opts --color=always $fzf_fd_opts
    set fzf_arguments --ansi $fzf_z_opts
    set token (commandline --current-token)
    # expand any variables or leading tilde (~) in the token
    set expanded_token (eval echo -- $token)
    # unescape token because it's already quoted so backslashes will mess up the path
    set unescaped_exp_token (string unescape -- $expanded_token)

    set --prepend fzf_arguments --query="$unescaped_exp_token" --preview='_fzf_preview_file {}'
    set file_paths_selected (z --list | sed 's/^[[:digit:]]* *//g' | fzf $fzf_arguments)

    if test $status -eq 0
        cd "$file_paths_selected"
    end

    commandline --function repaint
end
