function _fzf_search_git_log --description "Search the output of git log and preview commits. Replace the current token with the selected commit hash."
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo '_fzf_search_git_log: Not in a git repository.' >&2
    else
        # see documentation for git format placeholders at https://git-scm.com/docs/git-log#Documentation/git-log.txt-emnem
        # %h gives you the abbreviated commit hash, which is useful for saving screen space, but we will have to expand it later below
        set log_fmt_str '%C(bold blue)%h%C(reset) - %C(cyan)%ad%C(reset) %C(yellow)%d%C(reset) %C(normal)%s%C(reset)  %C(dim normal)[%an]%C(reset)'
        set selected_log_lines (
            git log --color=always --format=format:$log_fmt_str --date=short | \
            _fzf_wrapper --ansi \
                --multi \
                --tiebreak=index \
                --prompt="Search Git Log> " \
                --preview='git show --color=always --stat --patch {1}' \
                --query=(commandline --current-token) \
                $fzf_git_log_opts
        )
        if test $status -eq 0
            for line in $selected_log_lines
                set abbreviated_commit_hash (string split --field 1 " " $line)
                set full_commit_hash (git rev-parse $abbreviated_commit_hash)
                set --append commit_hashes $full_commit_hash
            end
            commandline --current-token --replace (string join ' ' $commit_hashes)
        end
    end

    commandline --function repaint
end
