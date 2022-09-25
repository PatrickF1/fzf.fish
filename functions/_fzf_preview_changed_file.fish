# helper for _fzf_search_git_status
# arg should be a line from git status --short, e.g.
# MM functions/_fzf_preview_changed_file.fish
#  D README.md
# R  LICENSE.md -> LICENSE
function _fzf_preview_changed_file --description "Show the untracked, staged, and/or unstaged changes in the given file."
    # remove quotes because they'll be interpreted literally by git diff
    # don't requote when referencing $path because fish does not perform word splitting
    # https://fishshell.com/docs/current/fish_for_bash_users.html
    set -l path (string unescape (string sub --start 4 $argv))
    # first letter of short format shows index, second letter shows working tree
    # https://git-scm.com/docs/git-status/2.35.0#_output
    set -l index_status (string sub --length 1 $argv)
    set -l working_tree_status (string sub --start 2 --length 1 $argv)

    if test $index_status = '?'
        _fzf_report_diff_type Untracked
        _fzf_preview_file $path
    else
        # no-prefix because the file is always being compared to itself so is unecessary
        set diff_opts --color=always --no-prefix

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
