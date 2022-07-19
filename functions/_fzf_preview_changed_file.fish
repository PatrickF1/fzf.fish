# helper for _fzf_search_git_status
# arg should be a line from git status --short, something like...
# MM functions/_fzf_preview_changed_file.fish
function _fzf_preview_changed_file
    set -l path (string split ' ' $argv)[-1]
    # first letter of short format shows index, second letter shows working tree
    # https://git-scm.com/docs/git-status/2.35.0#_output
    set -l index_status (string sub --length 1 $argv)
    set -l working_tree_status (string sub --start 2 --length 1 $argv)

    if test $index_status = '?'
        echo -e (set_color --underline)=== Untracked ===\n
        _fzf_preview_file $path
    else
        if test $index_status != ' '
            echo -e (set_color --underline green)=== Staged ===\n
            git diff --color=always --staged -- $path
        end

        if test $working_tree_status != ' '
            echo -e (set_color --underline red)=== Unstaged ===\n
            git diff --color=always -- $path
        end
    end
end
