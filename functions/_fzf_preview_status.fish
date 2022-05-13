function _fzf_preview_status
    echo $argv
    set -l path (string split ' ' $argv)[-1]
    echo $path
    if string match -r '^\?\?' $argv >/dev/null
        _fzf_preview_file $path
    else if string match -r '^A' $argv >/dev/null
        git diff --color=always -- /dev/null $path
    else
        if string match -r '[MDTRC] \S' $argv >/dev/null
            echo -e (set_color red)Unstaged
            echo
            git diff --color=always -- $path
            echo
        end
        if string match -r '[AMDTRC][MDTRC ]\S' $argv >/dev/null
            echo -e (set_color green)Staged
            echo
            git diff --color=always --cached HEAD -- $path
        end
    end
end
