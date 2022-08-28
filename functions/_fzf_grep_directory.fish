function _fzf_grep_directory --description "Grep the current directory. Replace the current token with the selected file paths."
    set rg_opts --no-heading --line-number --color=always $fzf_rg_opts --

    set fzf_arguments --multi --ansi --phony --delimiter=':' --preview-window='+{2}-/2' $fzf_grep_opts
    set token (commandline --current-token)
    # expand any variables or leading tilde (~) in the token
    set expanded_token (eval echo -- $token)
    # unescape token because it's already quoted so backslashes will mess up the path
    set unescaped_exp_token (string unescape -- $expanded_token)

    set --prepend fzf_arguments --prompt="rg > " --query="$unescaped_exp_token" --preview='_fzf_preview_file {1}' --bind="change:reload:rg $rg_opts 2>/dev/null {q}"
    set file_paths_selected (rg $rg_opts 2>/dev/null | _fzf_wrapper $fzf_arguments | cut -d: -f1)

    if test $status -eq 0
        commandline --current-token --replace -- (string escape -- $file_paths_selected | string join ' ')
    end

    commandline --function repaint
end
