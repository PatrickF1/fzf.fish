function _fzf_preview_changed_file
    set -l path (string split ' ' $argv)[-1]
    if string match -r '^\?\?' $argv --quiet
        echo Untracked
        echo
        _fzf_preview_file $path
    else
        if string match -r '\S\s\S' $argv --quiet
            echo -e (set_color red)Unstaged
            echo
            git diff --color=always -- $path
            echo
        end
        if string match -r '^\S' $argv --quiet
            echo -e (set_color green)Staged
            echo
            git diff --color=always --cached HEAD -- $path
        end
    end
end
