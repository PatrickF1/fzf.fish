function _fzf_search_directory --description "Search the current directory. Replace the current token with the selected file paths."
    # On Ubuntu and other Debian-based Linux distributions, fd binary is installed as fdfind.
    set fd_cmd (command -v fd || command -v fdfind || echo "fd")
    set --append fd_cmd --color=always $fzf_fd_opts

    # $fzf_dir_opts is the deprecated version of $fzf_directory_opts
    set fzf_arguments --multi --ansi $fzf_dir_opts $fzf_directory_opts
    set token (commandline --current-token)
    # expand any variables or leading tilde (~) in the token
    set expanded_token (eval echo -- $token)
    # unescape token because it's already quoted so backslashes will mess up the path
    set unescaped_exp_token (string unescape -- $expanded_token)

    # If the current token is a directory and has a trailing slash,
    # then use it as fd's base directory.
    if string match --quiet -- "*/" $unescaped_exp_token && test -d "$unescaped_exp_token"
        set --append fd_opts --base-directory=$unescaped_exp_token
        # use the directory name as fzf's prompt to indicate the search is limited to that directory
        set --prepend fzf_arguments --prompt="Search Directory $unescaped_exp_token> " --preview="_fzf_preview_file $expanded_token{}"
        set file_paths_selected $unescaped_exp_token($fd_cmd 2>/dev/null | _fzf_wrapper $fzf_arguments)
    else
        set --prepend fzf_arguments --prompt="Search Directory> " --query="$unescaped_exp_token" --preview='_fzf_preview_file {}'
        set file_paths_selected ($fd_cmd 2>/dev/null | _fzf_wrapper $fzf_arguments)
    end


    if test $status -eq 0
        commandline --current-token --replace -- (string escape -- $file_paths_selected | string join ' ')
    end

    commandline --function repaint
end
