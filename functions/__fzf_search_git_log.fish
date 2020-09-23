# Originally implemented in and transposed from https://github.com/patrickf3139/dotfiles/pull/2
function __fzf_search_git_log --description "Search the git log of the current git repository. Insert the selected commit hash into the commandline at the cursor."
    # see documentation for git format placeholders at https://git-scm.com/docs/git-log#Documentation/git-log.txt-emnem
    # %h gives you the abbreviated commit hash, which is useful for saving screen space, but we will have to expand it later below
    if not set git_log (git log --color=always --format=format:'%C(bold blue)%h%C(reset) - %C(cyan)%as%C(reset) %C(yellow)%d%C(reset) %C(normal)%s%C(reset)  %C(dim normal)[%an]%C(reset)' 2>/dev/null)
        echo '__fzf_search_git_log: Not in a git repository.' >&2
    else
        set selected_log_line (printf '%s\n' $git_log | fzf --ansi --tiebreak=index --preview='git show --color=always (string split --max 1 " " {})[1]')
        if test $status -eq 0
            set abbreviated_commit_hash (string split --max 1 " " $selected_log_line)[1]
            set commit_hash (git rev-parse $abbreviated_commit_hash)
            commandline --insert $commit_hash
        end
    end

    commandline --function repaint
end
