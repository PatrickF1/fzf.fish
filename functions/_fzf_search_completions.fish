# External limitations:
# - fish-shell/fish-shell#9577: folders ending in '=' break fish's internal path completion
#   (It thinks that it has to complete from / because `a_folder=/` looks like an argument to fish.
# - fish cannot give reliable context information on completions. Knowing whether a completion
#   is a file or argument can only be determined via a heuristic.
function _fzf_search_completions --description "Shell completion using fzf"
    set -f completions (complete --do-complete)

    set -l fzf_output (
        string join0 -- $completions \
        | _fzf_wrapper \
            --read0 \
            --print0 \
            --ansi \
            --multi \
            --tiebreak=begin \
            --query=$common_prefix \
            --print-query \
            $fzf_complete_description_opts \
        | string split0
    )
    if test $status -eq 0
        # Strip anything after last \t (the descriptions)
        for i in (seq (count $results))
            set results[$i] (string split --fields 1 --max 1 --right \t -- $results[$i])
        end
        commandline --current-token --replace -- (string escape -- $results | string join ' ')
    end
    commandline --function repaint
end
