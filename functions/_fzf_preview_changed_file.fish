# helper for _fzf_search_git_status
# arg should be a line from git status --short, e.g.
# MM functions/_fzf_preview_changed_file.fish
#  D README.md
# R  LICENSE -> "New License"
function _fzf_preview_changed_file --argument-names path_status --description "Show the git diff of the given file."
    # remove quotes because they'll be interpreted literally by git diff
    # no need to requote when referencing $path because fish does not perform word splitting
    # https://fishshell.com/docs/current/fish_for_bash_users.html
    set -l path (string unescape (string sub --start 4 $path_status))
    # first letter of short format shows index, second letter shows working tree
    # https://git-scm.com/docs/git-status/2.35.0#_short_format
    set -l index_status (string sub --length 1 $path_status)
    set -l working_tree_status (string sub --start 2 --length 1 $path_status)

    set diff_opts --color=always

    if test $index_status = '?'
        _fzf_report_diff_type Untracked
        _fzf_preview_file $path
    else if contains {$index_status}$working_tree_status DD AU UD UA DU AA UU
        # Unmerged statuses taken directly from git status help's short format table
        # Unmerged statuses are mutually exclusive with other statuses, so if we see
        # these, then safe to assume the path is unmerged
        _fzf_report_diff_type Unmerged
        git diff $diff_opts -- $path
    else
        if test $index_status != ' '
            _fzf_report_diff_type Staged

            # renames are only detected in the index, never working tree, so only need to test for it here
            # https://stackoverflow.com/questions/73954214
            if test $index_status = R
                # diff the post-rename path with the original path, otherwise the diff will show the entire file as being added
                set orig_and_new_path (string split -- ' -> ' $path)
                git diff --staged $diff_opts -- $orig_and_new_path[1] $orig_and_new_path[2]
                # path currently has the form of "original -> current", so we need to correct it before it's used below
                set path $orig_and_new_path[2]
            else
                git diff --staged $diff_opts -- $path
            end
        end

        if test $working_tree_status != ' '
            _fzf_report_diff_type Unstaged
            git diff $diff_opts -- $path
        end
    end
end
