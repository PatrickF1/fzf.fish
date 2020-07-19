# Originally implemented in and transposed from https://github.com/patrickf3139/dotfiles/pull/2
function __fzf_search_git_log --description "Search the git log of the current git repository. Insert the selected commit sha into the commandline at the cursor."
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo 'Not in a git repository.' >&2
        exit 1
    end

    set selected_commit (
        git log --color=always --format=format:'%C(bold blue)%H%C(reset) - %C(cyan)%aD%C(reset) %C(yellow)%d%C(reset) %C(normal)%s%C(reset)   %C(dim normal)[%an]%C(reset)' | \
        fzf --ansi --reverse --tiebreak=index
    )
    if test $status -eq 0
        commandline --insert $selected_commit
    end

    commandline --function repaint
end
