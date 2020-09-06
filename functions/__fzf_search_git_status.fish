function __fzf_search_git_status --description "Search the git status of the current git repository. Insert the selected file paths into the commandline at the cursor."
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo '__fzf_search_git_status: Not in a git repository.' >&2
    else
        set selected_paths (
            # Pass configuration color.status=always to force status to use colors even though output is sent to a pipe
            git -c color.status=always status --short |
            fzf --ansi --multi
        )
        if test $status -eq 0
            # don't need to string escape paths because git status automatically handles it for us
            for path in $selected_paths
                commandline --insert (echo $path | string sub --start=3) # todo need to string escape for cases like help\ i\'m\ testing
            end
        end

        commandline --function repaint
    end
end
