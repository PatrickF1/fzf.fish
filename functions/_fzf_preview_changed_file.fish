# helper for _fzf_search_git_status
# arg should be a line from git status --short, e.g.
# MM functions/_fzf_preview_changed_file.fish
#  D README.md
# R  LICENSE.md -> LICENSE
function _fzf_preview_changed_file --argument-names path_status --description "Show the git diff of the given file."
    # remove quotes because they'll be interpreted literally by git diff
    # no need to requote when referencing $path because fish does not perform word splitting
    # https://fishshell.com/docs/current/fish_for_bash_users.html
    set -l path (string unescape (string sub --start 4 $path_status))
    # first letter of short format shows index, second letter shows working tree
    # https://git-scm.com/docs/git-status/2.35.0#_output
    set -l index_status (string sub --length 1 $path_status)
    set -l working_tree_status (string sub --start 2 --length 1 $path_status)
    # no-prefix because the file is always being compared to itself so is unecessary
    set diff_opts --color=always --no-prefix

    if test $index_status = '?'
        _fzf_report_diff_type Untracked
        _fzf_preview_file $path
    else if contains {$index_status}$working_tree_status UD DU UU AA
        # inferred from # https://stackoverflow.com/questions/22792906/how-do-i-produce-every-possible-git-status
        # the above 4 statuses are the only possible ones for a merge conflict
        _fzf_report_diff_type Unmerged
        git diff $diff_opts -- $path
    else
        if test $index_status != ' '
            _fzf_report_diff_type Staged
            git diff --staged $diff_opts -- $path
        end

        if test $working_tree_status != ' '
            _fzf_report_diff_type Unstaged
            git diff $diff_opts -- $path
        end
    end
end
