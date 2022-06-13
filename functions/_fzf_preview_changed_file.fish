# helper for _fzf_search_git_status
# arg should be a line from git status --short, something like...
# MM functions/_fzf_preview_changed_file.fish
function _fzf_preview_changed_file
    set -l path (string split ' ' $argv)[-1]
    if string match -r '^\?\?' $argv --quiet
        echo -e (set_color --underline)=== Untracked ===\n
        _fzf_preview_file $path
    else
        if string match -r '\S\s\S' $argv --quiet
            echo -e (set_color --underline red)=== Unstaged ===\n
            git diff --color=always -- $path
        end
        if string match -r '^\S' $argv --quiet
            echo -e (set_color --underline green)=== Staged ===\n
            git diff --color=always --staged -- $path
        end
    end
end
