function _fzf_search_git_status -d "Search the git status of the current git repository. Insert the selected file paths into the commandline at the cursor."
    # Pass configuration color.status=always to force status to use colors even though output is sent to a pipe
    if not set -l gitColorStatus (git -c color.status=always status --short 2>/dev/null)
        echo '_fzf_search_git_status: Not in a git repository.' >&2
    else
        if set -l selectedPaths (printf '%s\n' $gitColorStatus | fzf --ansi --multi)
            # git status --short automatically escapes the paths of most files for us so not going to bother trying to handle
            # the few edges cases of weird file names that should be extremely rare (e.g. "this;needs;escaping")
            for path in $selectedPaths
                if test (string sub --length 1 $path) = 'R'
                    # path has been renamed and looks like "R LICENSE -> LICENSE.md"
                    # extract the path to use from after the arrow
                    set cleanedPath (string split -- "-> " $path)[-1]
                else
                    set cleanedPath (string sub --start=4 $path)
                end
                commandline --insert "$cleanedPath " # add a space after each path to keep them separated when inserted
            end
        end

        commandline --function repaint
    end
end
