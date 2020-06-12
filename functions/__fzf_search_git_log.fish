# Fuzzy selector for git commit hash ("sha")
# Put this file in your path and make it xecutable and git can execute it with `git shalector`
# Inspiration: https://github.com/christoomey/dotfiles/issues/105
# Originally implemented and transposed from https://github.com/patrickf3139/dotfiles/pull/2
# Usage:
#    git shalector
function __fzf_search_git_log --description "Search the git log of the current git repository. Insert the selected commits into the commandline at the cursor."
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo 'Not in a git repository.' >&2
        exit 1
    else if [ (count $argv) -gt 0 ]
        echo 'git-shalector does not take any arguments.' >&2
        exit 1
    else if not type -q fzf
        echo "You must have fzf (https://github.com/junegunn/fzf) installed." >&2
        echo "If you are on Mac and use homebrew, try 'brew install fzf'" >&2
        exit 1
    end

    set target_commits (
        git log --color=always --format=format:'%C(bold blue)%H%C(reset) - %C(cyan)%aD%C(reset) %C(yellow)%d%C(reset) %C(normal)%s%C(reset)   %C(dim normal)[%an]%C(reset)' | \
        fzf --multi --ansi --reverse --tiebreak=index
    )

    if [ -z $target_commits ]
        echo 'Cancelled.' >&2
        exit 2
    end

    set commit_hash (echo $target_commits | string sub --start 1 --length 40)

    printf "%s" "$commit_hash" | pbcopy
    echo "Commit hash copied to clipboard ($commit_hash)"
end