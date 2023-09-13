function _fzf_search_git_stash --description "Search the output of git stash show"
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo '_fzf_search_git_stash: Not in a git repository.' >&2
    else
        if not set --query fzf_git_log_format
            # %h gives you the abbreviated commit hash, which is useful for saving screen space, but we will have to expand it later below
            set fzf_git_log_format '%C(bold blue)%h%C(reset) - %C(cyan)%ad%C(reset) %C(yellow)%d%C(reset) %C(normal)%s%C(reset)  %C(dim normal)[%an]%C(reset)'
        end
        set selected_stash_line (
            git stash list --no-show-signature --color=always --format=format:$fzf_git_log_format --date=short | nl -v 0 -w 3 -s ' ' | \
            _fzf_wrapper --ansi \
                --tiebreak=index \
                --prompt="Search Git Stash> " \
                --preview='git stash show --color=always --stat --patch {2}' \
                --query=(commandline --current-token) \
                $fzf_git_log_opts
        )
        if test $status -eq 0
            set stash_index (string trim $selected_stash_line | string split --field 1 ' ')
            commandline --current-token --replace stash@\{$stash_index\}
        end
    end

    commandline --function repaint
end
