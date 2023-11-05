# External limitations:
# - fish-shell/fish-shell#9577: folders ending in '=' break fish's internal path completion
#   (It thinks that it has to complete from / because `a_folder=/` looks like an argument to fish.
# - fish cannot give reliable context information on completions. Knowing whether a completion
#   is a file or argument can only be determined via a heuristic.
function _fzf_search_completions --description "Search the completions for the current command line. Replace the current token with the selected completions."
    set -l selected_completions (
        complete --do-complete | string join0 |
        _fzf_wrapper \
            --read0 \
            --print0 \
            --ansi \
            --multi \
            $fzf_completions_opts \
        | string split0
    )
    if test $status -eq 0
        # Strip away description
        for completion in $selected_completions
            set --append results (string split --fields 1 --max 1 --right \t -- $completion)
        end
        commandline --current-token --replace -- (string escape -- $results | string join ' ')
    end
    commandline --function repaint
end
